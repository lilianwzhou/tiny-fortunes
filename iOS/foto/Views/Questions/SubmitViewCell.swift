//
//  SubmitViewCell.swift
//  foto
//
//  Created by Lilian Zhou on 2021-08-01.
//

import UIKit

class SubmitViewCell: UITableViewCell {
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.right")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 26, weight:  .regular)), for: .normal)
        button.imageView?.tintColor = .black
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 35
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = .white
        contentView.addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            submitButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            submitButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            submitButton.widthAnchor.constraint(equalToConstant: 70),
            submitButton.heightAnchor.constraint(equalToConstant: 70),
            submitButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
        
        
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
