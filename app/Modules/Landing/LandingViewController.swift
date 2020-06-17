//
//  LandingViewController.swift
//  IsisJungleRocks
//
//  Created by Antonio Duarte on 2/2/18.
//  Copyright © 2018 Jungle Devs. All rights reserved.
//

import UIKit
import SVProgressHUD

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
        warningLabelHidden()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        navigationController?.isNavigationBarHidden = true
        navigationController?.isToolbarHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
          navigationController?.setNavigationBarHidden(true, animated: false)
          navigationController?.setToolbarHidden(true, animated: false)
      }
    // MARK: Variables
    var email: String = ""
    var password: String = ""
    // MARK: Outlets
    @IBOutlet weak var joinInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailNotValidLabel: UILabel!
    @IBOutlet weak var passwordNotValidLabel: UILabel!
    @IBAction func joinButton(_ sender: Any) {
        loginGetRequest()
    }
    func setLoginButtonEnabled(email: String, password: String) {
        if isEmailValid(email: email) && isPasswordValid(password: password) == true {
            joinInButton.isEnabled = true
            joinInButton.backgroundColor = UIColor(red: 22/255, green: 155/255, blue: 58/255, alpha: 1)
            warningLabelHidden()
        }
        if (isEmailValid(email: email) == true) && (isPasswordValid(password: password) == false) {
            inicialButtonState()
            emailNotValidLabel.isHidden = true
            passwordNotValidLabel.isHidden = false
        }
        if (isEmailValid(email: email) == false) && (isPasswordValid(password: password) == true) {
            inicialButtonState()
            emailNotValidLabel.isHidden = false
            passwordNotValidLabel.isHidden = true
        }
        if (isEmailValid(email: email) == false) && (isPasswordValid(password: password) == false) {
            inicialButtonState()
            emailNotValidLabel.isHidden = false
            passwordNotValidLabel.isHidden = false
        }
        if email == "" {
            emailNotValidLabel.isHidden = true
        }
        if password == "" {
            passwordNotValidLabel.isHidden = true
        }
    }
    func warningLabelHidden() {
        emailNotValidLabel.isHidden = true
        passwordNotValidLabel.isHidden = true
    }
    func inicialButtonState() {
        joinInButton.layer.cornerRadius = 20
        joinInButton.isEnabled = false
        joinInButton.backgroundColor = UIColor(red: 22/255, green: 155/255, blue: 58/255, alpha: 0.5)
    }
    func loginGetRequest() {
        SVProgressHUD.setDefaultAnimationType(.flat)
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.show()
        APIManager.Login.init(email: email, password: password).request { response in
            switch response {
            case .success(let userResponse) :
                    print("sucesso")
                    SessionHelper.shared.createSession(user: userResponse.user, token: userResponse.key)
                    let viewController = CoreViewController.initModule()
                    self.navigationController?.pushViewController(viewController, animated: true)
                    SVProgressHUD.dismiss()
            case .failure:
                let alert = UIAlertController(title: "Unable to log in", message: "Check your conection status", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive))
                SVProgressHUD.dismiss()
                self.present(alert, animated: true)
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
