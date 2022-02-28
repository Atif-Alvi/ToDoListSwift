//
//  UsersListPresenter.swift
//  DemoExercise
//
//  Created by Muhammad Atif Alvi on 02/08/2020.
//  Copyright © 2020 Muhammad Atif Alvi. All rights reserved.
//

import Foundation

protocol UsersListView: NSObjectProtocol {
    func setUsers(users: [User])
    func navigateToProfileVC()
}

class UsersListPresenter {
    
    weak private var userListiew: UsersListView?
    
    func attachView(view: UsersListView) {
        userListiew = view
    }
    
    func getUsers() {
        DBHelper.shared.selectedUser = nil
        let users = DBHelper.shared.getAllUsers()
        userListiew?.setUsers(users: users)
    }
    
    func userSelected(_ user: User) {
        DBHelper.shared.selectedUser = user
        userListiew?.navigateToProfileVC()
    }
    
    func deleteUser(user:User) {
        _ = DBHelper.shared.deleteUser(user)
    }
}
