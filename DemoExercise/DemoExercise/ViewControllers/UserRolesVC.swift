//
//  UserRolesVC.swift
//  DemoExercise
//
//  Created by Muhammad Atif Alvi on 08/08/2020.
//  Copyright © 2020 Muhammad Atif Alvi. All rights reserved.
//

import UIKit


class UserRolesVC: BaseViewController, RolesView {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userId: Int32?
    private var allRoles = [String]()
    private var selectedRoles = [String]()
    
    private let presenter = RolesPresenter()

    override func viewDidLoad() {
        super.viewDidLoad()

        presenter.attacheView(view: self)
        presenter.checkData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        presenter.viewDisappearing(selectedRoles)
    }
    
    func loadData(_ selectedRoles: [String], _ allRoles: [String]) {
        self.selectedRoles = selectedRoles
        self.allRoles = allRoles
        tableView.reloadData()
    }
}

extension UserRolesVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allRoles.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "roleCellIdentifier")
        
        cell.textLabel?.text = allRoles[indexPath.row]
        
        if selectedRoles.contains(allRoles[indexPath.row]) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRole = allRoles[indexPath.row]
        if let index = selectedRoles.firstIndex(of: selectedRole) {
            selectedRoles.remove(at: index)
        } else {
            selectedRoles.append(selectedRole)
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
