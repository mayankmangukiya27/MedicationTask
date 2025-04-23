//
//  Test.swift
//  MedicationTests
//
//  Created by SHUBHAM on 23/04/25.
//

import Testing
import XCTest
@testable import Medication

final class AuthenticationViewModelTestss: XCTestCase {

    func testSuccessfulLogin() {
        let mockService = MockAuthService()
        mockService.shouldSucceed = true

        let viewModel = AuthenticationViewModel(authService: mockService)
        viewModel.email = "test@gmail.com"
        viewModel.password = "12121212"

        let expectation = XCTestExpectation(description: "Login completes")

        viewModel.login()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(viewModel.isLoggedIn)
            XCTAssertNil(viewModel.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testFailedLogin() {
        let mockService = MockAuthService()
        mockService.shouldSucceed = false

        let viewModel = AuthenticationViewModel(authService: mockService)
        viewModel.email = "fail@example.com"
        viewModel.password = "badpass"

        let expectation = XCTestExpectation(description: "Login fails")

        viewModel.login()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertFalse(viewModel.isLoggedIn)
            XCTAssertNotNil(viewModel.errorMessage)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
