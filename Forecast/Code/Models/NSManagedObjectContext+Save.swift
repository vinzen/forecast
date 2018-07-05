//
//  NSManagedObjectContext+Save.swift
//  Forecast
//
//  Created by Vincent Douant on 05/07/2018.
//  Copyright © 2018 Vincent Douant. All rights reserved.
//

import CoreData
import Foundation

extension NSManagedObjectContext {
    func softSave() {
        if hasChanges {
            do {
                try save()
            } catch {
                let nserror = error as NSError
                print("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
