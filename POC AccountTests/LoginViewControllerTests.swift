//
//  LoginViewControllerTests.swift
//  POC AccountTests
//
//  Created by Christopher San Diego on 12/10/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

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
        XCTAssertFalse(controller.notificationLabel.isHidden)
    }
    
    func testGivenServiceIssuesWhenLoginThenShowNotification() {
        context.loginResult = true
        context.loginError = true
        controller.emailTextField.text = credential.email
        controller.passwordTextField.text = credential.password
        controller.login(controller.loginButton!)
        XCTAssertFalse(controller.notificationLabel.isHidden)
    }
    
    private class TestAuthenticationContext : AuthenticationContext {
        
        var mutableUserId = 0
        var userId: Int { return mutableUserId }
        
        var loginCredential: UserCredential!
        var loginResult = false
        var loginError = false
        func login(_ credential: UserCredential) throws -> Bool {
            loginCredential = credential
            if loginError {
                class LoginError: Error {}
                throw LoginError()
            }
            return loginResult
        }
        
        func logout() {
        }
    }

}
