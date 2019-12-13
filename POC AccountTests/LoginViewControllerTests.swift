//
//  LoginViewControllerTests.swift
//  POC AccountTests
//
//  Created by Christopher San Diego on 12/10/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import NIO
import XCTest
@testable import POC_Account

class LoginViewControllerTests: XCTestCase {
    
    private var context: TestAuthenticationContext!
    private var controller: LoginViewController!
    private let credential = UserCredential(email: "someone@somewhere.com", password: "password")

    override func setUp() {
        context = TestAuthenticationContext()
        controller = LoginViewController(context: context)
        _ = controller.view
    }
    
    func testWhenEmailEmptyAndPasswordEmptyThenDisableLoginButton() {
        controller.emailTextField.text = ""
        controller.textFieldDidEndEditing(controller.emailTextField)
        controller.passwordTextField.text = ""
        controller.textFieldDidEndEditing(controller.passwordTextField)
        XCTAssertFalse(controller.loginButton.isEnabled)
    }
    
    func testWhenEmailEmptyAndPasswordNotEmptyThenDisableLoginButton() {
        controller.emailTextField.text = ""
        controller.textFieldDidEndEditing(controller.emailTextField)
        controller.passwordTextField.text = credential.password
        controller.textFieldDidEndEditing(controller.passwordTextField)
        XCTAssertFalse(controller.loginButton.isEnabled)
    }
    
    func testWhenEmailNotEmptyAndPasswordEmptyThenDisableLoginButton() {
        controller.emailTextField.text = credential.email
        controller.textFieldDidEndEditing(controller.emailTextField)
        controller.passwordTextField.text = ""
        controller.textFieldDidEndEditing(controller.passwordTextField)
        XCTAssertFalse(controller.loginButton.isEnabled)
    }
    
    func testWhenEmailNotEmptyAndPasswordNotEmptyThenEnableLoginButton() {
        controller.emailTextField.text = credential.email
        controller.textFieldDidEndEditing(controller.emailTextField)
        controller.passwordTextField.text = credential.password
        controller.textFieldDidEndEditing(controller.passwordTextField)
        XCTAssertTrue(controller.loginButton.isEnabled)
    }
    
    func testGivenValidCredentialWhenLoginThenNavigateUp() {
        
    }
    
    func testGivenInvalidCredentialWhenLoginThenShowNotification() {
        context.loginResult = false
        context.loginError = false
        controller.emailTextField.text = credential.email
        controller.passwordTextField.text = credential.password
        controller.login(controller.loginButton!)
        let expectation = self.expectation(description: "TEST")
        DispatchQueue.main.async {
            XCTAssertFalse(self.controller.notificationLabel.isHidden)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGivenServiceIssuesWhenLoginThenShowNotification() {
        context.loginResult = true
        context.loginError = true
        controller.emailTextField.text = credential.email
        controller.passwordTextField.text = credential.password
        controller.login(controller.loginButton!)
        let expectation = self.expectation(description: "TEST")
        DispatchQueue.main.async {
            XCTAssertFalse(self.controller.notificationLabel.isHidden)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    private class TestAuthenticationContext : AuthenticationContext {
        
        private let eventLoop: EventLoop
        var mutableUserId = 0
        var userId: Int { return mutableUserId }
        var loginCredential: UserCredential!
        var loginResult = false
        var loginError = false
        
        init() {
            eventLoop = EmbeddedEventLoop()
        }
        
        func login(_ credential: UserCredential) -> EventLoopFuture<Bool> {
            loginCredential = credential
            class LoginError: Error {}
            return loginError ? eventLoop.makeFailedFuture(LoginError()) : eventLoop.makeSucceededFuture(loginResult)
        }
        
        func logout() {
        }
    }

}
