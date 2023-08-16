//
//  InviteProfileView.swift
//  MeetPeople
//
//  Created by ROHIT MISHRA on 15/08/23.
//

import UIKit

class InviteProfileView: UICollectionReusableView {
    static let identifier = "InviteProfile"
    
    private let imageCache: NSCache<NSString, UIImage> = NSCache()
    
    private let headerTitle: UILabel = {
        let label = UILabel()
        label.text = "Personal messages to you"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let primaryImageLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondaryImageLabel: UILabel = {
       let label = UILabel()
        label.text = "Tap to review 50+ notes"
        label.textColor = .white
        label.font = .systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let premiumPrimaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Interested In You"
        label.textColor = .black
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let premiumSecondaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Premium members can view all their likes at once"
        label.textColor = UIColor(red: 0.608, green: 0.608, blue: 0.608, alpha: 1)
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let upgradeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Upgrade", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = UIColor(red: 0.976, green: 0.796, blue: 0.063, alpha: 1).cgColor
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - UI Constraints
    private func setupUIConstraints() {
        let leadingArcherConstant = 36.06
        
        // Header label constraints
        NSLayoutConstraint.activate([
            headerTitle.topAnchor.constraint(equalTo: topAnchor),
            headerTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerTitle.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        // Profile image view constraints
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: headerTitle.bottomAnchor, constant: 12),
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingArcherConstant/2),
            profileImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -leadingArcherConstant/2),
            profileImageView.heightAnchor.constraint(equalToConstant: 572)
        ])
        
        // Primary image label constraints
        NSLayoutConstraint.activate([
            primaryImageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 334),
            primaryImageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingArcherConstant),
        ])
        
        // Secondary image label constraints
        NSLayoutConstraint.activate([
            secondaryImageLabel.topAnchor.constraint(equalTo: primaryImageLabel.bottomAnchor, constant: 5),
            secondaryImageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingArcherConstant)
        ])
        
        // Premium primary label constraints
        NSLayoutConstraint.activate([
            premiumPrimaryLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 12),
            premiumPrimaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingArcherConstant),
            
        ])
        
        // Premium secondary label constraints
        NSLayoutConstraint.activate([
            premiumSecondaryLabel.topAnchor.constraint(equalTo: premiumPrimaryLabel.bottomAnchor, constant: 5),
            premiumSecondaryLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingArcherConstant),
            premiumSecondaryLabel.widthAnchor.constraint(equalToConstant: 192)
        ])
        
        // upgrade button constraints
        NSLayoutConstraint.activate([
            upgradeButton.leadingAnchor.constraint(equalTo: premiumSecondaryLabel.trailingAnchor, constant: 24),
            upgradeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15)
        ])
    }
}

// MARK: - Public methods
extension InviteProfileView {
    public func configure(profileModel: Profile) {
        setupUIView()
        let imageString = profileModel.photos.filter({
            return $0.selected == true
        })
        
        configureProfileImageView(imageString: imageString[0].photo)
        configurePrimaryView(name: profileModel.generalInformation.firstName, age: profileModel.generalInformation.age)
        configurePremiumView(isPremiumAccount: profileModel.hasActiveSubscription)
    }
}


// MARK: - Private methods
extension InviteProfileView {
    private func setupUIView() {
        let subviews = [headerTitle, profileImageView, premiumPrimaryLabel, premiumSecondaryLabel, upgradeButton]
        
        for subview in subviews {
            addSubview(subview)
        }
        
        profileImageView.addSubview(primaryImageLabel)
        profileImageView.addSubview(secondaryImageLabel)
        
        setupUIConstraints()
    }
    
    private func configureProfileImageView(imageString: String) {
        guard let url = URL(string: imageString) else {
            return
        }

        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            profileImageView.image = cachedImage
            return
        }
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data,
                      let strongSelf = self,
                      let image = UIImage(data: data) else {
                    return
                }

                DispatchQueue.global().async {
                    strongSelf.imageCache.setObject(image, forKey: url.absoluteString as NSString)
                }
                
                DispatchQueue.main.async {
                    strongSelf.profileImageView.image = image
                }
            }
        task.resume()
    }
    
    private func configurePrimaryView(name: String, age: Int) {
        primaryImageLabel.text = "\(name), \(age)"
    }
    
    private func configurePremiumView(isPremiumAccount: Bool) {
        if isPremiumAccount {
            premiumPrimaryLabel.frame = .zero
            premiumSecondaryLabel.frame = .zero
            upgradeButton.frame = .zero
            
            let subviews = [premiumPrimaryLabel, premiumSecondaryLabel, upgradeButton]
            
            for subview in subviews {
                subview.removeFromSuperview()
            }
        }
    }
}
