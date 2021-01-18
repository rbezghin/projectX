//
//  HomeTableVC.swift
//  projectX
//
//  Created by Radomyr Bezghin on 6/15/20.
//  Copyright © 2020 Radomyr Bezghin. All rights reserved.
//
//
import UIKit
import FirebaseAuth

class HomeTableVC: UIViewController, UISearchBarDelegate{
    
    ///collectionViewController responsible for the feed.
    private var feedCollectionViewController: FeedCollectionViewController!
    
    //TODO: not implemented (searching isn't straightforward with firestore)
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupFeedController()
        setUserAndSubscribeToUpdates()
        presentLoginIfNeeded()
    }
    private func setupFeedController(){
        feedCollectionViewController = FeedCollectionViewController()
        self.add(feedCollectionViewController)//add feedController as a child
    }
    private func setUserAndSubscribeToUpdates(){
        switch UserManager.shared().state {
        case .loading:
            print("user is loading ")//wait for update
        case .signedIn(let user):
            self.user = user
            feedCollectionViewController.setupFeed(feedType: .generalFeed, userID: user.id ?? nil)
        case .signedOut:
            print("display nothing")//display default data
            feedCollectionViewController.setupFeed(feedType: .generalFeed)
        }
        UserManager.shared().didResolveUserState = { user in
            self.user = user
            self.feedCollectionViewController.setupFeed(feedType: .generalFeed, userID: user?.id ?? nil)
        }
    }
    
}
//MARK: - Navigation Bar setup
extension HomeTableVC{
    override func viewWillAppear(_ animated: Bool) {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = Constants.Colors.mainYellow
        navBarAppearance.shadowImage = UIImage()
        navBarAppearance.shadowColor = .clear
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
    }
    private func setupNavigationBar(){
        self.navigationItem.title = "Home"
        navigationItem.searchController = searchController
        //navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
    }
}
//MARK: - SideBarStationSelectionDelegate
extension HomeTableVC: SideBarStationSelectionDelegate{
    func didTapSidebar(station: Station) {
        switch station.stationType {
        case .parentStation:
            let vc = ParentStationViewController()
            vc.station = station
            navigationController?.pushViewController(vc, animated: true)
        default:
            let vc = StationViewController()
            vc.station = station
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
//MARK: - Navigation
extension HomeTableVC{
    ///when app is loaded and user isnt signed in, login screen is presented
    private func presentLoginIfNeeded(){
        if Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let navvc = UINavigationController(rootViewController: vc)
            navvc.modalPresentationStyle = .fullScreen
            self.tabBarController?.present(navvc, animated: true)
        }
    }
}
