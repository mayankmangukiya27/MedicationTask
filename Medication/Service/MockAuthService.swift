//
//  MockAuthService.swift
//  Medication
//
//  Created by SHUBHAM on 23/04/25.
//

import Foundation


class MockAuthService: AuthService {
    var shouldSucceed = true

    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldSucceed {
            completion(.success(email))
        } else {
            completion(.failure(MockError.loginFailed))
        }
    }

    func register(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        if shouldSucceed {
            completion(.success(email))
        } else {
            completion(.failure(MockError.registrationFailed))
        }
    }

    func signOut() throws {
        if !shouldSucceed {
            throw MockError.signOutFailed
        }
    }

    enum MockError: Error {
        case loginFailed
        case registrationFailed
        case signOutFailed
    }
}
