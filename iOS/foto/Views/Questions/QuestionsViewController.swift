//
//  QuestionsViewController.swift
//  foto
//
//  Created by Lilian Zhou on 2021-07-26.
//

import UIKit

class QuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var testData: [CellInfo] = [
        CellInfo(keyName: "first_name", prompt: "What is your first name?", cellType: .open(currentValue: nil)),
        CellInfo(keyName: "last_name", prompt: "What is your last name?", cellType: .open(currentValue: nil)),
        CellInfo(keyName: "location", prompt: "Where are you located?", cellType: .dropdown(items: ["San Francisco", "Los Angeles", "New York", "Calgary", "Vancouver", "Waterloo", "Austin"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "birthday", prompt: "When is your birthday?", cellType: .date(currentDate: Date())),
        CellInfo(keyName: "occupation", prompt: "What is your job?", cellType: .dropdown(items: ["Healthcare", "Tech", "Finance", "Social Work", "Other"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "pineapples_on_pizza", prompt: "Do pineapples belong on pizza?", cellType: .boolean(isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "wipe_standing_up", prompt: "Do you wipe standing or sitting?", cellType: .dropdown(items: ["Sitting", "Standing"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "water_wet", prompt: "Is water wet?", cellType: .boolean(isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "dog_person", prompt: "Dogs or cats?", cellType: .dropdown(items: ["Dog", "Cat"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "touch_grass_today", prompt: "Have you touched grass today?", cellType: .boolean(isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "hulk_flavour_sour_apple", prompt: "Hulk? As a flavour?", cellType: .dropdown(items: ["Lime", "Green Apple"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "early_bird", prompt: "Are you a night owl or an early bird?", cellType: .dropdown(items: ["Night Owl", "Early Bird"], isExpanded: false, currentSelected: nil)),
        CellInfo(keyName: "favourite_colour", prompt: "What is your favourite colour?", cellType: .open(currentValue: nil)),
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
        questionsView.tableView.register(SubmitViewCell.self, forCellReuseIdentifier: "Submit")
        questionsView.skipButton.addTarget(self, action: #selector(skipQuestions), for: .touchUpInside)
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testData.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.row < testData.count else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Submit") as! SubmitViewCell
            cell.submitButton.addTarget(self, action: #selector(submitClicked), for: .touchUpInside)
            return cell
        }
        
        var cellInfo = testData[indexPath.row]
        cellInfo.prompt = "\(indexPath.row + 1). \(cellInfo.prompt)"
        switch cellInfo.cellType {
        
        case .open:
            let cell = tableView.dequeueReusableCell(withIdentifier: "Open") as! OpenQuestionTableViewCell
            cell.questionLabel.text = cellInfo.prompt
            cell.answerField.text = cellInfo.cellType.currentSelected()
            cell.answerField.addTarget(self, action: #selector(textChanged(textfield:)), for: .editingChanged)
            cell.answerField.tag = indexPath.row
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
    
    
    @objc private func textChanged(textfield: UITextField) {
        //step  1: get text from whatever textfield  changed
        let text = textfield.text
        //step 2: put that new value in the correct row in testData
        testData[textfield.tag].cellType = .open(currentValue: text)
    }
    
    @objc private func skipQuestions() {
        let fortuneVC = FortuneViewController()
        navigationController?.pushViewController(fortuneVC, animated: true)
    }
    
    @objc private func submitClicked() {
        //API CALL
        guard let userID = Networking.userID,
              var request = Networking.getRequestFor(route: .user, method: .PATCH, tail: "/" + userID),
              let jwt = Networking.jwt else {
            return
        }
        
        var userDetails = UserDetails()
        
        userDetails.firstName = ""
        //SET EVERTYTHING FROM TESTDAT
        for cellInfo in testData {
            let key = cellInfo.keyName
            switch cellInfo.cellType  {
            case .date(let currentDate):
                print(currentDate)
                guard let currentDate = currentDate else {
                    continue
                }
                
                if key == "birthday" {
                    let dateFormatterPrint = DateFormatter()
                    dateFormatterPrint.dateFormat = "yyyy-MM-dd"
                    userDetails.birthday = dateFormatterPrint.string(from: currentDate)
                    print(userDetails.birthday)
                }
                
            case .boolean(_, let currentBool):
                if key == "likes_sushi" {
                    userDetails.likesSushi = currentBool
                } else if key == "touch_grass_today" {
                    userDetails.touchGrassToday = currentBool
                } else if key == "water_wet" {
                    userDetails.waterWet = currentBool
                } else if key == "pineapples_on_pizza"  {
                    userDetails.pineapplesOnPizza = currentBool
                }
            case .open(let openText):
                if key == "favourite_colour" {
                    userDetails.favouriteColour = openText
                } else if key == "last_name" {
                    userDetails.lastName = openText
                } else if key == "first_name" {
                    userDetails.firstName = openText
                }
            case .dropdown(_,_, let currentSelected):
                if key == "early_bird" {
                    userDetails.earlyBird = currentSelected == "Early Bird" ? true : false
                } else if key == "hulk_flavour_sour_apple" {
                    userDetails.hulkFlavour = currentSelected == "Green Apple" ? true : false
                } else if key == "dog_person" {
                    userDetails.dogPerson = currentSelected == "Dog" ? true : false
                } else if key == "wipe_standing_up" {
                    userDetails.wipeStandingUp = currentSelected == "Sitting" ? true : false
                } else if key == "occupation" {
                    userDetails.occupation = currentSelected
                } else if key == "location" {
                    guard let selected = currentSelected else {
                        break
                    }
                    let map: [String: (Double, Double)] = [
                        "San Francisco": (37.7749, -122.4194),
                        "Los Angeles": (34.0522, -118.2437),
                        "New York": (40.7128, -74.0060),
                        "Calgary": (51.0447, -114.0719),
                        "Vancouver": (49.2827, -123.1207),
                        "Austin": (30.2672, -97.7431),
                        "Waterloo": (43.4643, -80.5204)
                    ]
                    userDetails.latitude = map[selected]!.0
                    userDetails.longitude = map[selected]!.1
                }
            }
        }
        
        print(userDetails)
        guard let encodedBody = try? JSONEncoder().encode(userDetails) else {
            return
        }
        
        request.httpBody = encodedBody
        
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "Authorization": "Bearer \(jwt)"]
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { data, resp, error in
            
            if let unwrappedError = error {
                // At this point, we have an error
                print(unwrappedError)
                return
            }
            
            guard let data = data, let resp = resp as? HTTPURLResponse else {
                
                print(String(data: data ?? Data(), encoding: .utf8))
                return
            }
            
            guard resp.statusCode/100 == 2 else {
                print(resp.statusCode)
                return
            }
            print(String(data: data, encoding: .utf8))
            
            DispatchQueue.main.async {
                let questionsVC = FortuneViewController()
                self.navigationController?.pushViewController(questionsVC, animated: true)
            }
            
        })
        dataTask.resume()
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
        guard case .date = testData[row].cellType else {
            return
        }
        
        let item: CellType = .date(currentDate: date)
        testData[row].cellType = item
        
        questionsView.tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .fade)
    }
    
    
}
