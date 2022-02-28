//
//  ProfilePresenter.swift
//  DemoExercise
//
//  Created by Muhammad Atif Alvi on 03/08/2020.
//  Copyright © 2020 Muhammad Atif Alvi. All rights reserved.
//

import Foundation

protocol ProfileView: NSObjectProtocol {
    func showUserDetails(_ user: User?, _ roles: String, _ departments: [String])
}

class ProfilePresenter: NSObject {
    
    //TODO: Convert to enums
    private let departments = ["--Select Department--","Accounting", "Sales", "Plant", "Shipping", "QualityControl", "Marketing", "Human Resources"]

    weak private var view: ProfileView?
    
    func attacheView(view: ProfileView?) {
        self.view = view
    }
    
    func getUserData() {
        view?.showUserDetails(DBHelper.shared.selectedUser, DBHelper.shared.selectedRoles, departments)
    }
    
    func insertUser(_ user: User) -> Bool {
        return DBHelper.shared.insertUser(user)
    }
    
    func updateUser(_ id: Int32, _ updatedser: User) -> Bool {
        return DBHelper.shared.updateUser(id, updatedser)
    }
}
