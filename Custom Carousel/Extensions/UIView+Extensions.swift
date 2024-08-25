//
//  UIView+Extensions.swift
//  Custom Carousel
//
//  Created by Akshay Naithani on 23/08/24.
//

import UIKit

extension UIView {
    
    static var xibIdentifier: String {
        return "\(self)"
    }
    
    func loadView() {
        Bundle.main.loadNibNamed(Self.xibIdentifier, owner: self, options: nil)
    }
}
