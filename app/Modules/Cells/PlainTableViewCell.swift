//
//  PlainTableViewCell.swift
//  IsisJungleRocks
//
//  Created by Isis Silva on 5/4/20.
//  Copyright © 2020 Jungle Devs. All rights reserved.
//

import UIKit

class PlainTableViewCell: UITableViewCell, NibLoadable {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLoggedLabel: UILabel!
    func bind(key: String, time: String) {
        nameLabel.text = key.uppercased()
        timeLoggedLabel.text = time
    }
}
