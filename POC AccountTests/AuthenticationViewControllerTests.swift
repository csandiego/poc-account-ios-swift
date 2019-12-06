//
//  AuthenticationViewControllerTests.swift
//  POC AccountTests
//
//  Created by Christopher San Diego on 12/6/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import XCTest
@testable import POC_Account

class AuthenticationViewControllerTests: XCTestCase {
    
    private var service: TestAuthenticationService!
    private var controller: AuthenticationViewController!
    private let credential = UserCredential(email: "someone@somewhere.com", password: "password")

    override func setUp() {
        service = TestAuthenticationService()
        controller = AuthenticationViewController(service: service)
        _ = controller.view
    }
    
    func testGivenEmailAndPasswordWhenAuthenticateButtonClickedThenAuthenticateUserCredential() {
        controller.emailTextField.text = credential.email
        controller.passwordTextField.text = credential.password
        controller.authenticate(controller.authenticateButton!)
        XCTAssertEqual(credential, service.authenticateCredential)
    }

    private class TestAuthenticationService: AuthenticationService {
        var authenticateCredential: UserCredential!
        var authenticateError = false
        func authenticate(_ credential: UserCredential) throws -> Int {
            authenticateCredential = credential
            if authenticateError {
                class AuthenticateError: Error {}
                throw AuthenticateError()
            }
            return 1
        }
    }
}
