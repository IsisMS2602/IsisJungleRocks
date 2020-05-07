//
//  TasksTableViewCell.swift
//  IsisJungleRocks
//
//  Created by Isis Silva on 4/16/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import UIKit

class TasksTableViewCell: UITableViewCell, NibLoadable {
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setTaskUICell(view: cellView)
    }
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var timeLoggedLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    func setTaskUICell (view: UIView) {
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(red: 248/255, green: 248/255, blue: 250/255, alpha: 1).cgColor
        view.layer.cornerRadius = 4
    }
    func bindTasks(key: String, taskName: String, timeLogged: String) {
        keyLabel.text = key.uppercased()
        taskNameLabel.text = taskName
        timeLoggedLabel.text = timeLogged
    }
}
