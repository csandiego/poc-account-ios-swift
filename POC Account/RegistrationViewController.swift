//
//  RegistrationViewController.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/6/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController, UITextFieldDelegate {
    
    private let service: UserRegistrationService
    private var isEmailValid = false
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    
    init(service: UserRegistrationService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        registerButton.isEnabled = false
        notificationLabel.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            if let email = emailTextField.text {
                do {
                    isEmailValid = try service.validate(email)
                } catch {
                    isEmailValid = false
                    showNotification("Validation Failed")
                }
            } else {
                isEmailValid = false
            }
        }
        registerButton.isEnabled = isEmailValid && !(passwordTextField.text?.isEmpty ?? false)
    }

    @IBAction func register(_ sender: Any) {
        do {
            let credential = UserCredential(email: emailTextField.text!, password: passwordTextField.text!)
            try service.register(credential)
        } catch {
            showNotification("Registration Failed")
        }
    }
    
    private func showNotification(_ message: String) {
        notificationLabel.text = message
        notificationLabel.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.notificationLabel.isHidden = true
        }
    }
}
