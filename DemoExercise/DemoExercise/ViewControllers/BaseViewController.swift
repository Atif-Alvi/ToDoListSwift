//
//  BaseViewController.swift
//  DemoExercise
//
//  Created by Muhammad Atif Alvi on 09/08/2020.
//  Copyright © 2020 Muhammad Atif Alvi. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showAlert(_ title: String,_ msg: String) {
        let popup = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (okButton) in
            self.dismiss(animated: true, completion: nil)
        }
        popup.addAction(ok)
        present(popup, animated: true, completion: nil)
    }
}
