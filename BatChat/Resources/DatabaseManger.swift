//
//  DatabaseManger.swift
//  BatChat
//
//  Created by 徐浩博 on 2021/10/31.
//

import FirebaseDatabase

final class DatabaseManger {
    
    static let shared = DatabaseManger()
    
    private let database = Database.database().reference()
}

extension DatabaseManger {
    
    public func userExists(with email: String, complition: @escaping ((Bool) -> (Void))) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        
        database.child(safeEmail).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                complition(false)
                return
            }
            complition(true)
        }
    }
    
    public func insertUser(with user: ChatAppUser) {
        database.child(user.safeEmial).setValue([
            "first_name": user.firstName,
            "last_name": user.lastName
        ])
    }
}

struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    //let profilePictureUrl: String
    var safeEmial: String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
