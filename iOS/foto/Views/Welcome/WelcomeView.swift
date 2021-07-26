//
//  WelcomeView.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-18.
//

import UIKit

class WelcomeView: UIView {
    
    let titleLabel:  UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Let's Begin"
        label.textAlignment = .center
        return label
    }()
    
    let createAccountButton: UIButton =  {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Create Account", for: .normal)
        return button
    }()
    
    let createLoginButton: UIButton =  {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Login", for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        backgroundColor = .red
        
        addSubview(titleLabel)
        addSubview(createAccountButton)
        addSubview(createLoginButton)
        
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -30).isActive = true
        createAccountButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60).isActive = true
        createAccountButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        createLoginButton.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 60).isActive = true
        createLoginButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    
}


