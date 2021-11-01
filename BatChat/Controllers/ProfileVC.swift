//
//  ProfileVC.swift
//  BatChat
//
//  Created by 徐浩博 on 2021/10/30.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ProfileVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let data = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
}

extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alertSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        alertSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { [weak self] _ in
            guard let strongSelf = self else { return }
            
            // log out fb
            FBSDKLoginKit.LoginManager().logOut()
            // log out google
            GIDSignIn.sharedInstance().signOut()
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                let loginVC = LoginVC()
                let navC = UINavigationController(rootViewController: loginVC)
                navC.modalPresentationStyle = .fullScreen
                strongSelf.present(navC, animated: true)
            } catch {
                print("signOut error \(error.localizedDescription)")
            }
        }))
        
        alertSheet.addAction(UIAlertAction(title: "Cancle", style: .cancel, handler: nil))
        
        present(alertSheet, animated: true)
        
        
    }
}
