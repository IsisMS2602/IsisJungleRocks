//
//  CoreViewController.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var coreTableView: UITableView!
    @IBAction func thisWeekButton(_ sender: Any) {
        SessionHelper.shared.logout()
    }
    //MARK: Variables
    var userImage = " "
    // MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonsUI()
        setToolBar()
        setupTableView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(false)
        setNavigationBar(image: userImage)
    }
    private func setupTableView() {
        coreTableView.dataSource = self
        coreTableView.register(ProjectsTableViewCell.self)
    }
    func setButtonsUI() {
        thisWeekButtonUI.layer.cornerRadius = 20
        thisWeekButtonUI.backgroundColor = UIColor(red: 88/255, green: 97/255, blue: 121/255, alpha: 1)
        lastWeekButtonUI.layer.cornerRadius = 20
        lastWeekButtonUI.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 250/255, alpha: 1)
        thisMonthButtonUI.layer.cornerRadius = 20
        thisMonthButtonUI.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 250/255, alpha: 1)
    }
}
extension CoreViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as ProjectsTableViewCell
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
