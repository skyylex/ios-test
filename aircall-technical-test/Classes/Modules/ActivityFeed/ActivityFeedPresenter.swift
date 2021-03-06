//
//  ActivityFeedPresenter.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 08/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation

protocol ActivityFeedPresenterOutputs {
    func fetchActivityFeed(completion: @escaping (Result<[CallDetails], NSError>) -> Void)
}

final class ActivityFeedPresenter: ActivityFeedViewOutputs {
    private weak var view: ActivityFeedViewInputs?
    private let router: ActivityFeedRouterInputs
    private let output: ActivityFeedPresenterOutputs
    private var onDidAppearAction = {}
    private var canUpdateView: Bool = false
    private let mapper = ActivityFeedMapper()
    
    init(view: ActivityFeedViewInputs,
         router: ActivityFeedRouterInputs,
         output: ActivityFeedPresenterOutputs) {
        self.view = view
        self.router = router
        self.output = output
    }
    
    // MARK: ActivityFeedViewOutputs
    func viewWillAppear() {
        requestUpdate()
    }
    
    func viewDidAppear() {
        canUpdateView = true
        
        let attributedTitle = NSAttributedString(string: "Pull to refresh")
        view?.setPullControlTitle(title: attributedTitle)
        onDidAppearAction()
    }
    
    func viewDidDisappear() {
        canUpdateView = false
    }
    
    func callSelected(_ call: ActivityFeedItem) {
        guard let callDetails = call.userInfo as? CallDetails else {
            preconditionFailure("ActivityFeedItem should keep call details")
        }
        
        router.showCallDetails(call: callDetails)
    }
    
    func requestUpdate() {
        view?.resultMessage = nil
        view?.loadingStarted()
        
        output.fetchActivityFeed { [weak self] result in
            switch result {
            case .success(let calls):
                self?.updateView(with: calls, message: nil)
            case .failure(let error):
                self?.updateView(with: [], message: "\(error.localizedDescription)")
            }
        }
    }
    
    // MARK: Private
    
    private func updateView(with calls: [CallDetails], message: String?) {
        view?.resultMessage = message
        
        let sections = mapper.map(calls: calls)
        let updateViewAction = {
            DispatchQueue.main.async { [weak self] in
                self?.view?.setFeedSections(sections: sections)
            }
        }
        
        if canUpdateView {
            updateViewAction()
        } else {
            onDidAppearAction = updateViewAction
        }
    }
    
}

final class ActivityFeedMapper {
    private static let numberOfSecondsPerDay = (3600 * 24)
    
    private var todayMidnightInSeconds: Int {
        return secondsOfDateRoundedToMidnight(date: Date())
    }
    
    private var yesterdayMidnightInSeconds: Int {
        return todayMidnightInSeconds - ActivityFeedMapper.numberOfSecondsPerDay
    }
    
    private var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        return dateFormatter
    }()
    
    private var timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        return timeFormatter
    }()
    
    private func secondsOfDateRoundedToMidnight(date: Date) -> Int {
        let dateInSeconds = Int(date.timeIntervalSince1970)
        let timeInSeconds = Int(dateInSeconds) % ActivityFeedMapper.numberOfSecondsPerDay
        return dateInSeconds - timeInSeconds
    }
    
    typealias SpecificDayInSeconds = Int
    typealias CombinedFeedItems = [SpecificDayInSeconds : [ActivityFeedItem]]
    
    private func feedItem(from call: CallDetails, timeFormatter: DateFormatter) -> ActivityFeedItem {
        let time = timeFormatter.string(from: call.creationDate)
        let phone = call.from
        
        return ActivityFeedItem(phoneNumber: phone,
                                time: time,
                                details: call.type.rawValue,
                                userInfo: call)
    }
    
    /// Combines calls by specific day (represented as midnight in seconds)
    private func combine(calls: [CallDetails]) -> CombinedFeedItems {
        return calls.reduce(CombinedFeedItems()) { (combinedCalls, call) -> CombinedFeedItems in
            let item = feedItem(from: call, timeFormatter: timeFormatter)
            let specificDayInSeconds = secondsOfDateRoundedToMidnight(date: call.creationDate)
            
            let otherItems = combinedCalls[specificDayInSeconds] ?? []
            var mutableCombinedCalls = combinedCalls
            mutableCombinedCalls[specificDayInSeconds] = otherItems + [item]
            return mutableCombinedCalls
        }
    }
    
    func map(calls: [CallDetails]) -> [ActivityFeedSection] {
        let combinedCalls = combine(calls: calls)
        let sortedCalls = combinedCalls.sorted { (pair1, pair2) -> Bool in
            let (dayInSeconds1, _) = pair1
            let (dayInSeconds2, _) = pair2
            return dayInSeconds1 > dayInSeconds2
        }
        
        return sortedCalls.map { (pair) -> ActivityFeedSection in
            let (dateSeconds, calls) = pair
            
            switch dateSeconds {
            case todayMidnightInSeconds:
                return ActivityFeedSection(title: "TODAY", items: calls)
            case yesterdayMidnightInSeconds:
                return ActivityFeedSection(title: "YESTERDAY", items: calls)
            default:
                let date = Date(timeIntervalSince1970: TimeInterval(dateSeconds))
                let title = dateFormatter.string(from: date)
                return ActivityFeedSection(title: title, items: calls)
            }
        }
    }
}
