//
//  DBHelper.swift
//  DemoExercise
//
//  Created by Muhammad Atif Alvi on 03/08/2020.
//  Copyright © 2020 Muhammad Atif Alvi. All rights reserved.
//

import Foundation

final class DBHelper {
    static let shared = DBHelper()
    var selectedUser: User? {
        didSet {
            if let user = DBHelper.shared.selectedUser {
                DBHelper.shared.selectedRoles = user.roles
            } else {
                DBHelper.shared.selectedRoles = ""
            }
        }
    }
    var selectedRoles = ""
    
    var db: SQLiteDatabase?
    
    private init() {
        do {
            self.db = try SQLiteDatabase.open()
            createUserTable()
        } catch {
            print("Unable to open database. \(error)")
        }
    }
    
    func createUserTable() {
        if let _db = db {
            do {
              try _db.createTable(table: User.self)
            } catch {
              print(_db.errorMessage)
            }
        }
    }
    
    func getAllUsers() -> [User] {
        
        if let _db = db {
            return _db.allUsers()
        }
        
        return [User]()
    }
    
    func getUser(_ id: Int32) -> User? {
        
        if let _db = db {
            return _db.user(id)
        }
        return nil
    }
    
    func insertUser(_ user: User) -> Bool {
        if let _db = db {
            do {
                try _db.insertUser(user)
            } catch {
                print(_db.errorMessage)
            }
        }
        
        return true
    }
    
    func updateUser(_ id: Int32, _ updatedUser: User) -> Bool {
        if let _db = db {
            do {
                try _db.updateUser(id, updatedUser)
                return true
            } catch {
                print(_db.errorMessage)
                return false
            }
        }
        return false
    }
    
    func deleteUser(_ user: User) -> Bool {
        
        if let _db = db {
            do {
                try _db.deleteUser(user.id)
                return true
            } catch {
                print(_db.errorMessage)
                return false
            }
        }
        return false
    }
}
