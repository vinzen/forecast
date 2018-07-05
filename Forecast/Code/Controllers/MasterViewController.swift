//
//  MasterViewController.swift
//  Weather
//
//  Created by Vincent Douant on 05/07/2018.
//  Copyright © 2018 Vincent Douant. All rights reserved.
//

import UIKit
import CoreData

class MasterViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var dataSource: WeatherDataSource? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = WeatherDataSource(managedObjectContext: managedObjectContext!, cellIdentifier: "Cell", configureCellBlock: { [weak self] (cell, weather) in
            self?.configureCell(cell, weather: weather)
        })
        tableView.dataSource = dataSource
        if let split = splitViewController {
            split.preferredDisplayMode = .allVisible
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        refreshData()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        tableView.reloadData()
        super.viewWillAppear(animated)
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = dataSource?.object(at: indexPath)
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    func configureCell(_ cell: UITableViewCell, weather: Weather) {
        cell.textLabel!.text = DateFormatter.localizedString(from: weather.timestamp!, dateStyle: .long, timeStyle: .short)
    }

    private func refreshData() {
        APIManager.sharedInstance.fetchWeather(successBlock: { (data) in
            WeatherManager.sharedInstance.update(data: data) {
                DispatchQueue.main.async {
                    self.dataSource?.refresh()
                    self.tableView.reloadData()
                }
            }
        }, errorBlock: nil)
    }
}
