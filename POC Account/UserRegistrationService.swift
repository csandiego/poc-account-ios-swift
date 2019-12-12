//
//  UserRegistrationService.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/6/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import NIO

protocol UserRegistrationService {
    func validate(_ email: String) -> EventLoopFuture<Bool>
    func register(_ credential: UserCredential) -> EventLoopFuture<Void>
}
