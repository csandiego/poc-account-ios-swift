//
//  AppComponent.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/13/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import Cleanse
import GRPC

struct AppComponent: Cleanse.RootComponent {

    static func configure(binder: Binder<Unscoped>) {
        binder.bind(ClientConnection.self).to { () -> ClientConnection in
            ClientConnection(configuration: ClientConnection.Configuration(
                target: .hostAndPort("192.168.2.12", 8000),
                eventLoopGroup: PlatformSupport.makeEventLoopGroup(loopCount: 1, networkPreference: .userDefined(.posix))
            ))
        }
        binder.bind(Protobuf_UserRegistrationService.self)
            .to { (connection: ClientConnection) -> Protobuf_UserRegistrationService in
                Protobuf_UserRegistrationServiceClient(connection: connection)
            }
        binder.bind(Protobuf_AuthenticationService.self)
            .to { (connection: ClientConnection) -> Protobuf_AuthenticationService in
                Protobuf_AuthenticationServiceClient(connection: connection)
            }
        binder.bind(UserRegistrationService.self).to(factory: GRPCUserRegistrationService.init)
        binder.bind(AuthenticationService.self).to(factory: GRPCAuthenticationService.init)
        binder.bind(AuthenticationContext.self).to(factory: DefaultAuthenticationContext.init)
        binder.bind(RegistrationViewController.self).to(factory: RegistrationViewController.init)
        binder.bind(LoginViewController.self).to(factory: LoginViewController.init)
    }
    
    static func configureRoot(binder bind: ReceiptBinder<HomeViewController>) -> BindingReceipt<HomeViewController> {
        bind.to(factory: HomeViewController.init)
    }
    
    typealias Root = HomeViewController
    
}
