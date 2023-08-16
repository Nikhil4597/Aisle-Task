//
//  ProfileData.swift
//  MeetPeople
//
//  Created by ROHIT MISHRA on 15/08/23.
//

import Foundation

struct ProfileData: Codable {
    let invites: Invites
    let likes: Likes
}

struct Invites: Codable {
    let profiles: [Profile]
}

struct Likes: Codable {
    let profiles: [LikedProfile]
    let canSeeProfile: Bool
    
    enum CodingKeys: String, CodingKey {
        case profiles
        case canSeeProfile = "can_see_profile"
    }
}

struct Profile: Codable {
    let generalInformation: GeneralInformation
    let photos: [Photo]
    let hasActiveSubscription: Bool
    
    enum CodingKeys: String, CodingKey {
        case generalInformation = "general_information"
        case photos
        case hasActiveSubscription = "has_active_subscription"
    }
}

struct GeneralInformation: Codable {
    let firstName: String
    let age: Int
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case age
    }
}

struct Photo: Codable {
    let photo: String
    let selected: Bool
}

struct LikedProfile: Codable {
    let firstName: String
    let avatar: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case avatar
    }
}
