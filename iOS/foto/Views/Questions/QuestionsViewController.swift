//
//  QuestionsViewController.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-26.
//

import UIKit

class QuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var testData: [CellInfo] = [CellInfo(keyName: "first_name", prompt: "What is your first name?", cellType: .open)]
    var questionsView: QuestionsView {
        return self.view as! QuestionsView
    }
    
    override func loadView() {
        self.view = QuestionsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionsView.tableView.delegate = self
        questionsView.tableView.dataSource = self
        questionsView.tableView.register(OpenQuestionTableViewCell.self, forCellReuseIdentifier: "Open")
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellInfo = testData[indexPath.row]
        switch cellInfo.cellType {
        
        case .open, .boolean, .dropdown:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Open") as! OpenQuestionTableViewCell
            cell.questionLabel.text = "\(indexPath.row + 1). \(cellInfo.prompt)"
            return cell
        }

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}

struct CellInfo {
    let keyName: String
    let prompt: String
    let cellType: CellType
    
}

enum CellType {
    case open
    case boolean
    case dropdown
    
}
