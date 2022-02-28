//
//  RolesPresenter.swift
//  DemoExercise
//
//  Created by Muhammad Atif Alvi on 08/08/2020.
//  Copyright © 2020 Muhammad Atif Alvi. All rights reserved.
//

import Foundation

protocol RolesView: NSObjectProtocol {
    func loadData(_ selectedRoles: [String], _ allRoles: [String])
}

class RolesPresenter: NSObject {
    
    
    weak private var view: RolesView?
    private let userRoles = ["Administrator", "Accounts Payable", "Accounts Receivable", "Employee Benefits", "General Ledger", "Payroll", "Inventory", "Production", "Quality Control", "Sales", "Orders", "Customers", "Shipping", "Returns"]
    
    func attacheView(view: RolesView?) {
        self.view = view
    }
    
    func dettacheView() {
        self.view = nil
    }
    
    func checkData(_ userID: Int32? = nil) {
        if let _userID = userID {
            if let user = DBHelper.shared.getUser(_userID) {
                view?.loadData(user.roles.split(separator: ",").map({String($0)}), userRoles)
                return
            }
        }
        view?.loadData(DBHelper.shared.selectedRoles.split(separator: ",").map({String($0)}), userRoles)
    }
    
    func insertUser(_ user: User) -> Bool {
        return DBHelper.shared.insertUser(user)
    }
    
    func updateUser(_ id: Int32, _ updatedser: User) -> Bool {
        return DBHelper.shared.updateUser(id, updatedser)
    }
    
    func viewDisappearing(_ roles: [String]) {
        DBHelper.shared.selectedRoles = roles.joined(separator: ",")
//        DBHelper.shared.selectedUser?.roles = roles.joined(separator: ",")
    }
}
