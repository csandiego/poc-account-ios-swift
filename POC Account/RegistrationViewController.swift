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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
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
        registerButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        do {
            registerButton.isEnabled = try service.validate(emailTextField.text!)
        } catch {
        }
    }

    @IBAction func register(_ sender: Any) {
        do {
            let credential = UserCredential(email: emailTextField.text!, password: passwordTextField.text!)
            try service.register(credential)
        } catch {
        }
    }
}
