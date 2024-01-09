//
//  LogInModel.swift
//  TensorFlow_Case_Study
//
//  Created by Hakan Baran on 8.01.2024.
//

import Foundation

struct LogInModel: Codable {
    let succededd: Bool?
    let data: LoginDataResponse?
    let errorCoders: Int?
}

struct LoginDataResponse: Codable {
    let accessToken: TokenResponse?
}

struct TokenResponse: Codable {
    let token: String?
    let expiresIn: String?
}

struct LogInRequestModel: Codable {
    let organizationCode: String?
    let email: String?
    let password: String?
}
