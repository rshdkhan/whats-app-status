//
//  ViewController.swift
//  status
//
//  Created by Napster on 21/06/2019.
//  Copyright © 2019 Napster. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mTableView: UITableView!
    var users = [User]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mTableView.delegate = self
        mTableView.dataSource = self
        
        mTableView.rowHeight = UITableViewAutomaticDimension
        mTableView.estimatedRowHeight = 75
        
        mTableView.separatorStyle = .none
        mTableView.allowsSelection = false
        
        mTableView.register(UINib(nibName: "ListingTableViewCell", bundle: nil), forCellReuseIdentifier: "ListingTableViewCell")
    }

    override func viewDidAppear(_ animated: Bool) {
        let dataSource = DataSource()
        dataSource.getUsers { (users) in
            guard let users = users else {
                print("users array is empty ...")
                return
            }
            
            self.users = users
            self.mTableView.reloadData()
            print(users)
        }
    }
}

//table view delegates and datasource
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListingTableViewCell", for: indexPath) as! ListingTableViewCell
        
        cell.setup(user: users[indexPath.row])
        
        return cell
    }
    
    
}

