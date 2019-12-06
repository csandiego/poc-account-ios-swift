//
//  AuthenticationService.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/6/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

protocol AuthenticationService {
    func authenticate(_ credential: UserCredential) throws -> Int
}
