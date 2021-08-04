//
//  HomePageCollectionCelll.swift
//  All Fit
//
//  Created by Lam Nguyen on 7/23/21.
//

import UIKit

class HomePageCollectionCelll: UICollectionViewCell {
    
    // MARK: asset initialization
    let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Poppins-Regular", size: 19)
        titleLabel.textColor = .darkGray
        
        return titleLabel
    }()
    
    let subtitleLabel: UILabel = {
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont(name: "Poppins-Thin", size: 10)
        subtitleLabel.textColor = .gray
        subtitleLabel.adjustsFontSizeToFitWidth = true
        subtitleLabel.minimumScaleFactor = 0.33
        
        return subtitleLabel
    }()
    
    // MARK: init function
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(subtitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: layout
    
    override func layoutSubviews() {
        titleLabel.frame = CGRect(x: 15,
                                  y: self.contentView.frame.width / 16,
                                  width: self.contentView.frame.width - 15,
                                  height: self.contentView.frame.height / 2)
        
        subtitleLabel.frame = CGRect(x: 15,
                                     y: self.contentView.frame.width / 2 - 18,
                                     width: self.contentView.frame.width - 30,
                                     height: self.contentView.frame.height / 4)
        
    }
}
