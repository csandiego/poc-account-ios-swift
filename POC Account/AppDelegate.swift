//
//  AppDelegate.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/6/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import UIKit

import GRPC
import NIOTransportServices

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let conn = provideClientConnection()
        let userRegistrationClient = provideUserRegistrationClient(conn)
        let userRegistrationService = provideUserRegistrationService(userRegistrationClient)
        let registrationViewController = provideRegistrationViewController(userRegistrationService)
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = registrationViewController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
    
    private func provideClientConnection() -> ClientConnection {
        return ClientConnection(configuration: ClientConnection.Configuration(
            target: .hostAndPort("192.168.2.12", 8000),
            eventLoopGroup: NIOTSEventLoopGroup()
        ))
    }
    
    private func provideUserRegistrationClient(_ connection: ClientConnection) -> Protobuf_UserRegistrationService {
        return Protobuf_UserRegistrationServiceClient(connection: connection)
    }
    
    private func provideUserRegistrationService(_ client: Protobuf_UserRegistrationService) -> UserRegistrationService {
        return GRPCUserRegistrationService(client: client)
    }
    
    private func provideRegistrationViewController(_ service: UserRegistrationService) -> RegistrationViewController {
        return RegistrationViewController(service: service)
    }

}

