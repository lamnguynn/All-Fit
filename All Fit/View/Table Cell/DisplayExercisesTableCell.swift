//
//  DisplayExercisesTableCell.swift
//  AllFit
//
//  Created by Lam Nguyen on 1/11/21.
//

import UIKit

protocol DisplayExercisesCellDelegate: AnyObject {
    func delete(cell: DisplayExercisesTableCell)
}

class DisplayExercisesTableCell: UITableViewCell {
    @IBOutlet var backView: UIView!                     //Background view of the cell
    @IBOutlet var exerciseNameLabel: UILabel!           //Name of the exercise label
    @IBOutlet var needEquipmentLabel: UILabel!          //Need equipment label
    @IBOutlet var needEquipmentImage: UIImageView!      //Need quipment image (check or xmark)
    @IBOutlet var setsLabel: UILabel!
    @IBOutlet var unitsLabel: UILabel!
    @IBOutlet var setsAddButton: UIButton!
    @IBOutlet var setsSubtractButton: UIButton!
    @IBOutlet var unitsAddButton: UIButton!
    @IBOutlet var unitsubtractButton: UIButton!
    @IBOutlet var addToWorkoutButton: UIButton!
    @IBOutlet var trackerLabel: UILabel!
    @IBOutlet var exerciseDescriptionLabel: UILabel!
    @IBOutlet var notesTextField: UITextField!
    @IBOutlet var xmarkButton: UIButton!
    
    weak var delegate: DisplayExercisesCellDelegate?

    @IBAction func xmarkClicked(_ sender: Any){
        delegate?.delete(cell: self)
    }
    
    

}
