//
//  WeathersListViewController.swift
//  SKBWeatherApp
//
//  Created by Андрей Щербинин on 19.06.17.
//  Copyright © 2017 AS. All rights reserved.
//

import UIKit
import CoreData

class WeathersListViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var stateController: WeatherStateController?
    var tableViewDataSource: WeatherListDataSource?
    var tableViewDelegate: WeatherListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = BackgroundView()
        tableView.register(UINib(nibName: WeatherCell.identifier, bundle: nil), forCellReuseIdentifier: WeatherCell.identifier)
        stateController?.frc.delegate = self
        do {
            try stateController?.frc.performFetch()
        } catch {
            print(error)
        }
        
        if let stateController = stateController {
            tableViewDataSource = WeatherListDataSource(tableView: tableView, stateController: stateController)
            tableViewDelegate = WeatherListDelegate(tableView: tableView, stateController: stateController)
        }
        
        
        self.title = "Погодка!"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let weather = stateController?.frc.object(at: indexPath) as! Weather
                let cell = tableView.cellForRow(at: indexPath) as! WeatherCell
                cell.temperature = "\(weather.temperature)"
                cell.date = "\(weather.dt!)"
                cell.location = weather.cityName
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
