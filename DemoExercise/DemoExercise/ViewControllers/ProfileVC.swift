//
//  ProfileVC.swift
//  DemoExercise
//
//  Created by Muhammad Atif Alvi on 03/08/2020.
//  Copyright © 2020 Muhammad Atif Alvi. All rights reserved.
//

import UIKit

class ProfileVC: BaseViewController, ProfileView {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUserName: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirm: UITextField!
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet var allTextFields: [UITextField]!
    
    
    var user: User?
    private let presenter = ProfilePresenter()
    
    private var allDepartments = [String]()
    private var selectedDepartment = "--Select Department--"
    private var selectedRoles = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attacheView(view: self)
        presenter.getUserData()
    }
    
    func showUserDetails(_ user: User?, _ roles: String, _ departments: [String]) {
        self.user = user
        self.allDepartments = departments
        if let _user = self.user {
            
            txtFirstName.text = _user.firstName
            txtLastName.text = _user.lastName
            txtEmail.text = _user.email
            txtUserName.text = _user.userName
            txtPassword.text = _user.password
            txtConfirm.text = _user.password

            selectedDepartment = _user.department
            if let index = allDepartments.firstIndex(of: selectedDepartment) {
                pickerView.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserRoles" {
//            if let _user = user {
//                let rolesVC = segue.destination as! UserRolesVC
//                rolesVC.userId = _user.id
//            }
        }
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        for txt in allTextFields {
            txt.resignFirstResponder()
        }
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        
        if validateInput() {
            
            let newUser = User(id: -1, firstName: txtFirstName.text!, lastName: txtLastName.text!, email: txtEmail.text!, userName: txtUserName.text!, password: txtPassword.text!, department: selectedDepartment, roles: DBHelper.shared.selectedRoles)
            
            if user == nil {
                _ = presenter.insertUser(newUser)
            } else {
                _ = presenter.updateUser(user!.id, newUser)
            }
            
            navigationController?.popViewController(animated: true)
        }
    }
    
    func validateInput() -> Bool {
        
        if txtUserName.text!.isEmpty || txtFirstName.text!.isEmpty || txtLastName.text!.isEmpty || txtEmail.text!.isEmpty || txtPassword.text!.isEmpty {
            showAlert("Missing Data!", "Please add input to all fields")
            return false
        }
        if txtPassword.text != txtConfirm.text {
            showAlert("Oops!", "Password & confirm passoword did not match")
            return false
        }
        if selectedDepartment == "--Select Department--" {
            showAlert("Oops!", "Department not selected")
            return false
        }
        
        if DBHelper.shared.selectedRoles == "" {
            showAlert("Oops!", "User Roles not selected")
            return false
        }
        
        return true
    }
}


extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "rolesCellIdentifier")
        cell.textLabel?.text = "User Roles"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showUserRoles", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension ProfileVC: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allDepartments.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allDepartments[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDepartment = allDepartments[row]        
    }
}
