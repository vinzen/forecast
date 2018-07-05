//
//  WeatherDataSource.swift
//  Forecast
//
//  Created by Vincent Douant on 05/07/2018.
//  Copyright © 2018 Vincent Douant. All rights reserved.
//

import UIKit
import CoreData


typealias WeatherDataSourceeConfigureCellBlockType = (_ cell: UITableViewCell, _ item: Weather) -> Void

class WeatherDataSource : NSObject, UITableViewDataSource {
    fileprivate let configureCellBlock: WeatherDataSourceeConfigureCellBlockType
    fileprivate let cellIdentifier: String
    fileprivate let managedObjectContext: NSManagedObjectContext
    fileprivate var _fetchedResultsController: NSFetchedResultsController<Weather>? = nil
    fileprivate var fetchedResultsController: NSFetchedResultsController<Weather> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }

        let fetchRequest: NSFetchRequest<Weather> = Weather.fetchRequest()

        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20

        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)

        fetchRequest.sortDescriptors = [sortDescriptor]

        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        _fetchedResultsController = aFetchedResultsController

        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }

        return _fetchedResultsController!
    }

    init(managedObjectContext: NSManagedObjectContext, cellIdentifier: String, configureCellBlock: @escaping WeatherDataSourceeConfigureCellBlockType) {
        self.configureCellBlock = configureCellBlock
        self.cellIdentifier = cellIdentifier
        self.managedObjectContext = managedObjectContext
    }

    func refresh() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
        }
    }

    func object(at indexPath: IndexPath) -> Weather {
        return fetchedResultsController.object(at: indexPath)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        configureCellBlock(cell, fetchedResultsController.object(at: indexPath))
        return cell
    }
}
