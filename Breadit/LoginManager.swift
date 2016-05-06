//
//  LoginManager.swift
//  Breadit
//
//  Created by William Hester on 5/4/16.
//  Copyright © 2016 William Hester. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

struct LoginManager {
    
    var account: Account? {
        didSet {
            saveCurrentUser()
        }
    }
    
    init() {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        if let username = prefs.stringForKey("account") {
            let realm = try! Realm()
            account = realm.objects(Account).filter("username = '\(username)'").first
        }
    }
    
    private func saveCurrentUser() {
        let prefs = NSUserDefaults.standardUserDefaults()

        prefs.setObject(account?.username ?? "", forKey: "account")

        prefs.synchronize()
    }
    
    func getAccessToken() -> String {
        return account?.accessToken ?? ""
    }
}
