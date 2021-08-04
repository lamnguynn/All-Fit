//
//  HomePageCollectionUserDefinedCell.swift
//  All Fit
//
//  Created by Lam Nguyen on 1/14/21.
//

import UIKit

protocol HomePageCellDelegate: AnyObject{
    func delete(cell: HomePageCollectionUserDefinedCell)
}

class HomePageCollectionUserDefinedCell: UICollectionViewCell {
    @IBOutlet var xmarkButton: UIButton!
    @IBOutlet var exerciseNameLabel: UILabel!
    @IBOutlet var backView: UIView!
    @IBOutlet var subtitleLabel: UILabel!
    
    weak var delegate: HomePageCellDelegate?
    
    //When xmark button is clciked, present an alert asking if they want to delete the focus area cell
    @IBAction func xmarkClicked(_ sender: Any){
        delegate?.delete(cell: self)
    }
}
