//
//  GRPCUserRegistrationService.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/11/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

class GRPCUserRegistrationService : UserRegistrationService {
    
    private let client: Protobuf_UserRegistrationService
    
    init(client: Protobuf_UserRegistrationService) {
        self.client = client
    }

    func validate(_ email: String) throws -> Bool {
        var request = Protobuf_ValidationRequest()
        request.email = email
        return try client.validate(request, callOptions: nil).response.wait().valid
    }
    
    func register(_ credential: UserCredential) throws {
        var request = Protobuf_UserCredential()
        request.email = credential.email
        request.password = credential.password
        _ = try client.register(request, callOptions: nil).response.wait()
    }
    
}
