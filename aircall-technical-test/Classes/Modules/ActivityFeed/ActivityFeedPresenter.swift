//
//  ActivityFeedPresenter.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 08/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation

enum Direction: String {
    case inbound = "inbound"
    case outbound = "outbound"
}

enum CallType: String {
    case missed = "missed"
    case answered = "answered"
    case voicemail = "voicemail"
}

struct CallDetails {
    
    let id: Int
    let creationDate: Date
    let direction: Direction
    let from: String
    let to: String?
    let via: String
    let duration: Int
    var isArchived: Bool
    let type: CallType
}

protocol ActivityFeedPresenterOutputs {
    func fetchActivityFeed(completion: @escaping (Result<[CallDetails], Error>) -> Void)
}

final class ActivityFeedPresenter: ActivityFeedViewOutputs {
    private weak var view: ActivityFeedViewInputs?
    private let router: ActivityFeedRouterInputs
    private let output: ActivityFeedPresenterOutputs
    private var onDidAppearAction = {}
    private var canUpdateView: Bool = false
    
    init(view: ActivityFeedViewInputs,
         router: ActivityFeedRouterInputs,
         output: ActivityFeedPresenterOutputs) {
        self.view = view
        self.router = router
        self.output = output
        
        output.fetchActivityFeed { [weak self] result in
            switch result {
            case .success(let calls):
                self?.updateView(with: calls)
            case .failure(let error):
                self?.updateView(with: [])
            }
        }
    }
    
    func viewDidAppear() {
        canUpdateView = true
        
        onDidAppearAction()
    }
    
    func viewDidDisappear() {
        canUpdateView = false
    }
    
    /// Cached calls should be used only for Routing
    private func updateView(with calls: [CallDetails]) {
        let sections = map(calls: calls)
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
    
    // MARK: ActivityFeedViewOutputs
    func callSelected(_ call: ActivityFeedItem) {
        guard let callDetails = call.userInfo as? CallDetails else {
            preconditionFailure("ActivityFeedItem should keep call details")
        }
        
        router.showCallDetails(call: callDetails)
    }
    
}

private extension ActivityFeedPresenter {
    func secondsOfDateRoundedToMidnight(date: Date) -> Int {
        let dateInSeconds = Int(date.timeIntervalSince1970)
        let timeInSeconds = Int(dateInSeconds) % 3600 * 24
        return dateInSeconds - timeInSeconds
    }
    
    func map(calls: [CallDetails]) -> [ActivityFeedSection] {
        let todaysMidnightInSeconds = Int(Date().timeIntervalSince1970)
        let yesterdaysMidnightInSeconds = todaysMidnightInSeconds - 3600 * 24
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        let callsMap = calls.reduce([Int : [ActivityFeedItem]]()) { (combined, current) -> [Int : [ActivityFeedItem]] in
            let time = timeFormatter.string(from: current.creationDate)
            let phone = current.from
            
            let item = ActivityFeedItem(phoneNumber: phone,
                                        time: time,
                                        details: current.type.rawValue,
                                        userInfo: current)
            let key = secondsOfDateRoundedToMidnight(date: current.creationDate)
            
            let otherItems = combined[key] ?? []
            var mutableCallsMap = combined
            mutableCallsMap[key] = otherItems + [item]
            return mutableCallsMap
        }
        
        return callsMap.map { (arg) -> ActivityFeedSection in
            
            let (dateSeconds, calls) = arg
            
            switch dateSeconds {
            case todaysMidnightInSeconds:
                return ActivityFeedSection(title: "TODAY", items: calls)
            case yesterdaysMidnightInSeconds:
                return ActivityFeedSection(title: "YESTERDAY", items: calls)
            default:
                let date = Date(timeIntervalSince1970: TimeInterval(dateSeconds))
                let title = dateFormatter.string(from: date)
                return ActivityFeedSection(title: title, items: calls)
            }
        }
    }
}
