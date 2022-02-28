//
//  User.swift
//  DemoExercise
//
//  Created by Muhammad Atif Alvi on 02/08/2020.
//  Copyright © 2020 Muhammad Atif Alvi. All rights reserved.
//

import Foundation


struct User {
    //TODO: Read strcut VS class comparison for SWIFT, figure out ID part
    
    let id : Int32
    let firstName : String
    let lastName : String
    let email : String
    let userName : String
    let password : String
    let department : String
    var roles: String
}

extension User: SQLTable {
  static var createStatement: String {
    return """
    CREATE TABLE IF NOT EXISTS User(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName CHAR(255),
        lastName CHAR(255),
        email CHAR(255),
        userName CHAR(255),
        password CHAR(255),
        department CHAR(255),
        roles CHAR(255)
    );
    """
  }
}
