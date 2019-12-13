//
//  DefaultAuthenticationContextTests.swift
//  POC AccountTests
//
//  Created by Christopher San Diego on 12/13/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import NIO
import XCTest
@testable import POC_Account

class DefaultAuthenticationContextTests: XCTestCase {
    
    private var service: TestAuthenticationService!
    private var context: DefaultAuthenticationContext!
    private let credential = UserCredential(email: "someone@somewhere.com", password: "password")

    override func setUp() {
        service = TestAuthenticationService()
        context = DefaultAuthenticationContext(service: service)
    }
    
    func testGivenValidCredentialWhenLoginThenReturnTrue() {
        service.authenticateResult = 1
        XCTAssertTrue(try! context.login(credential).wait())
    }
    
    func testGivenValidCredentialWhenLoginThenSetUserId() {
        service.authenticateResult = 1
        _ = try! context.login(credential).wait()
        XCTAssertEqual(1, context.userId)
    }
    
    func testGivenLoggedInWhenLogoutThenResetUserId() {
        service.authenticateResult = 1
        _ = try! context.login(credential).wait()
        context.logout()
        XCTAssertEqual(0, context.userId)
    }

    private class TestAuthenticationService: AuthenticationService {
        
        private let eventLoop: EventLoop
        var authenticateResult = 0
        
        init() {
            eventLoop = EmbeddedEventLoop()
        }
        
        func authenticate(_ credential: UserCredential) -> EventLoopFuture<Int> {
            return eventLoop.makeSucceededFuture(authenticateResult)
        }

    }

}
