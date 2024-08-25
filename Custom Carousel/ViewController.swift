//
//  ViewController.swift
//  Custom Carousel
//
//  Created by Akshay Naithani on 22/08/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var carouselView: CarouselView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let images = [UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3")].compactMap { $0 }

        carouselView.configure(with: images)
    }
}
