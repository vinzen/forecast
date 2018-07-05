//
//  WeatherManager.swift
//  Forecast
//
//  Created by Vincent Douant on 05/07/2018.
//  Copyright © 2018 Vincent Douant. All rights reserved.
//

import CoreData
import Foundation

class WeatherManager {
    static let sharedInstance = WeatherManager()
    private lazy var validTemperature: [String] = {
        return ["2m", "sol", "300hPa", "400hPa", "500hPa", "550hPa", "600hPa", "650hPa", "700hPa", "750hPa", "850hPa", "900hPa", "950hPa", "975hPa", "1000hPa"]
    }()
    private lazy var trashKeys: [String] = {
        return ["request_state", "request_key", "message", "model_run", "source"]
    }()

    private init() {}

    func update(response: [String: Any], completionBlock: @escaping () -> ()) {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd HH:mm:ss"
        CoreDataStack.sharedInstance.performBackgroundTask { (context) in
            for (key, value) in response {
                if self.trashKeys.contains(key) { continue }
                if let data = value as? [String: Any], let timestamp = dateFormater.date(from: key) {
                    self.createOrUpdateObject(timestamp: timestamp, data: data, context: context)
                }
            }
            context.softSave()
            completionBlock()
        }
    }

    func createOrUpdateObject(timestamp: Date, data: [String: Any], context: NSManagedObjectContext) {
        let object: Weather
        if let weather = findObject(timestamp: timestamp, context: context) {
            object = weather
        } else {
            object = Weather(context: context)
            object.timestamp = timestamp
        }
        updateObject(object, data: data, context: context)
    }

    private func findObject(timestamp: Date, context: NSManagedObjectContext) -> Weather? {
        do {
            let fetchRequest: NSFetchRequest<Weather> = Weather.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "timestamp == %@", timestamp as NSDate)
            let objects = try context.fetch(fetchRequest)
            if let weather = objects.first {
                return weather
            }
        } catch {
            let nserror = error as NSError
            print("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        return nil
    }

    private func updateObject(_ object: Weather, data: [String: Any], context: NSManagedObjectContext) {
        if let pressure = data["pression"] as? [String: Int64] {
            object.pressure = pressure["niveau_de_la_mer"] ?? 0
        } else {
            object.pressure = 0
        }
        if let rain = data["pluie"] as? Double {
            object.rain = rain
        } else {
            object.rain = 0
        }
        if let snowRisky = data["risque_neige"] as? String {
            object.snowRisky = snowRisky == "oui"
        } else {
            object.snowRisky = false
        }
        updateObjectTemperature(object, data: data, context: context)
    }

    private func updateObjectTemperature(_ object: Weather, data: [String: Any], context: NSManagedObjectContext) {
        guard let temperatures = data["temperature"] as? [String: Double] else {
            if let saveTemperatures = object.temperatures {
                object.removeFromTemperatures(saveTemperatures)
            }
            return
        }
        var newOrUpdatedTemperatures = [Temperature]()
        let toAddTemperatures = NSMutableSet()
        for (kind, value) in temperatures {
            if !validTemperature.contains(kind) { continue }
            if let temperature = object.temperatures?.first(where: { ($0 as! Temperature).kind == kind }) as? Temperature {
                temperature.value = value
                newOrUpdatedTemperatures.append(temperature)
            } else {
                let temperature = Temperature(context: context)
                temperature.kind = kind
                temperature.value = value
                newOrUpdatedTemperatures.append(temperature)
                toAddTemperatures.add(temperature)
            }
        }
        if let temperatures = object.temperatures {
            let toRemoveTemperatures = NSMutableSet()
            for temperature in temperatures {
                let temperature = temperature as! Temperature
                if let _ = newOrUpdatedTemperatures.first(where: { $0.kind == temperature.kind }) {} else {
                    toRemoveTemperatures.add(temperature)
                }
            }
            object.removeFromTemperatures(toRemoveTemperatures)
        }
        object.addToTemperatures(toAddTemperatures)
    }
}
