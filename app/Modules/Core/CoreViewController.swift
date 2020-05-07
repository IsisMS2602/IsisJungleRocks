//
//  CoreViewController.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit
import SVProgressHUD

enum ListOption {
    case expandableCell(title: String, key: String, imgUrl: String, worklogs: [WorkLog])
    case plainCell(worklogs: WorkLog)
}

class CoreViewController: BaseViewController, StoryboardLoadable {
    // MARK: Static
    static func initModule() -> CoreViewController {
        let viewController = loadFromStoryboard()
        return viewController
    }
    // MARK: Outlets
    @IBOutlet weak var thisWeekButtonUI: UIButton!
    @IBOutlet weak var lastWeekButtonUI: UIButton!
    @IBOutlet weak var thisMonthButtonUI: UIButton!
    @IBOutlet weak var viewForCircularView: UIView!
    @IBOutlet weak var coreTableView: UITableView! {
        didSet {
            coreTableView.reloadData()
        }
    }
    @IBAction func thisWeekButton(_ sender: Any) {
        SessionHelper.shared.logout()
    }
    // MARK: Variables
    var selectedKey: String?
    typealias Section = (title: String, elements: [ListOption])
    var circularView = CircularProgressView()
    var userImage: String = ""
    var worklogArray: [WorkLog] = [] {didSet {coreTableView.reloadData()}}
    var projectArray: [Project] = [] {didSet {coreTableView.reloadData()}}
    var dataSource: [Section] = [] { didSet {coreTableView.reloadData()}}
    // MARK: Life cycle
    override func viewDidLoad() {
        circularView.center.x = (viewForCircularView.center.x + 16)/2
        circularView.center.y = (viewForCircularView.center.y - 8)/2
        viewForCircularView.addSubview(circularView)
        super.viewDidLoad()
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.show()
        setButtonsUI()
        setToolBar()
        setupTableView()
        setNavigationBar(image: userImage)
        getUserTimeTrakking()
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(false)
        setNavigationBar(image: userImage)
    }
    private func setupTableView() {
        coreTableView.dataSource = self
        coreTableView.delegate = self
        coreTableView.register(ProjectsTableViewCell.self)
        coreTableView.register(PlainTableViewCell.self)
        coreTableView.backgroundColor = UIColor.clear
        coreTableView.tableFooterView = UIView()
        coreTableView.tableHeaderView = UIView()
        coreTableView.separatorStyle = .none
        coreTableView.separatorColor = .clear
    }
    func setButtonsUI() {
        thisWeekButtonUI.layer.cornerRadius = 20
        thisWeekButtonUI.backgroundColor = UIColor(red: 88/255, green: 97/255, blue: 121/255, alpha: 1)
        lastWeekButtonUI.layer.cornerRadius = 20
        lastWeekButtonUI.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 250/255, alpha: 1)
        thisMonthButtonUI.layer.cornerRadius = 20
        thisMonthButtonUI.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 250/255, alpha: 1)
    }
    func getUserTimeTrakking() {
        APIManager.GetWorkLogs().request { response in
            switch response {
            case .success(let worklog) :
                self.getUserProjects()
                self.worklogArray = worklog
            case .failure:
                let alert = UIAlertController(title: "Unable to trek your time", message: "Check your conection status", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive))
                SVProgressHUD.dismiss()
                self.present(alert, animated: true)
                print("erro")
            }
        }
    }
    func getUserProjects() {
        APIManager.GetProjects().request { response in
            switch response {
            case .success(let project) :
                self.projectArray = project
                self.dataSource = self.getSections()
                SVProgressHUD.dismiss()
            case .failure:
                let alert = UIAlertController(title: "Unable to trek your projects", message: "Check your conection status", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive))
                SVProgressHUD.dismiss()
                self.present(alert, animated: true)
            }
        }
    }
    func getSections() -> [Section] {
        return [
            getProjectsSection(),
            getOtherActivitiesSection(),
            getLastTimeLogsSection()
        ]
    }
    func getProjectsSection() -> Section {
        let filteredArray = self.worklogArray.filter { worklog in
            worklog.category == "Development"
        }
        let categoryMap = Dictionary(grouping: filteredArray, by: { $0.issue?.projectKey })
        let elements = categoryMap.compactMap { (key, elements) -> ListOption? in
            let project = projectArray.first { element in
                element.key == key
            }
            guard let key = key,
                let safeProject = project else { return nil }
            return ListOption.expandableCell(title: safeProject.name, key: key, imgUrl: safeProject.image, worklogs: elements)
        }
        return Section(
            title: "Projects",
            elements: elements)
    }
    
    func getOtherActivitiesSection() -> Section {
        let filteredArray = self.worklogArray.filter { worklog in
            worklog.category != "Development"
        }
        let categoryMap = Dictionary(grouping: filteredArray, by: { $0.category })
        let elements = categoryMap.map { (key, elements) in
            ListOption.expandableCell(title: key, key: key, imgUrl: "", worklogs: elements)
        }
        return Section(
            title: "Other activities",
            elements: elements)
    }
    func getLastTimeLogsSection() -> Section {
        //          biblioteca de tempo
        //          let filteredArray = self.worklogArray.filter { worklog in
        //              worklog.createdAt != last hours
        //          }
        let categoryMap = Dictionary(grouping: worklogArray, by: { $0.issue?.key })
        let elements = categoryMap.map { ( _, elements) in
            ListOption.plainCell(worklogs: elements[0])
        }
        return Section(
            title: "Last time logs",
            elements: elements)
    }
}
extension CoreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].elements.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let element = dataSource[indexPath.section].elements[indexPath.row]
        switch element {
        case .expandableCell(let title, let key, let imgUrl, let worklogs):
            let cell = tableView.dequeueReusableCell(for: indexPath) as ProjectsTableViewCell
            cell.bind(image: imgUrl, text: title, time: "\(worklogs[0].timeSpent/3600) h", tasks: "\(worklogs.count) tasks", worklogs: worklogs)
            if key == selectedKey ?? " " {
                cell.tableViewHeight.constant = CGFloat((60 * worklogs.count)+10)
            }
            if key != selectedKey ?? " " {
                cell.tableViewHeight.constant = 0
            }
            return cell
        case .plainCell(let worklog):
            let cell = tableView.dequeueReusableCell(for: indexPath) as PlainTableViewCell
            cell.bind(key: (worklog.issue?.key) ?? "Other Activities", time: (worklog.createdAt) ?? " ")
            return cell
        }
    }
}
extension CoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = dataSource[indexPath.section].elements[indexPath.row]
        switch element {
        case .expandableCell( _, let key, _, _):
            selectedKey = key
            tableView.reloadData()
        default:
            break
        }
    }
}
