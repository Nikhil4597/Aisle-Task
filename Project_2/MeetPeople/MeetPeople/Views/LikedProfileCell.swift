//
//  LikedProfileCell.swift
//  MeetPeople
//
//  Created by ROHIT MISHRA on 15/08/23.
//

import UIKit

class LikedProfileCell: UICollectionViewCell {
    static let identifier = "LinkedProfileCell"
    
    private let imageCache: NSCache<NSString, UIImage> = NSCache()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.alpha = 0
        return blurView
    }()
    
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 22, weight: .heavy)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.frame = contentView.bounds
    }
    
    // MARK: - UI view constraints
    private func setupUIConstraints() {
        
        // Blur view constraints
        NSLayoutConstraint.activate([
            blurView.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: profileImageView.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: profileImageView.bottomAnchor)
        ])
        
        // First name constraints
        NSLayoutConstraint.activate([
            firstNameLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 15),
            firstNameLabel.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -11)
        ])
    }
}

// MARK: - Public methods
extension LikedProfileCell {
    public func configure(profile: LikedProfile, canSeeProfile: Bool) {
        setupUIView()
        
        if canSeeProfile {
            blurView.alpha = 1
        }
        
        configureProfileImage(imageString: profile.avatar)
        configureFirstNameLabel(firstName: profile.firstName)
    }
}

// MARK: - Private methods
extension LikedProfileCell {
    private func setupUIView() {
        layer.cornerRadius = 5
        profileImageView.layer.cornerRadius = 5
        contentView.addSubview(profileImageView)
        contentView.addSubview(blurView)
        contentView.addSubview(firstNameLabel)
        setupUIConstraints()
    }
    private func configureProfileImage(imageString: String) {
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
    
    private func configureFirstNameLabel(firstName: String) {
        firstNameLabel.text = firstName
    }
}
