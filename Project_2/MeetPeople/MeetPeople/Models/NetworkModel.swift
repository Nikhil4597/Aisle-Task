//
//  NetworkModel.swift
//  MeetPeople
//
//  Created by ROHIT MISHRA on 14/08/23.
//

import Foundation

struct PhoneNumberRequest: Codable {
    let number: String
}

struct PhoneNumberResponse: Codable {
    let status: Bool
}

struct OTPRequest: Codable {
    let number: String
    let otp: String
}

struct OTPReponse: Codable {
    let token: String
}
