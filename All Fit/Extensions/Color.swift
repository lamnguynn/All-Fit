//
//  Color.swift
//  All Fit
//
//  Created by Lam Nguyen on 8/9/21.
//

import Foundation
import UIKit

extension UIColor{
    convenience init(red: Int, green: Int, blue: Int) {
        let r: CGFloat = CGFloat(red) / 255
        let g: CGFloat = CGFloat(green) / 255
        let b: CGFloat = CGFloat(blue) / 255
        
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
}
