//
//  ProjectsTableViewCell.swift
//  IsisJungleRocks
//
//  Created by Isis Silva on 4/16/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import UIKit

class ProjectsTableViewCell: UITableViewCell, NibLoadable {
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTableView()
        setUpHeaderView()
        addShadow(view: headerProjectView!)
        //selectedBackgroundView?.backgroundColor = UIColor.clear
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    // MARK: Variables
    var dataSource: [WorkLog] = [] { didSet {} }
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var projectImage: UIImageView!
    @IBOutlet weak var projectLabel: UILabel!
    @IBOutlet weak var tasksLabel: UILabel!
    @IBOutlet weak var loggedHouersLabel: UILabel!
    @IBOutlet weak var headerProjectView: UIView!
    @IBOutlet weak var tasksTableView: UITableView! {
        didSet {
        }
    }
    private func setupTableView() {
        tasksTableView.dataSource = self
        tasksTableView.delegate = self
        tasksTableView.tableFooterView = UIView()
        tasksTableView.tableHeaderView = UIView()
        tasksTableView.register(TasksTableViewCell.self)
        tasksTableView.backgroundColor = UIColor.white
        tasksTableView.layer.cornerRadius = 4
        tasksTableView.separatorInset = .zero
        tasksTableView.layer.borderWidth = 1
        tasksTableView.layer.borderColor = UIColor(red: 248/255, green: 248/255, blue: 250/255, alpha: 1).cgColor
        tasksTableView.separatorStyle = .none
        tasksTableView.rowHeight = UITableView.automaticDimension
        tasksTableView.estimatedRowHeight = 48
    }
    func setUpHeaderView() {
        headerProjectView.layer.cornerRadius = 4
        colorView.layer.cornerRadius = 2
    }
    func bind(image: String, text: String, time: String, tasks: String, worklogs: [WorkLog]) {
        projectLabel.text = text
        loggedHouersLabel.text = time
        tasksLabel.text = tasks
        let imageUrlString = image
        guard let imageUrl: URL = URL(string: imageUrlString),
            let imageData = try? Data(contentsOf: imageUrl) else {
                return
        }
        self.projectImage.image = UIImage(data: imageData)
        projectImage.makeRounded()
        self.dataSource = worklogs
    }
    func setCellHeight() {
    }
}

extension ProjectsTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as TasksTableViewCell
        let element = dataSource[indexPath.row]
        cell.bindTasks(key: (element.issue?.key) ?? "", taskName: (element.issue?.components?[0]) ?? "", timeLogged: "\(element.timeSpent/3600) h")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
}
