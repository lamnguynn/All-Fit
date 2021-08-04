//
//  Extension+Button.swift
//  All Fit
//
//  Created by Lam Nguyen on 1/11/21.
//

import UIKit

extension UIButton{
    func applyCustomization(text: String, textColor: UIColor, backGroundColor: UIColor){
        self.setTitle(text, for: .normal)
        self.setTitleColor(textColor, for: .normal)
        self.backgroundColor = backGroundColor
        self.layer.cornerRadius =  3

    }
}
