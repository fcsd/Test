//
//  ViewController.swift
//  test
//
//  Created by admin on 1/20/19.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit

protocol TennantDelegate: class {
    func didChosingTennant(tennant: Tennant)
    func didHappendError(error: Error)
}

class LoginViewController: UIViewController, TennantDelegate {
    
    let logoView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var selectTennatButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Select tennant", for: .normal)
        button.addTarget(self, action: #selector(getTennantList), for: .touchUpInside)
        return button
    }()
    
    lazy var tennantView: TennantView = {
        let tennantView = TennantView(delegate: self)
        tennantView.alpha = 0.0
        tennantView.clipsToBounds = true
        tennantView.layer.cornerRadius = 10
        return tennantView
    }()
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Username"
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .red
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        return button
    }()
    
    let hidingOffset = CGFloat(600)
    let showOffset = CGFloat(0)
    
    var centerXUsernameConstraint: NSLayoutConstraint?
    var centerXPasswordConstraint: NSLayoutConstraint?
    var centerXLoginConstraint: NSLayoutConstraint?
    var topLoginFromButtonConstraint: NSLayoutConstraint?
    var topLoginFromTextFieldConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "LoginBG"))
        
        addView()
        addLayout()
    }

    func addView() {
        view.addSubview(logoView)
        view.addSubview(selectTennatButton)
        view.addSubview(tennantView)
        view.addSubview(usernameTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
    }
    
    func addLayout() {
        
        NSLayoutConstraint.activate([
            logoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            logoView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoView.widthAnchor.constraint(equalToConstant: 100),
            logoView.heightAnchor.constraint(equalToConstant: 100),
            
            selectTennatButton.topAnchor.constraint(equalTo: logoView.bottomAnchor, constant: 15),
            selectTennatButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selectTennatButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            selectTennatButton.heightAnchor.constraint(equalToConstant: 40),
            
            tennantView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tennantView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tennantView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            tennantView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            usernameTextField.topAnchor.constraint(equalTo: selectTennatButton.bottomAnchor, constant: 8),
            usernameTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            passwordTextField.topAnchor.constraint(equalTo: usernameTextField.bottomAnchor, constant: 8),
            passwordTextField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),
            
            loginButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            loginButton.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        centerXUsernameConstraint = usernameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -hidingOffset)
        centerXUsernameConstraint?.isActive = true
        
        centerXPasswordConstraint = passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -hidingOffset)
        centerXPasswordConstraint?.isActive = true
        
        centerXLoginConstraint = loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -hidingOffset)
        centerXLoginConstraint?.isActive = true
        
        topLoginFromTextFieldConstraint = loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 8)
        topLoginFromButtonConstraint = loginButton.topAnchor.constraint(equalTo: selectTennatButton.bottomAnchor, constant: 8)
        topLoginFromTextFieldConstraint?.isActive = true
    }
    
    @objc func getTennantList() {
        if centerXLoginConstraint?.constant == showOffset {
            animateAppearingContent(constant: hidingOffset, completion: {
                self.loadTennantList()
            })
        } else {
            loadTennantList()
        }
    }
    
    func loadTennantList() {
        self.tennantView.loadTennants()
        self.animateTennantView(alpha: 1.0)
    }
    
    @objc func loginPressed() {
        print("LOGIN")
    }
    
    func animateTennantView(alpha: CGFloat, completion: (() -> ())? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.tennantView.alpha = alpha
        }, completion: { (_) in
            completion?()
        })
    }
    
    func showErrorAlert(error: Error) {
        let alertController = UIAlertController(title: "Something went wrong", message:
            error.localizedDescription, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func animateAppearingContent(constant: CGFloat, tennatType: [TennatType]? = nil, completion: (() -> ())? = nil) {
        if centerXLoginConstraint?.constant == hidingOffset {
            self.centerXUsernameConstraint?.constant = -hidingOffset
            self.centerXPasswordConstraint?.constant = -hidingOffset
            self.centerXLoginConstraint?.constant = -hidingOffset
            self.view.layoutIfNeeded()
        }
        
        if let tennatType = tennatType {
            let needHide = !tennatType.contains{ $0 == TennatType.password }
            usernameTextField.isHidden = needHide
            passwordTextField.isHidden = needHide
            topLoginFromButtonConstraint?.isActive = needHide
            topLoginFromTextFieldConstraint?.isActive = !needHide
            self.view.layoutIfNeeded()
        }
        
        self.centerXUsernameConstraint?.constant = constant
        self.centerXPasswordConstraint?.constant = constant
        self.centerXLoginConstraint?.constant = constant
        
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            completion?()
        })
    }
}

extension LoginViewController {
    func didChosingTennant(tennant: Tennant) {
        selectTennatButton.setTitle(tennant.name, for: .normal)
        animateTennantView(alpha: 0.0, completion: {
            self.animateAppearingContent(constant: self.showOffset, tennatType: tennant.types)
        })
    }
    
    func didHappendError(error: Error) {
        showErrorAlert(error: error)
    }
}

