//
//  LoginViewController.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-18.
//

import UIKit

class LoginViewController: UIViewController {

    var customView: LoginView? {
        return self.view as? LoginView
    }
    
    override func loadView() {
        self.view = LoginView()
        
    }
}
