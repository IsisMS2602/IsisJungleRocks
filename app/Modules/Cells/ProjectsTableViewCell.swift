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
        footerView.isHidden = false
        setUpHeaderView()
        setupFooterView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(true, animated: true)
    
    }
    
    @IBOutlet weak var headerView: UIView?
    @IBOutlet weak var headerProjectView: UIView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var tasksTableView: UITableView!
    
    private func setupTableView() {
        tasksTableView.dataSource = self
        tasksTableView.register(TasksTableViewCell.self)
        tasksTableView.tableFooterView = UIView()
        tasksTableView.tableHeaderView = UIView()
        
    }
    func setUpHeaderView() {
        headerProjectView.layer.cornerRadius = 4
        
        
    }
    func setupFooterView() {
        
    }
    
    
}

extension ProjectsTableViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath) as TasksTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
      
    }
    
}
