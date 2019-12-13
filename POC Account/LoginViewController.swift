//
//  LoginViewController.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/10/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private let context: AuthenticationContext
    private var loginInProgress = false
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    
    init(context: AuthenticationContext) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        loginButton.isEnabled = false
        notificationLabel.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateLoginButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func login(_ sender: Any) {
        loginInProgress = true
        let future = context.login(UserCredential(email: emailTextField.text!, password: passwordTextField.text!))
        future.whenSuccess { valid in
            if valid {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.showNotification("Invalid username/password")
            }
        }
        future.whenFailure { _ in
            self.showNotification("Login failed")
        }
        future.whenComplete { _ in
            self.loginInProgress = false
            DispatchQueue.main.async {
                self.updateLoginButton()
            }
        }
    }
    
    private func updateLoginButton() {
        loginButton.isEnabled = !(emailTextField.text?.isEmpty ?? false) && !(passwordTextField.text?.isEmpty ?? false) && !loginInProgress
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
