//
//  BaseViewController.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit

//@available(iOS 13.0, *)
class BaseViewController: UIViewController {
    // MARK: Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    deinit {
        print("Deinit of type \(type(of: self))")
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    func setToolBar() {
        navigationController?.isToolbarHidden = false
        var items = [UIBarButtonItem]()
        items.append(UIBarButtonItem(image: UIImage(named: "challenges16Px"), style: .plain, target: self, action: nil))
        items.append(UIBarButtonItem(image: UIImage(named: "timetracking16Px"), style: .plain, target: self, action: nil))
        items.append(UIBarButtonItem(image: UIImage(named: "home16Px"), style: .plain, target: self, action: nil))
        items.append(UIBarButtonItem(image: UIImage(named: "projects16Px"), style: .plain, target: self, action: nil))
        items.append(UIBarButtonItem(image: UIImage(named: "icKebab16Px"), style: .plain, target: self, action: nil))
        for i in 0...4 {
            items[i].tintColor = UIColor.gray
        }
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        self.toolbarItems = [flexibleSpace, items[0], flexibleSpace, items[1], flexibleSpace, items[2], flexibleSpace, items[3], flexibleSpace, items[4], flexibleSpace]
    }
    func setNavigationBar(image: String) {
        navigationController?.isNavigationBarHidden = false
        self.title = "Time Trakking"
        let userImage = UIImage(named: "logo")
        let userImageView = UIImageView(image: userImage)
        userImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        userImageView.layer.cornerRadius = userImageView.frame.size.width/2
//        userImageView.layer.backgroundColor = UIColor(red: 200/255, green: 20/255, blue: 100/255, alpha: 1).cgColor
        userImageView.contentMode = .scaleAspectFit
        let imageItem = UIBarButtonItem(customView: userImageView)
        let negativeSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSpace.width = -25
        navigationItem.rightBarButtonItems = [negativeSpace, imageItem]
        navigationItem.leftBarButtonItems = [negativeSpace]
    }
}
