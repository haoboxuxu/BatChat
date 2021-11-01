//
//  NewConversationVC.swift
//  BatChat
//
//  Created by 徐浩博 on 2021/10/30.
//

import UIKit
import JGProgressHUD

class NewConversationVC: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let searchbar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search Users ..."
        return bar
    }()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.isHidden = true
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.text = "No user found"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchbar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancle", style: .done, target: self, action: #selector(dismissSelf))
        view.backgroundColor = .white
        searchbar.becomeFirstResponder()
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

extension NewConversationVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
