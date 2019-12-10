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
        loginButton.isEnabled = !(emailTextField.text?.isEmpty ?? false) && !(passwordTextField.text?.isEmpty ?? false)
    }
    
    @IBAction func login(_ sender: Any) {
        do {
            if try context.login(UserCredential(email: emailTextField.text!, password: passwordTextField.text!)) {
            } else {
                showNotification("Invalid Email/Password")
            }
        } catch {
            showNotification("Login Failed")
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
