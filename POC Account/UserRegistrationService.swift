//
//  UserRegistrationService.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/6/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

protocol UserRegistrationService {
    func validate(_ email: String) throws -> Bool
    func register(_ credential: UserCredential) throws
}
