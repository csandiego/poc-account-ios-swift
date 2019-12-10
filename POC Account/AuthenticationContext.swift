//
//  AuthenticationContext.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/10/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

protocol AuthenticationContext {
    
    var userId: Int { get }
    
    func login(_ credential: UserCredential) throws -> Bool
    
    func logout()
}
