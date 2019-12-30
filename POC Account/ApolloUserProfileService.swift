//
//  ApolloUserProfileService.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/30/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

import Apollo

class ApolloUserProfileService: UserProfileService {
    
    private let client: ApolloClient
    
    init(client: ApolloClient) {
        self.client = client
    }
    
    func get(_ userId: Int, handler: @escaping (Result<UserProfile, Error>) -> Void) {
        client.fetch(query: UserProfileQuery()) { result in
            switch result {
            case .success(let graphQLResult):
                let profile = graphQLResult.data!.userProfile
                handler(Result.success(UserProfile(userId: profile.userId, firstName: profile.firstName, lastName: profile.lastName)))
            case .failure(let error):
                handler(Result.failure(error))
            }
        }
    }
    
}
