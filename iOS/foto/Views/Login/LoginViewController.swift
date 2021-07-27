//
//  LoginViewController.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-18.
//

import UIKit

class LoginViewController: UIViewController {

    var customView: AccountView? {
        return self.view as? AccountView
    }
    
    override func loadView() {
        self.view = AccountView()
    }
    
    override func viewDidLoad() {
        customView?.completeButton.setTitle("Login", for: .normal)
    }
}
