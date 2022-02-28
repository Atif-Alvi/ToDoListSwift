//
//  UsersListVC.swift
//  DemoExercise
//
//  Created by Muhammad Atif Alvi on 02/08/2020.
//  Copyright © 2020 Muhammad Atif Alvi. All rights reserved.
//

import UIKit

class UsersListVC: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let presenter = UsersListPresenter()
    private var usersList = [User]()
    var tableAdapater = UsersTableDataHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(view: self)
        tableAdapater.delegate = self
        tableView.delegate = tableAdapater
        tableView.dataSource = tableAdapater
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.getUsers()
    }
    
    func navigateToProfileVC() {
        performSegue(withIdentifier: "showProfileSegue", sender: self)
    }
}

extension UsersListVC: UsersListView {
    func setUsers(users: [User]) {
        usersList = users
        tableAdapater.usersList = users
        tableView.reloadData()
    }
}

extension UsersListVC: RolesTableViewDelegate {
    
    func selectedUser(_ index: IndexPath) {
        presenter.userSelected(usersList[index.row])
    }
    func deletedUser(_ index: IndexPath) {
        presenter.deleteUser(user: usersList[index.row])
        usersList.remove(at: index.row)
    }
}
