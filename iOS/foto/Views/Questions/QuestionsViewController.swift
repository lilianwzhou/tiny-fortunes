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
        CellInfo(keyName: "last_name", prompt: "What is your last name?", cellType: .open),
        CellInfo(keyName: "location", prompt: "Where are you located?", cellType: .dropdown(items: ["San Francisco", "Los Angeles", "New York", "Calgary", "Vancouver", "Waterloo", "Austin"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "birthday", prompt: "When is your birthday?", cellType: .open),
        CellInfo(keyName: "occupation", prompt: "What is your job?", cellType: .dropdown(items: ["Healthcare", "Tech", "Finance", "Social Work", "Other"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "pineapples_on_pizza", prompt: "Do pineapples belong on pizza?", cellType: .boolean(isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "wipe_standing_up", prompt: "Do you wipe standing or sitting?", cellType: .dropdown(items: ["Sitting", "Standing"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "water_wet", prompt: "Is water wet?", cellType: .boolean(isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "dog_person", prompt: "Dogs or cats?", cellType: .dropdown(items: ["Dog", "Cat"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "touch_grass_today", prompt: "Have you touched grass today?", cellType: .boolean(isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "hulk_flavour_sour_apple", prompt: "If the hulk was a flavour, would he be lime or green apple?", cellType: .dropdown(items: ["Lime", "Green Apple"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "early_bird", prompt: "Are you a night owl or an early bird?", cellType: .dropdown(items: ["Night Owl", "Early Bird"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "favourite_colour", prompt: "What is your favourite colour?", cellType: .open),
        CellInfo(keyName: "likes_sushi", prompt: "Do you like sushi?", cellType: .boolean(isExpanded: false, currentSelected: nil))
    
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
        questionsView.tableView.register(DateQuestionTableViewCell.self, forCellReuseIdentifier: "DateCell")

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
        case .date:
            let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateQuestionTableViewCell
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
        case .dropdown(let i, _, _):
            let item: CellType = .dropdown(items: i, isExpanded: false, currentSelected: value)
            testData[row].cellType = item
        case .boolean:
            var nextValue: Bool?
            
            if value != nil {
                nextValue = value == "Yes" ? true : false
            }
            
            let item: CellType = .boolean(isExpanded: false, currentSelected: nextValue)
            testData[row].cellType = item
        default:
            break
        }
        
        questionsView.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
    }
}

extension QuestionsViewController: DateQuestionTableViewCellDelegate {
    func didSelectDate(date: Date?, row: Int) {
        guard case .date(let date) = testData[row].cellType else {
            return
        }
        
        let item: CellType = .date(currentDate: date)
        testData[row].cellType = item
        
        questionsView.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
    }
    
    
}
