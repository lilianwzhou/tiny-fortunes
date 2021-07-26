//
//  LoginView.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-18.
//

import UIKit

class LoginView: UIView {
    
    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        //SETUP EMAIL TEXT FIELD CONSTRAINTS
        backgroundColor = .white
        addSubview(emailTextField)
        addSubview(passwordTextField)
        
        emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -20).isActive = true
        passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40).isActive = true
        
    }
    
}

