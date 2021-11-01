//
//  LoginVC.swift
//  BatChat
//
//  Created by 徐浩博 on 2021/10/30.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn
import JGProgressHUD

class LoginVC: UIViewController {
     
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.backgroundColor = UIColor.lightGray.cgColor
        field.placeholder = " Input Email Arrdess..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.backgroundColor = UIColor.lightGray.cgColor
        field.placeholder = " Password..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let fbLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email,public_profile"]
        return button
    }()
    
    private let googleLoginButton: GIDSignInButton = {
        let button = GIDSignInButton()
        return button
    }()
    
    private var loginObserver: NSObjectProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLoginNotification,
                                                               object: nil,
                                                               queue: .main) { [weak self] notification in
            guard let strongSelf = self else { return }
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        view.backgroundColor = .white
        
        emailField.delegate = self
        passwordField.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(fbLoginButton)
        scrollView.addSubview(googleLoginButton)
        fbLoginButton.delegate = self
    }
    
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        imageView.frame = CGRect(x: (scrollView.width - size) / 2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: 30,
                                  y: imageView.bottom + 10,
                                  width: scrollView.width - 60,
                                  height: 52)
        passwordField.frame = CGRect(x: 30,
                                     y: emailField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
        loginButton.frame = CGRect(x: 30,
                                     y: passwordField.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
        
        fbLoginButton.frame = CGRect(x: 30,
                                     y: loginButton.bottom + 10,
                                     width: scrollView.width - 60,
                                     height: 52)
        fbLoginButton.center = scrollView.center
        googleLoginButton.frame = CGRect(x: 30,
                                         y: fbLoginButton.bottom + 10,
                                         width: scrollView.width - 60,
                                         height: 52)
    }
    
    @objc private func loginButtonTapped() {
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        guard let email = emailField.text, let password = passwordField.text, !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        spinner.show(in: view)
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authDataResult, error in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss()
            }
            
            guard let result = authDataResult, error == nil else {
                return
            }
            let user = result.user
            print("logedin a user = \(user)")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Login Error", message: "Enter all info to login", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

    @objc private func didTapRegister() {
        let registerVC = RegisterVC()
        registerVC.title = "Create Account"
        navigationController?.pushViewController(registerVC, animated: true)
    }
}

extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            loginButtonTapped()
        }
        
        return true
    }
}

extension LoginVC: LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed login with fb")
            return
        }
        
        let fbGraphRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                        parameters: ["fields": "email, name"],
                                                        tokenString: token,
                                                        version: nil,
                                                        httpMethod: .get)
        
        fbGraphRequest.start { _, result, error in
            guard let result = result as? [String: Any], error == nil else {
                print("fbGraphRequest failed.")
                return
            }
            
            guard let userName = result["name"] as? String,
                    let email = result["email"] as? String else {
                print("filed to get name & email from FBGraphRequest result.")
                return
            }
            
            let nameComponents = userName.components(separatedBy: " ")
            guard nameComponents.count >= 2 else { return }
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            
            DatabaseManger.shared.userExists(with: email) { exists in
                if !exists {
                    DatabaseManger.shared.insertUser(with: ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email))
                }
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            
            FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authDataResult, error in
                guard let strongSelf = self else { return }
                
                guard authDataResult != nil, error == nil else {
                    if let error = error {
                        print("fb credential login failed \(error.localizedDescription)")
                    }
                    return
                }
                
                print("fb credential login success")
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
