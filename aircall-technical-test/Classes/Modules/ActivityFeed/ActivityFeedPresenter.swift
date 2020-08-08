//
//  ActivityFeedPresenter.swift
//  aircall-technical-test
//
//  Created by Yury Lapitsky on 08/08/2020.
//  Copyright © 2020 Yury Lapitsky. All rights reserved.
//

import Foundation

final class ActivityFeedPresenter: ActivityFeedViewOutputs {
    let view: ActivityFeedViewInputs
    let router: ActivityFeedRouterInputs
    
    init(view: ActivityFeedViewInputs, router: ActivityFeedRouterInputs) {
        self.view = view
        self.router = router
        
        view.setFeedSections(sections: [
            ActivityFeedSection(
                title: "TODAY",
                items: [
                    ActivityFeedItem(phoneNumber: "+1-315-643-321",
                                     time: "12:18 PM",
                                     details: "left a voicemail"),
                    ActivityFeedItem(phoneNumber: "+1-315-233-321",
                                     time: "3:18 PM",
                                     details: "by Kalvin. B (you)"),
                    ActivityFeedItem(phoneNumber: "+1-323-233-321",
                                     time: "10:18 PM",
                                     details: "missed call"),
            ]),
            ActivityFeedSection(
                title: "YESTERDAY",
                items: [
                    ActivityFeedItem(phoneNumber: "+1-315-643-321",
                                     time: "13:18 PM",
                                     details: "left a voicemail"),
                    ActivityFeedItem(phoneNumber: "+1-315-233-321",
                                     time: "4:18 PM",
                                     details: "by Kalvin. B (you)"),
                    ActivityFeedItem(phoneNumber: "+1-323-233-321",
                                     time: "11:18 PM",
                                     details: "missed call"),
            ])
        ])
    }
    
    // MARK: ActivityFeedViewOutputs
    func callSelected(at indexPath: IndexPath) {
        // TODO: provide real call object
        router.showCallDetails()
    }
}
