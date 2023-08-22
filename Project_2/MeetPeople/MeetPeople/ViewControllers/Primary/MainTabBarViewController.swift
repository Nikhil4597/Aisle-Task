//
//  ViewController.swift
//  MeetPeople
//
//  Created by ROHIT MISHRA on 14/08/23.
//

import UIKit

enum CurrentIndex: Int {
    case Discover = 0
    case Notes
    case Matches
    case Profile
}

class MainTabBarViewController: UITabBarController {
    private var profileData:ProfileData? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        
        view.backgroundColor = .systemBackground
        setupTabs()
        tabBar.tintColor = .label
    }
    
    override var selectedIndex: Int {
        didSet {
            switch selectedIndex {
            case CurrentIndex.Notes.rawValue:
                updateNoteViewController(index: selectedIndex)
            default:
                break
            }
        }
    }
}

// MARK: - Public methods
extension MainTabBarViewController {
    public func configureProfileData(profileData: ProfileData) {
        self.profileData = profileData
    }
}

// MARK: - Private methods
extension MainTabBarViewController {
    private func setupTabs() {
        let discoverViewController = createNavigationBar(
            viewController: DiscoverViewController(),
            image: UIImage(systemName: "rectangle.grid.2x2.fill"), title: "Discover")
        
        let notesViewController = createNavigationBar(viewController: NotesViewController(), image: UIImage(systemName: "envelope.fill"), title: "Notes")
        
        let matchesViewController = createNavigationBar(viewController: MatchesViewController(), image: UIImage(systemName: "message.fill"), title: "Matches")
        
        let profileViewController = createNavigationBar(viewController: ProfileViewController(), image: UIImage(systemName: "person.fill"), title: "Profile''")
        
        viewControllers = [discoverViewController, notesViewController, matchesViewController, profileViewController]
    }
    
    private func createNavigationBar(viewController: UIViewController, image: UIImage?, title: String) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = image
        navigationController.title = title
        return navigationController
    }
    
    private func updateNoteViewController(index: Int) {
        let viewcontrollers = viewControllers ?? []
        
        if let navigationController = viewcontrollers[1] as? UINavigationController {
            if let notesViewController = navigationController.viewControllers.first as? NotesViewController {
                notesViewController.configure(profileData: profileData)
            }
        }
    }
}
