//
//  AuthenticationViewModel.swift
//  Medication
//
//  Created by MAC on 21/04/25.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth


protocol AuthService {
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func register(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    func signOut() throws
}

class FirebaseAuthService: AuthService {
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(email))
            }
        }
    }
    
    func register(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(email))
            }
        }
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}


class AuthenticationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoggedIn = false
    @Published var errorMessage: String?
    
    var loginComplete: ((String) -> Void)? = nil
    var signoutComplete: (() -> Void)? = nil
  
    private let authService: AuthService

    
    //Dependency injection initializer
    init(authService: AuthService = FirebaseAuthService()) {
           self.authService = authService
           
           Auth.auth().addStateDidChangeListener { [weak self] _, user in
               DispatchQueue.main.async {
                   if let user = user {
                       self?.isLoggedIn = true
                       print("User is logged in: \(user.email ?? "No Email")")
                   } else {
                       self?.isLoggedIn = false
                       print("No user is logged in")
                   }
               }
           }
       }

    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.isLoggedIn = false
                self.errorMessage = error.localizedDescription
                print("Registration error: \(error.localizedDescription)")
            } else {
                self.isLoggedIn = true // Registration successful, consider logging them in
                self.errorMessage = "Registration successful!"
                print("Registration successful!")
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.isLoggedIn = false
                self.errorMessage = error.localizedDescription
                print("Login error: \(error.localizedDescription)")
            } else {
                self.isLoggedIn = true
                self.errorMessage = nil
                self.loginComplete?(self.email)
                print("Login successful!")
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            self.isLoggedIn = false
            print("Logged out")
            self.signoutComplete?()
        } catch {
            self.errorMessage = error.localizedDescription
            print("Sign out error: \(error.localizedDescription)")
        }
    }
}
