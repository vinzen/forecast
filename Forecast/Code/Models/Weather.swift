//
//  Weather.swift
//  Forecast
//
//  Created by Vincent Douant on 05/07/2018.
//  Copyright © 2018 Vincent Douant. All rights reserved.
//

import Foundation

extension Weather {
    /**
     Concatenates all item's attritubes into a `String`

     - returns:
     A `String` containing all item's attritubes
     
    */
    var debugInfo: String {
        var toto = timestamp!.description
        toto += "\n snowRisky: \(snowRisky)"
        toto += "\n rain: \(rain)"
        toto += "\n pressure: \(pressure)"
        if let temperatures = temperatures {
            toto += "\n temperature:"
            for temperature in temperatures {
                let temperature = temperature as! Temperature
                toto += "\n  \(temperature.kind!): \(temperature.value)"
            }
        }
        return toto
    }
}
