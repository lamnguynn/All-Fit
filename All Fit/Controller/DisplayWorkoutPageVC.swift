//
//  DIsplayWorkoutPageVC.swift
//  All Fit
//
//  Created by Lam Nguyen on 1/11/21.
//

import UIKit

final class DisplayWorkoutPageVC: UIViewController, DisplayWorkoutCellDelegate {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var table: UITableView!
    @IBOutlet var backView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        backView.backgroundColor = applyPowderRedColor()
        backView.layer.cornerRadius = 70
        
        //Set up title label
        titleLabel.text = "Today's Workout"
        
        //Set up table
        table.separatorStyle = .none
        table.delegate = self
        table.dataSource = self
        table.layer.cornerRadius = 20
        table.backgroundColor = .white
        
        //Set up the background view
    }
    
    func delete(cell: DisplayWorkoutPageTableCell) {
        let workoutListKeys = Array(workoutList.keys)
        if let indexPath = table.indexPath(for: cell){
            workoutList.removeValue(forKey: workoutListKeys[indexPath.row])
            table.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindHome"{
            let xmarkButton = sender as! UIButton
            (segue as! cornerPopUp).circleOrigin = xmarkButton.center
        }
    }
    

}

extension DisplayWorkoutPageVC: UITableViewDelegate, UITableViewDataSource{
    // MARK: build the table
    // Return the number of rows/cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutList.count
    }
    
    // Build the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath) as! DisplayWorkoutPageTableCell
        
        //Configure the cell
        let workoutListKeys = Array(workoutList.keys)
        let workoutListValues = Array(workoutList.values)
        
        cell.workoutItemNameLabel.text = workoutListKeys[indexPath.row]
        cell.workoutItemNameLabel.font = UIFont.boldSystemFont(ofSize: 19)
        
        cell.setsLabel.text = String(workoutListValues[indexPath.row].sets) + " x " + String(workoutListValues[indexPath.row].units) + " " + (workoutListValues[indexPath.row].exercise.unit)
        cell.notesLabel.text = "Notes: " + workoutListValues[indexPath.row].notes
        cell.delegate = self
        
        cell.backView.layer.cornerRadius = 15
        cell.backView.backgroundColor = UIColor(red: 1, green: 104/255, blue: 104/255, alpha: 1)
        cell.backgroundColor = .white
        
        
        return cell
    }
    
    // MARK: add some animations to the cell
    // Add a pop in animation when cells are drawn in
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.selectionStyle = .none
        UIView.animate(withDuration: 0.45) {
            cell.alpha = 1
        }
    }
    
    //Scale down the cell when user clicks the cell
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let scaleDown = CGAffineTransform(scaleX: 0.93, y: 0.93)
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.05, delay: 0.02) {
            cell?.transform = scaleDown
        }
    }
    
    //Scale up the cell when user lets go of cell
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let scaleUp = CGAffineTransform(scaleX: 1, y: 1)
        let cell = tableView.cellForRow(at: indexPath)
        UIView.animate(withDuration: 0.05, delay: 0.02) {
            cell?.transform = scaleUp
        }
    }
    
}
