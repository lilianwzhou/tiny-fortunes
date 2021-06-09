//
//  TestViewController.swift
//  foto
//
//  Created by Lilian Zhou on 2021-06-08.
//

import UIKit

class TestViewController: UIViewController {
    
    var switchy = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        view.layer.cornerRadius = 20
        
        switchy.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(switchy)
        
        switchy.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10).isActive = true
        
        switchy.bottomAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
//        NSLayoutConstraint.activate([
//            switchy.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
//            switchy.bottomAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
        var instanceOfChildNode = UIMokView()
        instanceOfChildNode.addSubview(switchy)
        print("YAY")
        print("hihi") 
    }

}

class UIMokView {
    private var myDickiyeerer = 0
    public func addSubview(_ view: UIView) {
        print(myDickiyeerer)
    }
}

class ChildOfNOOne {
    var customVar = 5
    init(customVar: Int) {
        self.customVar = customVar
        
    }
}
