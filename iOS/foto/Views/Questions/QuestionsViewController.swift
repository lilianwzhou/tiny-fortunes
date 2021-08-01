//
//  QuestionsViewController.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-26.
//

import UIKit

class QuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var testData: [CellInfo] = [
        CellInfo(keyName: "first_name", prompt: "What is your first name?", cellType: .open),
        CellInfo(keyName: "location", prompt: "Where are you located?", cellType: .dropdown(items: ["San Francisco", "Los Angeles", "Awesome"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "poopy", prompt: "Where are you ssss", cellType: .dropdown(items: ["San A", "B", "C", "D","E"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "location", prompt: "Where are you fdasdfasd", cellType: .dropdown(items: ["San Francisco", "Los Angeles", "Awesome"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "bob", prompt: "Sup", cellType: .boolean(isExpanded: false, currentSelected: nil))
    ]
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
        questionsView.tableView.register(DropdownQuestionTableViewCell.self, forCellReuseIdentifier: "Dropdown")

    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellInfo = testData[indexPath.row]
        cellInfo.prompt = "\(indexPath.row + 1). \(cellInfo.prompt)"
        switch cellInfo.cellType {
        
        case .open:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Open") as! OpenQuestionTableViewCell
            cell.questionLabel.text = cellInfo.prompt
            cell.tag = indexPath.row
            return cell
        case .dropdown, .boolean:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Dropdown") as! DropdownQuestionTableViewCell
            cell.info = cellInfo
            cell.delegate = self
            cell.tag = indexPath.row
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        guard testData[indexPath.row].cellType.isDropdown() else {
            return
        }
        
        testData[indexPath.row].cellType = testData[indexPath.row].cellType.select()
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
}

extension QuestionsViewController: DropdownQuestionTableViewCellDelegate {
    func didSelect(value: String?, row: Int) {
        switch testData[row].cellType {
        case .dropdown(let i, let isExpanded, _):
            let item: CellType = .dropdown(items: i, isExpanded: false, currentSelected: value)
            testData[row].cellType = item
//            (questionsView.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? DropdownQuestionTableViewCell)?.info?.cellType = item
        case .boolean(let isExpanded, _):
            var nextValue: Bool?
            
            if value != nil {
                nextValue = value == "Yes" ? true : false
            }
            
            let item: CellType = .boolean(isExpanded: false, currentSelected: nextValue)
            testData[row].cellType = item
//            (questionsView.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? DropdownQuestionTableViewCell)?.info?.cellType = item
        default:
            break
        }
        
        questionsView.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
    }
}
