//
//  UsersTableDataHelper.swift
//  DemoExercise
//
//  Created by Muhammad Atif Alvi on 10/08/2020.
//  Copyright © 2020 Muhammad Atif Alvi. All rights reserved.
//

import Foundation
import UIKit

protocol RolesTableViewDelegate: NSObject {
    func selectedUser(_ index: IndexPath)
    func deletedUser(_ index: IndexPath)
}

class UsersTableDataHelper : NSObject {
    
    weak var delegate: RolesTableViewDelegate?
    var usersList = [User]()
    
}

extension UsersTableDataHelper: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier:"userCell")
        let user = usersList[indexPath.row]
        cell.textLabel?.text = (user.lastName) + ", " + (user.firstName)
        cell.accessoryType  = .disclosureIndicator
        
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.deletedUser(indexPath)
            usersList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedUser(indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
