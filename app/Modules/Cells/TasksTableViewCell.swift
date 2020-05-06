//
//  TasksTableViewCell.swift
//  IsisJungleRocks
//
//  Created by Isis Silva on 4/16/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import UIKit

class TasksTableViewCell: UITableViewCell, NibLoadable {

    override func awakeFromNib() {
        super.awakeFromNib()
        setTaskView()
        cellView.layer.borderWidth = 1
        cellView.layer.borderColor = UIColor(red: 248/255, green: 248/255, blue: 250/255, alpha: 1).cgColor
        cellView.layer.cornerRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBOutlet weak var cellView: UIView!
    func setTaskView() {

    }
}
