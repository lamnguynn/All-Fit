//
//  DisplayWorkoutPageTableCell.swift
//  All Fit
//
//  Created by Lam Nguyen on 1/11/21.
//

import UIKit

protocol DisplayWorkoutCellDelegate: AnyObject {
    func delete(cell: DisplayWorkoutPageTableCell)
}

class DisplayWorkoutPageTableCell: UITableViewCell {

    @IBOutlet var backView: UIView!
    @IBOutlet var workoutItemNameLabel: UILabel!
    @IBOutlet var setsLabel: UILabel!
    @IBOutlet var notesLabel: UILabel!
    
    weak var delegate: DisplayWorkoutCellDelegate?
    
    @IBAction func xmarkClicked(_ sender: Any){
        delegate?.delete(cell: self)
    }

}
