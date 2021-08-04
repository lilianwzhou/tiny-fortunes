//
//  QuestionsView.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-26.
//

import UIKit

class QuestionsView: UIView {
    
    let tableView: UITableView = {
        let table = UITableView()
        table.allowsSelection = true
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.estimatedRowHeight = 60
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    let skipButton: UIButton = {
        let button = UIButton()
        let yourAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.appBodyFont,
            .foregroundColor: UIColor.black,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributeString = NSMutableAttributedString(
               string: "I don't want to do this ->",
               attributes: yourAttributes
            )
        button.setAttributedTitle(attributeString, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .appBodyFont
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(tableView)
        addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
            skipButton.trailingAnchor.constraint(equalTo: tableView.trailingAnchor, constant: -40),
            tableView.topAnchor.constraint(equalTo: skipButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
        ])
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(gestureRecognizer)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func dismissKeyboard() {
        endEditing(true)
    }
    
    
    

    
    
}

