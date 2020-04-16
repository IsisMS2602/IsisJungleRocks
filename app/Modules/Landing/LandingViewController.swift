//
//  LandingViewController.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit

class LandingViewController: BaseViewController, StoryboardLoadable {
    // MARK: Static
    static func initModule() -> LandingViewController {
        let viewController = loadFromStoryboard()
        return viewController
    }
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        inicialButtonState()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    // MARK: Variables
    var email: String = ""
    var password: String = ""
    // MARK: Outlets
    @IBOutlet weak var joinInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func joinButton(_ sender: Any) {
        loginGetRequest()
    }
    func setLoginButtonEnabled(email: String, password: String) {
        if isEmailValid(email: email) && isPasswordValid(password: password) == true {
            joinInButton.isEnabled = true
            joinInButton.backgroundColor = UIColor(red: 22/255, green: 155/255, blue: 58/255, alpha: 1)
            print("Is  validated")
        } else {
            joinInButton.isEnabled = false
            joinInButton.backgroundColor = UIColor(red: 22/255, green: 155/255, blue: 58/255, alpha: 0.5)
            print("not valid")
        }
    }
    func inicialButtonState() {
        joinInButton.layer.cornerRadius = 20
        joinInButton.isEnabled = false
        joinInButton.backgroundColor = UIColor(red: 22/255, green: 155/255, blue: 58/255, alpha: 0.5)
    }
    func loginGetRequest() {
        APIManager.GetUser.init(email: email, password: password).request() {
            response in
            switch response {
            case .success(let userResponse) :
                if userResponse.count == 0 {
                    let alert = UIAlertController(title: "User not found", message: "Enter with another email acount", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive))
                    self.present(alert, animated: true)
                } else {
                    self.navigationController?.pushViewController(CoreViewController.initModule(), animated: true)
                    SessionHelper.shared.createSession(user: userResponse[0], token: "1234")
                }
            case .failure:
                print("erro")
            }
        }
    }
}

extension LandingViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        email = emailTextField.text!
        password = passwordTextField.text!
        setLoginButtonEnabled(email: email, password: password)
    }
}
