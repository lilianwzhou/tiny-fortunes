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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
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

