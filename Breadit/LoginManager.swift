//
//  LoginManager.swift
//  Breadit
//
//  Created by William Hester on 5/4/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import Foundation

struct LoginManager {
    var account: Account?
    
    func getAccessToken() -> String {
        return account?.accessToken ?? ""
    }
}
