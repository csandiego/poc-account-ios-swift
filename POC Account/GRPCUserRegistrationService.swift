//
//  GRPCUserRegistrationService.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/11/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import NIO

class GRPCUserRegistrationService : UserRegistrationService {
    
    private let client: Protobuf_UserRegistrationService
    
    init(client: Protobuf_UserRegistrationService) {
        self.client = client
    }

    func validate(_ email: String) -> EventLoopFuture<Bool> {
        var request = Protobuf_ValidationRequest()
        request.email = email
        return client.validate(request, callOptions: nil).response.map { response in
            return response.valid
        }
    }
    
    func register(_ credential: UserCredential) -> EventLoopFuture<Void> {
        var request = Protobuf_UserCredential()
        request.email = credential.email
        request.password = credential.password
        return client.register(request, callOptions: nil).response.map { response in
        }
    }
    
}
