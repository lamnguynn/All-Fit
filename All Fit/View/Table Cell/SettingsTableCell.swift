//
//  SettingsTableCell.swift
//  All Fit
//
//  Created by Lam Nguyen on 8/9/21.
//

import UIKit

class SettingsTableCell: UITableViewCell {

    // MARK: asset set up
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        
        return titleLabel
    }()
    
    let continueButton: UIButton = {
        let continueButton = UIButton()
        
        return continueButton
    }()
    
    let switchToggle: UISwitch = {
        let switchToggle = UISwitch()
        
        return switchToggle
    }()
    
    // MARK: initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //Add the assets to the view
        contentView.addSubview(titleLabel)
        contentView.addSubview(continueButton)
        contentView.addSubview(switchToggle)
        
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.minimumScaleFactor = 0.5
        continueButton.titleLabel?.adjustsFontSizeToFitWidth = true
        continueButton.titleLabel?.minimumScaleFactor = 0.5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame =      CGRect(x: 12,                                            //Displacement from the left
                                       y: 0,                                             //Displacement from the top
                                       width: contentView.frame.size.width - 90,         //Width is size of the cell
                                       height: contentView.frame.size.height)            //Height is half of that of the cell
        
        continueButton.frame =  CGRect(x: contentView.frame.size.width - 90,
                                       y: 0,
                                       width: 90,
                                       height: contentView.frame.size.height)
        
        switchToggle.frame =    CGRect(x: contentView.frame.size.width - 52,
                                       y: 9,
                                       width: 80,
                                       height: contentView.frame.size.height - 8)
        


        
    }

}
