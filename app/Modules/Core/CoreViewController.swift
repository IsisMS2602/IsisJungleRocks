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
    @IBOutlet weak var coreTableView: UITableView! {
        didSet {
            coreTableView.reloadData()
        }
    }
    @IBAction func thisWeekButton(_ sender: Any) {
        SessionHelper.shared.logout()
    }
    var userImage: String = ""

    var worklogArray: [WorkLog] = [] {didSet {coreTableView.reloadData()}}
    var projectArray: [Project] = [] {didSet {coreTableView.reloadData()}}
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonsUI()
        setToolBar()
        setupTableView()
        setNavigationBar(image: userImage)
        getUserTimeTrakking()
        getUserProjects()
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
        coreTableView.rowHeight = 200
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
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.show()
        APIManager.GetWorkLogs.init(key: "048955f1ea2594e640c70c15061cbd1025a03cdc").request {
            response in
            switch response {
            case .success(let worklog) :
                print("sucesso")
                self.worklogArray.append(contentsOf: worklog)
                SVProgressHUD.dismiss()
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
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.show()
        APIManager.GetProjects.init(key: "048955f1ea2594e640c70c15061cbd1025a03cdc").request {
            response in
            switch response {
            case .success(let project) :
                print(project)
                self.projectArray.append(contentsOf: project)
                SVProgressHUD.dismiss()
            case .failure:
                let alert = UIAlertController(title: "Unable to trek your projects", message: "Check your conection status", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive))
                SVProgressHUD.dismiss()
                self.present(alert, animated: true)
                print("erro")
            }
        }
    }
}
extension CoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (projectArray.count)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ProjectsTableViewCell
        cell.separatorInset.right = .greatestFiniteMagnitude
        cell.separatorInset.left = .greatestFiniteMagnitude
        let workLog = worklogArray[indexPath.row]
        let projects = projectArray[indexPath.row]
        cell.bind(image: projects.image, text: projects.name, time: "\(workLog.timeSpent/3600)h", tasks: "\(workLog.category.count) tasks")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
