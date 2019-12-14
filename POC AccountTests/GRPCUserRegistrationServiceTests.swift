//
//  GRPCUserRegistrationServiceTests.swift
//  POC AccountTests
//
//  Created by Christopher San Diego on 12/14/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import GRPC
import NIO
import XCTest
@testable import POC_Account

class GRPCUserRegistrationServiceTests: XCTestCase {
    
    private var serverGroup: EventLoopGroup!
    private var clientGroup: EventLoopGroup!
    private var server: Server!
    private var conn: ClientConnection!
    private var provider: TestUserRegistrationProvider!
    private var service: GRPCUserRegistrationService!
    private let credential = UserCredential(email: "someone@somewhere.com", password: "password")

    override func setUp() {
        serverGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        provider = TestUserRegistrationProvider()
        server = try! Server.start(configuration: Server.Configuration(target: .hostAndPort("localhost", 0), eventLoopGroup: serverGroup, serviceProviders: [provider])).wait()
        
        clientGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        conn = ClientConnection(configuration: ClientConnection.Configuration(target: .hostAndPort("localhost", server.channel.localAddress!.port!), eventLoopGroup: clientGroup))
        let client = Protobuf_UserRegistrationServiceClient(connection: conn)
        service = GRPCUserRegistrationService(client: client)
    }

    override func tearDown() {
        try! conn.close().wait()
        try! clientGroup.syncShutdownGracefully()
        
        try! server.close().wait()
        try! serverGroup.syncShutdownGracefully()
    }
    
    func testWhenValidateThenWrapEmail() {
        _ = try! service.validate(credential.email).wait()
        XCTAssertEqual(credential.email, provider.validateRequest.email)
    }
    
    func testWhenValidateThenUnwrapValid() {
        provider.validateResult = true
        XCTAssertEqual(provider.validateResult, try! service.validate(credential.email).wait())
    }
    
    func testWhenRegisterThenCopyCredential() {
        _ = try! service.register(credential).wait()
        XCTAssertEqual(credential.email, provider.registerRequest.email)
        XCTAssertEqual(credential.password, provider.registerRequest.password)
    }

    private class TestUserRegistrationProvider: Protobuf_UserRegistrationProvider {
        
        var validateRequest: Protobuf_ValidationRequest!
        var validateResult = false
        var registerRequest: Protobuf_UserCredential!
        
        func validate(request: Protobuf_ValidationRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Protobuf_ValidationResponse> {
            validateRequest = request
            var response = Protobuf_ValidationResponse()
            response.valid = validateResult
            return context.eventLoop.makeSucceededFuture(response)
        }
        
        func register(request: Protobuf_UserCredential, context: StatusOnlyCallContext) -> EventLoopFuture<Protobuf_Empty> {
            registerRequest = request
            return context.eventLoop.makeSucceededFuture(Protobuf_Empty())
        }
        
        
    }

}
