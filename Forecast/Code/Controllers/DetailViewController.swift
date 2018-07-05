//
//  DetailViewController.swift
//  Forecast
//
//  Created by Vincent Douant on 05/07/2018.
//  Copyright © 2018 Vincent Douant. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var detailItem: Weather?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }

    private func configureView() {
        if let detail = detailItem {
            WeatherPresenter(imageView: imageView, label: detailDescriptionLabel).bind(weather: detail)
        }
    }
}
