//
//  APICaller.swift
//  MeetPeople
//
//  Created by ROHIT MISHRA on 14/08/23.
//

import Foundation

struct Constants {
    static let baseURL = "https://app.aisle.co/V1"
}

final class APIService {
    static let shared = APIService()
    
    private init() {}
}

enum APIError: Error {
    case invalidURL
    case decorededError
    case networkError
    case invalidStatusCode
    case authTokenError
    case invalidData
}

// MARK: - public methods

extension APIService {
    public func getOTPFor(phoneNumber: String, completion: @escaping(Result<PhoneNumberResponse, Error>) -> Void) {
        let endPoint = "/users/phone_number_login"
        guard let url = URL(string: Constants.baseURL + endPoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let requestModel = PhoneNumberRequest(number: "+91" + phoneNumber)
        
        guard let requestData = try? JSONEncoder().encode(requestModel) else {
            completion(.failure(APIError.decorededError))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                      error == nil  else {
                    completion(.failure(APIError.networkError))
                    return
                  }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                completion(.failure(APIError.invalidStatusCode))
            }
            
            if let responseData = try? JSONDecoder().decode(PhoneNumberResponse.self, from: data) {
                completion(.success(responseData))
            }
        }
        task.resume()
    }
    
    public func getAuthTokenFrom(phoneNumber: String, otp: String, completion: @escaping(Result<OTPReponse, Error>) -> Void) {
        let endPoint = "/users/verify_otp"
        guard let url = URL(string: Constants.baseURL + endPoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let requestModel = OTPRequest(number: phoneNumber, otp: otp)
        
        guard let requestData = try? JSONEncoder().encode(requestModel) else {
            completion(.failure(APIError.decorededError))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = requestData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                      error == nil  else {
                    completion(.failure(APIError.networkError))
                    return
                  }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                completion(.failure(APIError.invalidStatusCode))
            }

            if let responseData = try? JSONDecoder().decode(OTPReponse.self, from: data) {
                completion(.success(responseData))
            }
        }
        task.resume()
    }
    
    public func fetchNoteViewData(authToken: String, completion: @escaping(Result<ProfileData, Error>) -> Void) {
        let endpoint = "/users/test_profile_list"
        guard let url = URL(string: Constants.baseURL + endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue(authToken, forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, _,error in
            guard let data = data,
                  error == nil else {
                    completion(.failure(APIError.networkError))
                      return
                  }
            do {
                let results = try JSONDecoder().decode(ProfileData.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(APIError.invalidData))
            }
        }
        task.resume()
    }
}
