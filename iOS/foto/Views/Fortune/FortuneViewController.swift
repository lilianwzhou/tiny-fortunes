//
//  FortuneViewController.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-30.
//

import UIKit

class FortuneViewController: UIViewController {
    
    var customView: FortuneView? {
        return self.view as? FortuneView
    }
    
    override func loadView() {
        self.view = FortuneView()
    }
    
    override func viewDidLoad() {
        customView?.profileButton.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
    }
    
    
    @objc private func editProfile() {
        let questionsVC = QuestionsViewController()
        present(questionsVC, animated: true, completion: nil)
        
    }

}
