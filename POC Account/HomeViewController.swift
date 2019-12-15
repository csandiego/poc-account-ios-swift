//
//  HomeViewController.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/10/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import Cleanse
import UIKit

class HomeViewController: UIViewController {

    private let context: AuthenticationContext
    private let provider: Provider<LoginViewController>
    @IBOutlet weak var userIdLabel: UILabel!
    
    init(context: AuthenticationContext, provider: Provider<LoginViewController>) {
        self.context = context
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.isHidden = context.userId == 0
        userIdLabel.text = String(context.userId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if context.userId == 0 {
            present(provider.get(), animated: true)
        }
    }

}
