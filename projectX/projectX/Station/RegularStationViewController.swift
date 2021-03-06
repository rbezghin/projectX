//
//  RegularStationViewController.swift
//  projectX
//
//  Created by Radomyr Bezghin on 2/10/21.
//  Copyright © 2021 Radomyr Bezghin. All rights reserved.
//

import UIKit

class RegularStationViewController: BaseStationViewController {
    //TODO: implement two different feeds!
    ///collectionViewController responsible for the feed.
    private var popularFeedController: FeedCollectionViewController!
    private var newFeedController: FeedCollectionViewController!
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    override func setupFeedsWithUserData(_ user: User?){
        popularFeedController.setupFeed(feedType: .lounge(self.station.id), userID: user?.id)
        newFeedController.setupFeed(feedType: .busStop(self.station.id), userID: user?.id)
    }
    override func setupSegmentedStackWithFeeds(){
        newFeedController = FeedCollectionViewController()
        popularFeedController = FeedCollectionViewController()
        self.addChild(popularFeedController)
        self.addChild(newFeedController)
        popularFeedController.didScrollFeedDelegate = self
        newFeedController.didScrollFeedDelegate = self
        feedSegmentedControl.stackView.addArrangedSubview(popularFeedController.view)
        feedSegmentedControl.stackView.addArrangedSubview(newFeedController.view)
    }
    override func setFeedNames(){
        feedSegmentedControl.itemNames = ["Lounge", "New"]
    }
}
