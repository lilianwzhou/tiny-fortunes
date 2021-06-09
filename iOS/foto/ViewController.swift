//
//  ViewController.swift
//  foto
//
//  Created by Lilian Zhou on 2021-06-08.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var testButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        testButton.setTitle("Hello", for: .normal)
    }

}

