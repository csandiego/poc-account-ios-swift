//
//  UserProfileService.swift
//  POC Account
//
//  Created by Christopher San Diego on 12/30/19.
//  Copyright © 2019 Christopher San Diego. All rights reserved.
//

protocol UserProfileService {
    
    func get(_ userId: Int, handler: @escaping (Result<UserProfile, Error>) -> Void)
    
}
