//
//  WeatherPresenter.swift
//  Forecast
//
//  Created by Vincent Douant on 05/07/2018.
//  Copyright © 2018 Vincent Douant. All rights reserved.
//

import UIKit

class WeatherDetailPresenter {
    private let imageView: UIImageView
    private let label: UILabel

    init(imageView: UIImageView, label: UILabel) {
        self.imageView = imageView
        self.label = label
    }

    func bind(weather: Weather) {
        label.text = weather.debugInfo
        imageView.image = UIImage(named: getImageName(weather: weather))
    }

    private func getImageName(weather: Weather) -> String {
        if weather.snowRisky {
            return "snow"
        }
        if weather.rain > 0 {
            return "rain"
        }
        return "sun"
    }
}
