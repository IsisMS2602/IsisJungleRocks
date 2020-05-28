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
    case expandableCell(title: String, key: String, imgUrl: String, worklogs: [WorkLog], isExpanded: Bool)
    case plainCell(worklogs: WorkLog)
}

class CoreViewController: BaseViewController, StoryboardLoadable {
    // MARK: Static
    static func initModule() -> CoreViewController {
        let viewController = loadFromStoryboard()
        return viewController
    }
    // MARK: Outlets
    @IBOutlet weak var totalHoursWorked: UILabel!
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
        selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())
    }
    @IBAction func lastWeekButton(_ sender: Any) {
        selectedDate = Calendar.current.date(byAdding: .weekOfMonth, value: -1, to: Date())
    }
    @IBAction func thisMonthButton(_ sender: Any) {
        selectedDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
    }
    // MARK: Variables
    var colorArray: [UIColor] = [.systemYellow, .systemPink, .systemBlue, .systemOrange, .systemGreen, .magenta, .systemYellow, .systemPink, .systemBlue, .systemOrange, .systemGreen, .magenta]
    var selectedKey: String?
    typealias Section = (title: String, elements: [ListOption])
    var circularView = CircularProgressView()
    var userImage: String = SessionHelper.shared.currentUser?.picture ?? "logo"
    var worklogArray: [WorkLog] = []
    var projectArray: [Project] = []
    var dataSource: [Section] = [] { didSet {coreTableView.reloadData()}}
    var selectedDate: Date? {didSet {dataSource = getSections()}}
    // TODO create color map variable

    // MARK: Life cycle
    override func viewDidLoad() {
        self.title = "Time Tracking"
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

                // TODO populate color map using worklog keys - use group by func
                // TODO randomize color for each map entry

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
            getProjectsSection(startFrom: selectedDate),
            getOtherActivitiesSection(startFrom: selectedDate),
            getLastTimeLogsSection(startFrom: selectedDate)
        ]
    }

    func getProjectsSection(startFrom date: Date? = nil) -> Section {
        circularView.calculateCircle(layerBaseInfoArray: getProjectsTime())
        let filteredArray = self.worklogArray
            .filter { worklog in
                worklog.category == "Development"
        }
        .filter { worklog in
            guard let selectedDate = self.selectedDate else { return true }
            return worklog.createdAt >= selectedDate
        }
        let categoryMap = Dictionary(grouping: filteredArray, by: { $0.issue?.projectKey })
        let elements = categoryMap.compactMap { (key, elements) -> ListOption? in
            let project = projectArray.first { element in
                element.key == key
            }
            guard let key = key,
                let safeProject = project else { return nil }
            return ListOption.expandableCell(title: safeProject.name, key: key, imgUrl: safeProject.image, worklogs: elements, isExpanded: selectedKey == key)
        }.sorted(by: {(element1, element2) in
            switch element1 {
            case .expandableCell( _, let key1, _, _, _):
                switch element2 {
                case .expandableCell( _, let key2, _, _, _):
                    return key1 < key2
                default:
                    return false
                }
            default:
                return false
            }
        })
        return Section(
            title: "Projects",
            elements: elements)
    }

    func getOtherActivitiesSection(startFrom date: Date? = nil) -> Section {
        let filteredArray = self.worklogArray.filter { worklog in
            worklog.category != "Development"
        }.filter { worklog in
            guard let selectedDate = self.selectedDate else { return true }
            return worklog.createdAt >= selectedDate
        }
        let categoryMap = Dictionary(grouping: filteredArray, by: { $0.category })
        let elements = categoryMap.map { (key, elements) in
            ListOption.expandableCell(title: key, key: key, imgUrl: "", worklogs: elements, isExpanded: false)
        }
        return Section(
            title: "Other activities",
            elements: elements)
    }

    func getLastTimeLogsSection(startFrom date: Date? = nil) -> Section {
        let today = Date()
        let day = Calendar.current.component(.day, from: today)
        let filteredArrayByCreatedAt = worklogArray.filter { Calendar.current.component(.day, from: $0.createdAt) == day }
        let timeMap = Dictionary(grouping: filteredArrayByCreatedAt, by: { $0.issue?.key })
        let elements = timeMap.map { ( _, elements) in
            ListOption.plainCell(worklogs: elements[0])
        }
        return Section(
            title: "Last time logs",
            elements: elements)
    }

    func getProjectsTime() -> [(UIColor, Int)] {
        let filteredArray = self.worklogArray.filter { worklog in
            worklog.category == "Development"
        }
        let categoryMap = Dictionary(grouping: filteredArray, by: { $0.issue?.projectKey })
        let elements = categoryMap.map { (_, elements) -> (UIColor, Int) in
            let timeResult = elements.reduce(0) { (acc, element) -> Int in
                return acc + element.timeSpent
            }
            let colors = colorArray.remove(at: 0)
            colorArray.append(colors)
            totalHoursWorked.text = "\(timeResult/3600) h"
            return (colors, timeResult)
        }
        return elements
    }

    func filterByMonth() -> [WorkLog] {
        let today = Date()
        let thisMonth = Calendar.current.component(.month, from: today)
        let filteredArrayByCreatedAt = worklogArray.filter { Calendar.current.component(.month, from: $0.createdAt) == thisMonth }
        return (filteredArrayByCreatedAt)
    }
    func filterByLastWeek() -> [WorkLog] {
        let today = Date()
        let thisMonth = Calendar.current.component(.month, from: today)
        let filteredArrayByCreatedAt = worklogArray.filter { Calendar.current.component(.month, from: $0.createdAt) == thisMonth }
        let thisWeek = Calendar.current.component(.weekOfMonth, from: today)
        let filteredArrayByThisWeek = filteredArrayByCreatedAt.filter { Calendar.current.component(.weekOfMonth, from: $0.createdAt) == thisWeek - 1 }
        return (filteredArrayByThisWeek)
    }
    func filterByThisWeek() -> [WorkLog] {
        let today = Date()
        let thisMonth = Calendar.current.component(.month, from: today)
        let filteredArrayByCreatedAt = worklogArray.filter { Calendar.current.component(.month, from: $0.createdAt) == thisMonth }
        let thisWeek = Calendar.current.component(.weekOfMonth, from: today)
        let filteredArrayByThisWeek = filteredArrayByCreatedAt.filter { Calendar.current.component(.weekOfMonth, from: $0.createdAt) == thisWeek - 1 }
        return filteredArrayByThisWeek
    }
}
extension CoreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
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
            // TODO use key value to get color from color map
        case .expandableCell(let title, _, let imgUrl, let worklogs, let isExpanded):
            let cell = tableView.dequeueReusableCell(for: indexPath) as ProjectsTableViewCell
            cell.bind(image: imgUrl, text: title, time: "\(worklogs[0].timeSpent/3600) h", tasks: "\(worklogs.count) tasks", worklogs: worklogs, isExpanded: isExpanded, color: colorArray[indexPath.row])
            return cell
        case .plainCell(let worklog):
            let cell = tableView.dequeueReusableCell(for: indexPath) as PlainTableViewCell
            cell.bind(key: (worklog.issue?.key) ?? "Other Activities", time: ("\(worklog.createdAt)") ?? " ")
            return cell
        }
    }
}

extension CoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let element = dataSource[indexPath.section].elements[indexPath.row]
        switch element {
        case .expandableCell( _, let key, _, _, _):
            if key == selectedKey { selectedKey = nil } else { selectedKey = key }
            dataSource = getSections()
        default:
            break
        }
    }
}
