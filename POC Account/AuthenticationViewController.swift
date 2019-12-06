//
//  AuthenticationViewController.swift
//  POC AccountTests
//
//  Created by Christopher San Diego on 12/6/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import UIKit

class AuthenticationViewController: UIViewController {
    
    private let service: AuthenticationService
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authenticateButton: UIButton!
    
    init(service: AuthenticationService) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func authenticate(_ sender: Any) {
        do {
            _ = try service.authenticate(UserCredential(email: emailTextField.text!, password: passwordTextField.text!))
        } catch {
        }
    }
}
