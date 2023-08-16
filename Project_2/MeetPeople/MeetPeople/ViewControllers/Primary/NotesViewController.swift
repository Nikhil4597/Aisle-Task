//
//  NotesViewController.swift
//  MeetPeople
//
//  Created by ROHIT MISHRA on 14/08/23.
//

import UIKit

class NotesViewController: UIViewController {
    struct Constraints {
        static let numberOfItemsInRow: CGFloat = 2
        static let spacing: CGFloat = 20
        static let sectionInsets = UIEdgeInsets(top: 20, left: 5, bottom: 10, right: 5)
    }
    
    private let numberOfSection = 1
    
    private let titleLabel: UILabel = {
       let titleLabel = UILabel()
        titleLabel.text = "Notes"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .black
        return titleLabel
    }()
    
    private let collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
                layout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(InviteProfileView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InviteProfileView.identifier)
        
        collectionView.register(LikedProfileCell.self, forCellWithReuseIdentifier: LikedProfileCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var profileModel: ProfileData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationItem.titleView = titleLabel
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self

        viewConstraints()
    }
    
    // MARK: - View Constraints
    private func viewConstraints() {
        // Collection view constrainst
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo:view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: UICollectionViewDataSource
extension NotesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Profile model in numberof Item \(profileModel)")
        print("Number of items: \(self.profileModel?.likes.profiles.count ?? 0)")
        return self.profileModel?.likes.profiles.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numberOfSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LikedProfileCell.identifier, for: indexPath) as? LikedProfileCell else {
            return UICollectionViewCell()
        }
        
        guard let likedProfile = self.profileModel?.likes.profiles[indexPath.row],
              let canSeeProfile = self.profileModel?.likes.canSeeProfile
        else {
            return UICollectionViewCell()
        }
        cell.configure(profile: likedProfile, canSeeProfile: canSeeProfile)
      return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: InviteProfileView.identifier, for: indexPath) as? InviteProfileView else {
            return UICollectionReusableView()
        }

        guard let profileModel = profileModel?.invites.profiles[indexPath.row] else {
            return UICollectionReusableView()
        }

        header.configure(profileModel: profileModel)

        return header
    }
    
}

// MARK: UICollectionViewDelegate
extension NotesViewController: UICollectionViewDelegate {
    
}

// MARK: UICollectionViewDelegateFlowLayout
extension NotesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.bounds.width - Constraints.sectionInsets.left - Constraints.sectionInsets.right - (Constraints.numberOfItemsInRow - 1) * Constraints.spacing
        let cellWidth = availableWidth/Constraints.numberOfItemsInRow
        return CGSize(width: cellWidth, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let headerWidth = collectionView.bounds.width
        let headerHeight: CGFloat = 572
        return CGSize(width: headerWidth, height: headerHeight)
    }
}



// MARK: Public methods

extension NotesViewController {
    public func configure(profileData: ProfileData?) {
        guard let profileData = profileData else {
            return
        }
        
            profileModel = profileData
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.collectionView.reloadData()
        }
    }
}
