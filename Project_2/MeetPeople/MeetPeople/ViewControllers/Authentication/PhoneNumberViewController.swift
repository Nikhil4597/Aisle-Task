//
//  PhoneNumberViewController.swift
//  MeetPeople
//
//  Created by ROHIT MISHRA on 14/08/23.
//

import UIKit

class PhoneNumberViewController: UIViewController {
    private let primaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Get OTP"
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Your\nPhone Number"
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countryCode: UITextField = {
        let textView = UITextField()
        textView.text = "+91"
        textView.textAlignment = .center
        textView.font = .systemFont(ofSize: 18, weight: .bold)
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1).cgColor
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let phoneNumberText: UITextField = {
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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        
        let subiews = [primaryLabel, secondaryLabel, countryCode, phoneNumberText, continueButton]
        for subview in subiews {
            view.addSubview(subview)
        }
        
        setupUIConstraints()
    }
    
    // MARK: - Subview constrainsts
    
    private func setupUIConstraints() {
        let leadingArcherConstant = 30.0
        
        // Primary button constraints
        NSLayoutConstraint.activate([
            primaryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            primaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingArcherConstant)
        ])
        
        // Secondary button constraints
        NSLayoutConstraint.activate([
            secondaryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingArcherConstant),
            secondaryLabel.topAnchor.constraint(equalTo: primaryLabel.bottomAnchor, constant: 8)
        ])
        
        // Country code text constraints
        NSLayoutConstraint.activate([
            countryCode.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: 12),
            countryCode.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingArcherConstant),
            countryCode.widthAnchor.constraint(equalToConstant: 64),
            countryCode.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        // phone number text constraints
        NSLayoutConstraint.activate([
            phoneNumberText.topAnchor.constraint(equalTo: secondaryLabel.bottomAnchor, constant: 12),
            phoneNumberText.leadingAnchor.constraint(equalTo: countryCode.trailingAnchor, constant: 8),
            phoneNumberText.widthAnchor.constraint(equalToConstant: 147),
            phoneNumberText.heightAnchor.constraint(equalToConstant: 36)
        ])
        
        // Continue button texr constraints
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            continueButton.widthAnchor.constraint(equalToConstant: 96),
            continueButton.heightAnchor.constraint(equalToConstant: 40),
            continueButton.topAnchor.constraint(equalTo: phoneNumberText.bottomAnchor, constant: 19)
        ])
    }
}

// MARK: - Private methods
extension PhoneNumberViewController {
    @objc private func continueButtonTapped() {
        APIService.shared.getOTPFor(phoneNumber: phoneNumberText.text!) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let data):
                if data.status {
                    DispatchQueue.main.async {
                        let otpViewController = OTPViewController()
                        otpViewController.configure(phoneNumber: strongSelf.phoneNumberText.text ?? "Not Valid")
                        strongSelf.navigationController?.pushViewController(otpViewController, animated: true)
                    }
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

