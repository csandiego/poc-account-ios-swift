//
//  DefaultAuthenticationContext.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/13/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import NIO

class DefaultAuthenticationContext: AuthenticationContext {
    
    private let service: AuthenticationService
    
    init(service: AuthenticationService) {
        self.service = service
    }
    
    private var _userId = 0
    var userId: Int { _userId }
    
    func login(_ credential: UserCredential) -> EventLoopFuture<Bool> {
        return service.authenticate(credential).map { userId in
            self._userId = userId
            return userId > 0
        }
    }
    
    func logout() {
        _userId = 0
    }
    
    
    
}
