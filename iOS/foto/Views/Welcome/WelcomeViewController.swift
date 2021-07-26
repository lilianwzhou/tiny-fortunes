//
//  WelcomeViewController.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-18.
//

import UIKit

class WelcomeViewController: UIViewController {

    private var customView: WelcomeView? {
        return self.view as? WelcomeView
    }
    
    override func loadView() {
        self.view = WelcomeView()
        
    }

    override func viewDidLoad() {
        customView?.createAccountButton.addTarget(self, action: #selector(createAccount), for: .touchUpInside)
        customView?.createLoginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        customView?.titleLabel.text = "Lol"
    }
   
    @objc private func createAccount() {
        // TODO: Present createAccountViewController
        let createAccountVC = CreateAccountViewController()
        navigationController?.pushViewController(createAccountVC, animated: true)
//        present(createAccountVC, animated: true, completion: nil)
        
    }
    
    @objc private func login() {
        // TODO: Present loginViewController
        let loginVC = LoginViewController()
//        present(loginVC, animated: true, completion: nil)
        navigationController?.pushViewController(loginVC, animated: true)
    }
}
