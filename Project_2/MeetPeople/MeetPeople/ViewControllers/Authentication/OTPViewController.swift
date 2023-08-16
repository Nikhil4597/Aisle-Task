//
//  OTPViewController.swift
//  MeetPeople
//
//  Created by ROHIT MISHRA on 14/08/23.
//

import UIKit

class OTPViewController: UIViewController {
    private let primaryLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pencil"), for: .normal)
        button.tintColor = .label
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter The \nOTP"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let OTPText: UITextField = {
        let textView = UITextField()
        textView.text = ""
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 18, weight: .bold)
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.layer.backgroundColor = UIColor(red: 0.976, green: 0.796, blue: 0.063, alpha: 1).cgColor
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let countDownLabel: UILabel = {
       let label = UILabel()
        label.text = "00:59"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var totalSeconds = 59
    var countdownTimer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        view.backgroundColor = .systemBackground
        configureAction()
        let subiews = [primaryLabel, editButton, secondaryLabel, OTPText, continueButton, countDownLabel]
        for subview in subiews {
            view.addSubview(subview)
        }
        
        setupUI()
    }
    
    // MARK: - Subview constrainsts
    
    private func setupUI() {
        let leadingArcherConstant = 30.0
        
        // Primary button constraints
        NSLayoutConstraint.activate([
            primaryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            primaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingArcherConstant),
        ])
        
        // edit button constraints
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 84),
            editButton.leadingAnchor.constraint(equalTo: primaryLabel.trailingAnchor, constant: 7),
            editButton.widthAnchor.constraint(equalToConstant: 14),
            editButton.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        // Secondary button constraints
        NSLayoutConstraint.activate([
            secondaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingArcherConstant),
            secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor, constant: 8)
        ])
        
        // OTP text constraints
        NSLayoutConstraint.activate([
            OTPText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingArcherConstant),
            OTPText.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: 12),
            OTPText.widthAnchor.constraint(equalToConstant: 78),
            OTPText.heightAnchor.constraint(equalToConstant: 36),
        ])
        
        // Continue button texr constraints
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            continueButton.widthAnchor.constraint(equalToConstant: 96),
            continueButton.heightAnchor.constraint(equalToConstant: 40),
            continueButton.topAnchor.constraint(equalTo: OTPText.bottomAnchor, constant: 19)
        ])
        
        // Count time constraints
        NSLayoutConstraint.activate([
            countDownLabel.topAnchor.constraint(equalTo: OTPText.bottomAnchor, constant: 37),
            countDownLabel.leadingAnchor.constraint(equalTo: continueButton.trailingAnchor, constant: 12),
            countDownLabel.widthAnchor.constraint(equalToConstant: 42),
            countDownLabel.heightAnchor.constraint(equalToConstant: 17)
        ])
    }
}

// MARK: - Public methods
extension OTPViewController {
    public func configure(phoneNumber: String) {
        primaryLabel.text = "+91" + phoneNumber
    }
}

// MARK: - Private methods

extension OTPViewController {
    private func configureAction() {
        editButton.addTarget(self, action: #selector(editPhoneNumberButtonTapped), for: .touchUpInside)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        countdownTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
    }

    @objc private func continueButtonTapped() {
        APIService.shared.getAuthTokenFrom(phoneNumber: primaryLabel.text ?? "", otp: OTPText.text ?? "") { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            
            switch result {
            case .success(let response):
                APIService.shared.fetchNoteViewData(authToken: response.token) { result in
                    switch result {
                    case .success(let profileData):
                        DispatchQueue.main.async {
                            strongSelf.setupNextScreen(model: profileData, index: 1)
                        }
                    case .failure(let error):
                        print("Error: \(error.localizedDescription)")
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func editPhoneNumberButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func updateCountdown() {
        if totalSeconds > 0 {
            totalSeconds -= 1
            updateCountdownLabel()
        } else {
            stopCountdownTimer()
        }
    }

    private func updateCountdownLabel() {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        countDownLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func stopCountdownTimer() {
            countdownTimer?.invalidate()
            countdownTimer = nil
        }
    
    private func setupNextScreen(model:ProfileData, index: Int) {
        let mainTabBarViewController = MainTabBarViewController()
        mainTabBarViewController.configureProfileData(profileData: model)
        mainTabBarViewController.selectedIndex = index
        navigationController?.pushViewController(mainTabBarViewController, animated: true)
    }
}
