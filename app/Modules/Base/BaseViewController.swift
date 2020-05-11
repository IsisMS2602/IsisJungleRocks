//
//  BaseViewController.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit
import Kingfisher

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
        for index in 0...4 {
            items[index].tintColor = UIColor.gray
        }
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        self.toolbarItems = [flexibleSpace, items[0], flexibleSpace, items[1], flexibleSpace, items[2], flexibleSpace, items[3], flexibleSpace, items[4], flexibleSpace]
    }
    func setNavigationBar(image: String) {
        navigationController?.isNavigationBarHidden = false
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.loadImage(fromUrl: image, withParams: LoadImageParams(backgroundColor: .clear, placeholder: .none, placeholderContentMode: .scaleAspectFit, contentMode: .scaleAspectFit, showActivityIndicator: false, activityIndicatorColor: .black, cornerRadius: (imageView.frame.width * 100)/2, forceRefresh: true, resizeBeforeCaching: false), completion: nil)
        let imageItem = UIBarButtonItem(customView: imageView)
        navigationItem.rightBarButtonItem = imageItem
    }
}
