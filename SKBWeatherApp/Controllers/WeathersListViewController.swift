//
//  WeathersListViewController.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 19.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import UIKit

class WeathersListViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: WeatherCell.identifier, bundle: nil), forCellReuseIdentifier: WeatherCell.identifier)
//        stateController?.frc.delegate = self
//        do {
//            try stateController?.frc.performFetch()
//        } catch {
//            print(error)
//        }
//        
//        if let stateController = stateController {
//            tableViewDataSource = ToDoTableViewDataSource(tableView: tableView, stateController: stateController)
//            tableViewDelegate = ToDoTableViewDelegate(tableView: tableView, stateController: stateController)
//        }
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
        
        self.title = "Погодка!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier, for: indexPath) as! WeatherCell
        cell.date = "10/15/15"
        cell.temperature = "10 C"
        cell.location = "CURERNT"
        return cell
    }
}
