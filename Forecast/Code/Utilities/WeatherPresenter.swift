//
//  WeatherPresenter.swift
//  Forecast
//
//  Created by Vincent Douant on 05/07/2018.
//  Copyright © 2018 Vincent Douant. All rights reserved.
//

import UIKit

protocol WeatherPresenterItem {
    var _snowRisky: Bool { get }
    var _debugInfo: String { get }
    var _rain: Double { get }
}

// For testing purpose
extension Weather : WeatherPresenterItem {
    var _snowRisky: Bool {
        return snowRisky
    }

    var _debugInfo: String {
        return debugInfo
    }

    var _rain: Double {
        return rain
    }
}

class WeatherPresenter {
    private let imageView: UIImageView
    private let label: UILabel

    init(imageView: UIImageView, label: UILabel) {
        self.imageView = imageView
        self.label = label
    }

    func bind(weather: WeatherPresenterItem) {
        label.text = weather._debugInfo
        imageView.image = UIImage(named: getImageName(weather: weather))
    }

    func getImageName(weather: WeatherPresenterItem) -> String {
        if weather._snowRisky {
            return "snow"
        }
        if weather._rain > 0 {
            return "rain"
        }
        return "sun"
    }
}
