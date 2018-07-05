//
//  ForecastTests.swift
//  ForecastTests
//
//  Created by Vincent Douant on 05/07/2018.
//  Copyright © 2018 Vincent Douant. All rights reserved.
//

import XCTest

@testable import Forecast

class WeatherPresenterItemMock : WeatherPresenterItem {
    var snowRisky = false
    var _snowRisky: Bool {
        return snowRisky
    }

    var _debugInfo: String {
        return ""
    }

    var rain = 0.0
    var _rain: Double {
        return rain
    }
}

class WeatherPresenterTests: XCTestCase {
    private var presenter: WeatherPresenter?
    private let dummyImageView = UIImageView()
    private let dummyLabel = UILabel()

    override func setUp() {
        super.setUp()
        presenter = WeatherPresenter(imageView: dummyImageView, label: dummyLabel)
    }

    func testSnowImagePresentation() {
        let weather = WeatherPresenterItemMock()
        weather.snowRisky = true
        XCTAssert(presenter?.getImageName(weather: weather) == "snow")
    }

    func testRainImagePresentation() {
        let weather = WeatherPresenterItemMock()
        weather.rain = 99.0
        XCTAssert(presenter?.getImageName(weather: weather) == "rain")
    }

    func testSunImagePresentation() {
        let weather = WeatherPresenterItemMock()
        XCTAssert(presenter?.getImageName(weather: weather) == "sun")
    }

    func testPriorityImagePresentation() {
        let weather = WeatherPresenterItemMock()
        weather.snowRisky = true
        weather.rain = 99.0
        XCTAssert(presenter?.getImageName(weather: weather) == "snow")
    }
}
