//
//  HomePageTableCell.swift
//  All Fit
//
//  Created by Lam Nguyen on 8/8/21.
//

import UIKit

class HomePageTableCell: UITableViewCell {

    // MARK: asset setup
    
    let exerciseLabel: UILabel = {
        let exerciseLabel = UILabel()
        exerciseLabel.font = UIFont(name: "Poppins-SemiBold", size: 19)
        exerciseLabel.textColor = .gray
        exerciseLabel.adjustsFontSizeToFitWidth = true
        exerciseLabel.minimumScaleFactor = 0.6
        
        return exerciseLabel
    }()
    
    let setsLabel: UILabel = {
        let setsLabel = UILabel()
        setsLabel.font = UIFont(name: "Poppins-Thin", size: 13)
        setsLabel.textColor = .gray
        
        return setsLabel
    }()
    
    let notesLabel: UILabel = {
        let notesLabel = UILabel()
        notesLabel.font = UIFont(name: "Poppins-Thin", size: 12)
        notesLabel.textColor = .gray
        notesLabel.numberOfLines = 0
        notesLabel.adjustsFontSizeToFitWidth = true
        notesLabel.minimumScaleFactor = 0.33
        
        return notesLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(exerciseLabel)
        contentView.addSubview(setsLabel)
        contentView.addSubview(notesLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        
        exerciseLabel.frame = CGRect(x: 18, y: 8, width: self.contentView.frame.width, height: self.contentView.frame.height / 3)
        
        setsLabel.frame = CGRect(x: 18, y: self.contentView.frame.height / 3 + 6, width: self.contentView.frame.width, height: self.contentView.frame.height / 3)
        
        notesLabel.frame = CGRect(x: 18, y: (2 * self.contentView.frame.height / 3) - 2, width: self.contentView.frame.width, height: self.contentView.frame.height / 3)
    }

}
