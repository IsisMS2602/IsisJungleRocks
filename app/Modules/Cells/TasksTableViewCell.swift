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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBOutlet weak var taskCellView: UIView!
    
    func setTaskView() {
        taskCellView.layer.cornerRadius = 4
    }
}
