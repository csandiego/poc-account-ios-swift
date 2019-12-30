//
//  AppComponent.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/13/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import Apollo
import Cleanse
import GRPC
import UIKit

struct AppComponent: Cleanse.RootComponent {

    static func configure(binder: Binder<Singleton>) {
        binder.bind().sharedInScope().to { () -> ClientConnection in
            ClientConnection(configuration: ClientConnection.Configuration(
                target: .hostAndPort("192.168.2.12", 8000),
                eventLoopGroup: PlatformSupport.makeEventLoopGroup(loopCount: 1, networkPreference: .userDefined(.posix))
            ))
        }
        binder.bind(Protobuf_UserRegistrationService.self).sharedInScope()
            .to { (connection: ClientConnection) -> Protobuf_UserRegistrationService in
                Protobuf_UserRegistrationServiceClient(connection: connection)
            }
        binder.bind(Protobuf_AuthenticationService.self).sharedInScope()
            .to { (connection: ClientConnection) -> Protobuf_AuthenticationService in
                Protobuf_AuthenticationServiceClient(connection: connection)
            }
        binder.bind(ApolloClient.self).sharedInScope()
            .to { () -> ApolloClient in
                ApolloClient(url: URL(string: "http://192.168.2.12:8080/graphql")!)
            }
        
        binder.bind(UserRegistrationService.self).sharedInScope().to(factory: GRPCUserRegistrationService.init)
        binder.bind(AuthenticationService.self).sharedInScope().to(factory: GRPCAuthenticationService.init)
        binder.bind(AuthenticationContext.self).sharedInScope().to(factory: DefaultAuthenticationContext.init)
        binder.bind(UserProfileService.self).sharedInScope().to(factory: ApolloUserProfileService.init)
        
        binder.bind().to(factory: RegistrationViewController.init)
        binder.bind().to(factory: LoginViewController.init)
        binder.bind().to(factory: HomeViewController.init)
        
        binder.bind().to { (root: HomeViewController) -> UIWindow in
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = root
            return window
        }
    }
    
    static func configureRoot(binder bind: ReceiptBinder<PropertyInjector<AppDelegate>>) -> BindingReceipt<PropertyInjector<AppDelegate>> {
        bind.propertyInjector { bind in
            bind.to(injector: AppDelegate.injectProperties)
        }
    }
    
}
