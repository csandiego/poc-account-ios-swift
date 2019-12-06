//
//  RegistrationViewControllerTests.swift
//  POC AccountTests
//
//  Created by Christopher San Diego on 12/6/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import XCTest
@testable import POC_Account

class RegistrationViewControllerTests: XCTestCase {
    
    private var service: TestUserRegistrationService!
    private var controller: RegistrationViewController!
    private let credential = UserCredential(email: "someone@somewhere.com", password: "password")

    override func setUp() {
        service = TestUserRegistrationService()
        controller = RegistrationViewController(service: service)
        _ = controller.view
    }

    func testGivenEmailWhenEmailEnteredThenValidateEmail() {
        controller.emailTextField.text = credential.email
        controller.textFieldDidEndEditing(controller.emailTextField)
        XCTAssertEqual(credential.email, service.validateEmail)
    }
    
    func testGivenInvalidEmailWhenEmailEnteredThenDisableRegisterButton() {
        service.validateResult = false
        controller.emailTextField.text = credential.email
        controller.textFieldDidEndEditing(controller.emailTextField)
        XCTAssertFalse(controller.registerButton.isEnabled)
    }
    
    func testGivenValidEmailWhenEmailEnteredThenEnableRegisterButton() {
        service.validateResult = true
        controller.emailTextField.text = credential.email
        controller.textFieldDidEndEditing(controller.emailTextField)
        XCTAssertTrue(controller.registerButton.isEnabled)
    }
    
    func testGivenValidEmailAndPasswordWhenRegisterThenRegisterUserCredential() {
        service.validateResult = true
        controller.emailTextField.text = credential.email
        controller.passwordTextField.text = credential.password
        controller.register(controller.registerButton!)
        XCTAssertEqual(credential, service.registerCredential)
    }
    
    private class TestUserRegistrationService: UserRegistrationService {
        var validateEmail: String!
        var validateResult = false
        var validateError = false
        var registerCredential: UserCredential!
        var registerError = false
        func validate(_ email: String) throws -> Bool {
            validateEmail = email
            if validateError {
                class ValidateError: Error {}
                throw ValidateError()
            }
            return validateResult
        }
        func register(_ credential: UserCredential) throws {
            registerCredential = credential
            if registerError {
                class RegisterError: Error {}
                throw RegisterError()
            }
        }
    }
}
