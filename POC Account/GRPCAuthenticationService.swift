//
//  GRPCAuthenticationService.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/13/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import NIO

class GRPCAuthenticationService : AuthenticationService {
    
    private let client: Protobuf_AuthenticationService
    
    init(client: Protobuf_AuthenticationService) {
        self.client = client
    }
    
    func authenticate(_ credential: UserCredential) -> EventLoopFuture<Int> {
        var request = Protobuf_UserCredential()
        request.email = credential.email
        request.password = credential.password
        return client.authenticate(request, callOptions: nil).response.map { response in
            Int(truncatingIfNeeded: response.userID)
        }
    }

}
