//
//  SQLiteDatabase.swift
//  DemoExercise
//
//  Created by Muhammad Atif Alvi on 09/08/2020.
//  Copyright © 2020 Muhammad Atif Alvi. All rights reserved.
//

import Foundation
import SQLite3

enum SQLiteError: Error {
  case OpenDatabase(message: String)
  case Prepare(message: String)
  case Step(message: String)
  case Bind(message: String)
}

protocol SQLTable {
  static var createStatement: String { get }
}

class SQLiteDatabase {
    
    private let dbPointer: OpaquePointer?
    private init(dbPointer: OpaquePointer?) {
      self.dbPointer = dbPointer
    }
    deinit {
      sqlite3_close(dbPointer)
    }
        
    static func open() throws -> SQLiteDatabase {
        let fileURL = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("demoExercise.sqlite")
        var db: OpaquePointer?
        if sqlite3_open(fileURL.path, &db) == SQLITE_OK {
            return SQLiteDatabase(dbPointer: db)
        } else {
            defer {
                if db != nil {
                    sqlite3_close(db)
                }
            }
            if let errorPointer = sqlite3_errmsg(db) {
                let message = String(cString: errorPointer)
                throw SQLiteError.OpenDatabase(message: message)
            } else {
                throw SQLiteError
                    .OpenDatabase(message: "No error message provided from sqlite.")
            }
        }
    }
    
    var errorMessage: String {
      if let errorPointer = sqlite3_errmsg(dbPointer) {
        let errorMessage = String(cString: errorPointer)
        return errorMessage
      } else {
        return "No error message provided from sqlite."
      }
    }
    
}

extension SQLiteDatabase {
 func prepareStatement(sql: String) throws -> OpaquePointer? {
  var statement: OpaquePointer?
  guard sqlite3_prepare_v2(dbPointer, sql, -1, &statement, nil)
      == SQLITE_OK else {
    throw SQLiteError.Prepare(message: errorMessage)
  }
  return statement
 }
}

extension SQLiteDatabase {
  func createTable(table: SQLTable.Type) throws {
    let createTableStatement = try prepareStatement(sql: table.createStatement)
    defer {
      sqlite3_finalize(createTableStatement)
    }
    guard sqlite3_step(createTableStatement) == SQLITE_DONE else {
      throw SQLiteError.Step(message: errorMessage)
    }
//    print("\(table) table created.")
  }
}

extension SQLiteDatabase {
    
    func insertUser(_ user: User) throws {
        let insertSql = "INSERT INTO User (firstName, lastName, email, userName, password, department, roles) VALUES (?, ?, ?, ?, ?, ?, ?);"
        let insertStatement = try prepareStatement(sql: insertSql)
        defer {
            sqlite3_finalize(insertStatement)
        }
    
        let firstName = user.firstName as NSString
        let lastName = user.lastName as NSString
        let email = user.email as NSString
        let userName = user.userName as NSString
        let password = user.password as NSString
        let department = user.department as NSString
        let roles = user.roles as NSString

        guard
            sqlite3_bind_text(insertStatement, 1, firstName.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(insertStatement, 2, lastName.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(insertStatement, 3, email.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(insertStatement, 4, userName.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(insertStatement, 5, password.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(insertStatement, 6, department.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(insertStatement, 7, roles.utf8String, -1, nil) == SQLITE_OK
        
        else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(insertStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
//        print("Successfully inserted row.")
    }
    
    
    func updateUser(_ id: Int32, _ user: User) throws {
        let updateSql = "UPDATE User SET firstName=?, lastName=?, email=?, userName=?, password=?, department=?, roles=? WHERE id = ?;"
        let updateStatement = try prepareStatement(sql: updateSql)
        defer {
            sqlite3_finalize(updateStatement)
        }
        
        let firstName = user.firstName as NSString
        let lastName = user.lastName as NSString
        let email = user.email as NSString
        let userName = user.userName as NSString
        let password = user.password as NSString
        let department = user.department as NSString
        let roles = user.roles as NSString

        guard
            sqlite3_bind_text(updateStatement, 1, firstName.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(updateStatement, 2, lastName.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(updateStatement, 3, email.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(updateStatement, 4, userName.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(updateStatement, 5, password.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(updateStatement, 6, department.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_text(updateStatement, 7, roles.utf8String, -1, nil) == SQLITE_OK &&
                sqlite3_bind_int(updateStatement, 8, id) == SQLITE_OK
            
        else {
            throw SQLiteError.Bind(message: errorMessage)
        }
        guard sqlite3_step(updateStatement) == SQLITE_DONE else {
            throw SQLiteError.Step(message: errorMessage)
        }
//        print("Successfully updated row.")
    }

}

extension SQLiteDatabase {
    
    
    func allUsers() -> [User] {
        
        var allUsers = [User]()
        
        let querySql = "SELECT * FROM User;"
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
          return [User]()
        }
        defer {
          sqlite3_finalize(queryStatement)
        }
        
        while (sqlite3_step(queryStatement) == SQLITE_ROW) {
            if let user = userFromRow(queryStatement: queryStatement) {
                allUsers.append(user)
            }
        }

        return allUsers
    }
    
    func deleteUser(_ id: Int32) throws {
        let querySql = "DELETE FROM User WHERE Id = ?;"
        
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
          return
        }
        defer {
          sqlite3_finalize(queryStatement)
        }
        
        guard sqlite3_bind_int(queryStatement, 1, id) == SQLITE_OK else {
          return
        }
        guard sqlite3_step(queryStatement) == SQLITE_DONE else {
//          print("Failed to delete row.")
          throw SQLiteError.Step(message: errorMessage)
        }
//        print("Successfully deleted row.")
    }
    
    func user(_ id: Int32) -> User? {
        
        let querySql = "SELECT * FROM User WHERE Id = ?;"
        guard let queryStatement = try? prepareStatement(sql: querySql) else {
            return nil
        }
        defer {
            sqlite3_finalize(queryStatement)
        }
        guard sqlite3_bind_int(queryStatement, 1, id) == SQLITE_OK else {
            return nil
        }
        guard sqlite3_step(queryStatement) == SQLITE_ROW else {
            return nil
        }
    
        return userFromRow(queryStatement: queryStatement)
    }
    
    func userFromRow(queryStatement: OpaquePointer) -> User? {
        
        let id = sqlite3_column_int(queryStatement, 0)
        guard let queryResultCol1 = sqlite3_column_text(queryStatement, 1) else {
          print("1Query result is nil.")
          return nil
        }
        guard let queryResultCol2 = sqlite3_column_text(queryStatement, 2) else {
          print("2Query result is nil.")
          return nil
        }
        guard let queryResultCol3 = sqlite3_column_text(queryStatement, 3) else {
          print("3Query result is nil.")
          return nil
        }
        guard let queryResultCol4 = sqlite3_column_text(queryStatement, 4) else {
          print("4Query result is nil.")
          return nil
        }
        guard let queryResultCol5 = sqlite3_column_text(queryStatement, 5) else {
          print("5Query result is nil.")
          return nil
        }
        guard let queryResultCol6 = sqlite3_column_text(queryStatement, 6) else {
          print("6Query result is nil.")
          return nil
        }
        guard let queryResultCol7 = sqlite3_column_text(queryStatement, 7) else {
          print("7Query result is nil.")
          return nil
        }

        let firstName = String(cString: queryResultCol1)
        let lastName = String(cString: queryResultCol2)
        let email = String(cString: queryResultCol3)
        let userName = String(cString: queryResultCol4)
        let password = String(cString: queryResultCol5)
        let department = String(cString: queryResultCol6)
        let roles = String(cString: queryResultCol7)
        
        return User(id: id, firstName: firstName, lastName: lastName, email: email, userName: userName, password: password, department: department, roles: roles)
    }
}
