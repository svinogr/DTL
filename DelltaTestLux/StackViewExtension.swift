//
//  StackViewExtension.swift
//  18
//
//  Created by sergey on 16.07.2018.
//  Copyright © 2018 sergey. All rights reserved.
//

import Foundation
import UIKit
extension UIStackView {
    func changBG(color: UIColor) {
        let bg = CAShapeLayer()
        self.layer.insertSublayer(bg, at: 0)
        bg.path = UIBezierPath(rect: self.bounds).cgPath
        bg.fillColor = color.cgColor
    }
}

