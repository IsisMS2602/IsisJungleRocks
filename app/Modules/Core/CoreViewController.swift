//
//  CoreViewController.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit
import SVProgressHUD

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
    var circularView = CircularProgressView()
    var userImage: String = ""
    let sections: [String] = ["Projects", "Other Activities", "Last Time Logs"]
    var worklogArray: [WorkLog] = [] {didSet {coreTableView.reloadData()}}
    var projectArray: [Project] = [] {didSet {coreTableView.reloadData()}}
    var categoryArray: [WorkLog] = [] {didSet {coreTableView.reloadData()}}
    // MARK: Life cycle
    override func viewDidLoad() {
        circularView.center.x = (viewForCircularView.center.x - 8)/2
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
        coreTableView.backgroundColor = UIColor.clear
        coreTableView.tableFooterView = UIView()
        coreTableView.tableHeaderView = UIView()
        coreTableView.rowHeight = 88
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
        APIManager.GetWorkLogs.init(key: "048955f1ea2594e640c70c15061cbd1025a03cdc").request {
            response in
            switch response {
            case .success(let worklog) :
                self.getUserProjects()
                self.worklogArray.append(contentsOf: worklog)
                for i in 0...self.worklogArray.count-1 {
                    if self.worklogArray[i].category == "Development" {
                        self.categoryArray.append(contentsOf: worklog)
                    }
                }
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
        APIManager.GetProjects.init(key: "048955f1ea2594e640c70c15061cbd1025a03cdc").request {
            response in
            switch response {
            case .success(let project) :
                self.projectArray.append(contentsOf: project)
                SVProgressHUD.dismiss()
            case .failure:
                let alert = UIAlertController(title: "Unable to trek your projects", message: "Check your conection status", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive))
                SVProgressHUD.dismiss()
                self.present(alert, animated: true)
            }
        }
    }
}
extension CoreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    //    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    //         let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
    //         headerView.backgroundColor = UIColor.clear
    //        return headerView
    //    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var sectionTitle: String = ""
        switch section {
        case 0:
            sectionTitle = sections[0]
        case 1:
            sectionTitle = sections[1]
        case 2:
            sectionTitle = sections[2]
        default:
            sectionTitle = " "
        }
        return sectionTitle
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRowsInSection = 0
        switch section {
        case 0:
            numberOfRowsInSection = projectArray.count
        case 1:
            numberOfRowsInSection = categoryArray.count
        case 2:
            numberOfRowsInSection = projectArray.count
        default:
            numberOfRowsInSection =  0
        }
        return numberOfRowsInSection
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ProjectsTableViewCell
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ProjectsTableViewCell
            cell.separatorInset.right = .greatestFiniteMagnitude
            cell.separatorInset.left = .greatestFiniteMagnitude
            let workLog = worklogArray[indexPath.row]
            let projects = projectArray[indexPath.row]
            cell.bind(image: projects.image, text: projects.name, time: "\(workLog.timeSpent/3600)h", tasks: "\(workLog.category.count) tasks")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ProjectsTableViewCell
            let catergory = categoryArray[indexPath.row]
            cell.bind(image: "", text: catergory.category, time: "\(catergory.timeSpent/3600)h", tasks: "\(catergory.category.count) tasks")
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(for: indexPath) as ProjectsTableViewCell
            return cell
        default:
            break
        }
        return cell
    }
}
extension CoreViewController: UITableViewDelegate {
    //    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //
    //        print(indexPath.row)
    //        tableView.rowHeight = 188
    //        coreTableView.reloadData()
    //
    //
    //    }
    //    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    //        print(indexPath.row, "deselected")
    //        tableView.rowHeight = 88
    //        coreTableView.reloadData()
    //    }
}
