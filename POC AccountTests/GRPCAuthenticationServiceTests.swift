//
//  GRPCAuthenticationServiceTests.swift
//  POC AccountTests
//
//  Created by Christopher San Diego on 12/14/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import GRPC
import NIO
import XCTest
@testable import POC_Account

class GRPCAuthenticationServiceTests: XCTestCase {
    
    private var serverGroup: EventLoopGroup!
    private var clientGroup: EventLoopGroup!
    private var server: Server!
    private var conn: ClientConnection!
    private var provider: TestAuthenticationProvider!
    private var service: GRPCAuthenticationService!
    private let credential = UserCredential(email: "someone@somewhere.com", password: "password")

    override func setUp() {
        serverGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        provider = TestAuthenticationProvider()
        server = try! Server.start(configuration: Server.Configuration(target: .hostAndPort("localhost", 0), eventLoopGroup: serverGroup, serviceProviders: [provider])).wait()
        
        clientGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
        conn = ClientConnection(configuration: ClientConnection.Configuration(target: .hostAndPort("localhost", server.channel.localAddress!.port!), eventLoopGroup: clientGroup))
        let client = Protobuf_AuthenticationServiceClient(connection: conn)
        service = GRPCAuthenticationService(client: client)
    }

    override func tearDown() {
        try! conn.close().wait()
        try! clientGroup.syncShutdownGracefully()
        
        try! server.close().wait()
        try! serverGroup.syncShutdownGracefully()
    }
    
    func testWhenAuthenticateThenCopyCredential() {
        _ = try! service.authenticate(credential).wait()
        XCTAssertEqual(credential.email, provider.authenticateCredential.email)
        XCTAssertEqual(credential.password, provider.authenticateCredential.password)
    }
    
    func testWhenAuthenticateThenUnwrapUserId() {
        provider.authenticateResult = 1
        XCTAssertEqual(provider.authenticateResult, try! service.authenticate(credential).wait())
    }

    private class TestAuthenticationProvider: Protobuf_AuthenticationProvider {
        
        var authenticateCredential: Protobuf_UserCredential!
        var authenticateResult = 0
        
        func authenticate(request: Protobuf_UserCredential, context: StatusOnlyCallContext) -> EventLoopFuture<Protobuf_AuthenticationResponse> {
            authenticateCredential = request
            var response = Protobuf_AuthenticationResponse()
            response.userID = Int64(authenticateResult)
            return context.eventLoop.makeSucceededFuture(response)
        }

    }

}
