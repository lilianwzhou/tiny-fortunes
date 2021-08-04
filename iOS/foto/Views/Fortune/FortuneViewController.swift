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
    
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(getFortune))
        gestureRecognizer.numberOfTapsRequired = 1
        self.customView?.cookieImage.addGestureRecognizer(gestureRecognizer)
        self.customView?.cookieImage.isUserInteractionEnabled = true
        
        UIView.animate(withDuration: 1, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
            self.customView?.cookieImage.transform =  CGAffineTransform(translationX: 0, y: -20)
        }, completion: nil)
    }
    
    
    @objc private func getFortune() {
    print("Hi")
            //API CALL
        guard let userID = Networking.userID,
              let jwt = Networking.jwt,
              var request = Networking.getRequestFor(route: .fortune, method: .GET, tail: "/" + userID) else {
                return
            }
            
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "Authorization": "Bearer \(jwt)"]
            let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { data, resp, error in
                
                if let unwrappedError = error {
                    // At this point, we have an error
                    DispatchQueue.main.async {
                        self.customView?.messageLabel.text =  unwrappedError.localizedDescription
                    }
                    return
                }
                
                guard let data = data, let resp = resp as? HTTPURLResponse else {
                    //                DispatchQueue.main.async(execute: {
                    //                    self.customView.showError(message: "Undefined Error")
                    //                })
                    DispatchQueue.main.async {
                        //self.customView?.showError(message: "Undefined Error")
                    }
                    return
                }
                
                guard resp.statusCode/100 == 2 else {
                    DispatchQueue.main.async {
                        if let errorMessage = String(data: data, encoding: .utf8) {
                            self.customView?.messageLabel.text = errorMessage
//                            self.customView?.showError(message: errorMessage)
                        }
                    }
                    return
                }
                
                if let object = try? JSONDecoder().decode(FortuneAPIResponse.self, from: data) {
                    //print(object.jwt)d
                    DispatchQueue.main.async {
                        self.customView?.messageLabel.text = object.message

                    }


                }
                
            })
            dataTask.resume()
        
    }
    
    @objc private func editProfile() {
        let questionsVC = QuestionsViewController()
        present(questionsVC, animated: true, completion: nil)
        
    }

}
