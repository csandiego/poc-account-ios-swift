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
    private var registrationInProgress = false
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    
    init(service: UserRegistrationService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
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
            isEmailValid = false
            if let email = emailTextField.text, !email.isEmpty {
                let future = service.validate(email)
                future.whenSuccess { valid in
                    self.isEmailValid = valid
                    DispatchQueue.main.async {
                        self.updateRegisterButton()
                    }
                }
                future.whenFailure { _ in
                    self.showNotification("Validation failed")
                }
            }
        }
        updateRegisterButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func register(_ sender: Any) {
        registrationInProgress = true
        let future = service.register(UserCredential(email: emailTextField.text!, password: passwordTextField.text!))
        future.whenSuccess { _ in
            DispatchQueue.main.async {
                self.presentingViewController!.dismiss(animated: true)
            }
        }
        future.whenFailure { _ in
            self.showNotification("Registraion failed")
        }
        future.whenComplete { _ in
            self.registrationInProgress = false
            DispatchQueue.main.async {
                self.updateRegisterButton()
            }
        }
    }
    
    private func updateRegisterButton() {
        registerButton.isEnabled = isEmailValid && !(passwordTextField.text?.isEmpty ?? false) && !registrationInProgress
    }
    
    private func showNotification(_ message: String) {
        let main = DispatchQueue.main
        main.async {
            self.notificationLabel.text = message
            self.notificationLabel.isHidden = false
        }
        main.asyncAfter(deadline: .now() + 3.0) {
            self.notificationLabel.isHidden = true
        }
    }
}
