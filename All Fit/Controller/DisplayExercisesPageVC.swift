//
//  DisplayExercisesPage.swift
//  All Fit
//
//  Created by Lam Nguyen on 1/11/21.
//

import UIKit

var workoutList = [String: WorkoutItem]()               //Dictionary to hold data to present in the "View Workout" Page. I chose a dictionary to prevent duplicates

class DisplayExercisesPageVC: UIViewController {
     
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var table: UITableView!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var backView: UIView!
    @IBOutlet var addButton: UIButton!
    
    var exercisesToDisplay = [Exercise]()
    fileprivate var timesClicked: Int = 0               //Times the user clicks on the cell. Used to control the flipping of the card
    var titleText: String!                              //Text of the title label
    var sets: Int = 0                                   //Value for the number of sets
    var units: Float = 0                                //Value for the number of units
    var indexClicked: Int!                              //Value for the indexPath value clicked
    var searchForExercises = [String]()
    var searching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Change the heading and view background color
        view.backgroundColor = .white
        backView.backgroundColor = UIColor(red: 162/255 , green: 151/255, blue: 151/255, alpha: 0.9)
        backView.layer.cornerRadius = 70
        
        // Set up the title label
        titleLabel.text = titleText
        titleLabel.font = UIFont.boldSystemFont(ofSize: 45)
        
        // Set up the table
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.separatorStyle = .none
        
        // Set up the search bar
        searchBar.layer.cornerRadius = 14
        searchBar.backgroundImage = UIImage()            //Remove the border on search bar
        searchBar.tintColor = .black
        
        // Set up the add button
        addButton.layer.cornerRadius = 27.5
        addButton.alpha = 0.8
        addButton.backgroundColor = UIColor(red: 162/255 , green: 151/255, blue: 151/255, alpha: 0.9)
    }
    
    //Flip the cell back where user can see option to add sets/reps
    //Although isHidden and alpha are sort of are the same, I added both to allow for more fluidity
    func flipCellBack(_ cell: DisplayExercisesTableCell){
        //Show the back
        cell.setsAddButton.isHidden = false
        cell.setsSubtractButton.isHidden = false
        cell.setsLabel.isHidden = false
        cell.unitsLabel.isHidden = false
        cell.unitsAddButton.isHidden = false
        cell.unitsubtractButton.isHidden = false
        cell.addToWorkoutButton.isHidden = false
        cell.trackerLabel.isHidden = false
        cell.notesTextField.isHidden = false
        
        cell.setsAddButton.alpha = 1
        cell.setsSubtractButton.alpha = 1
        cell.setsLabel.alpha = 1
        cell.unitsLabel.alpha = 1
        cell.unitsAddButton.alpha = 1
        cell.unitsubtractButton.alpha = 1
        cell.addToWorkoutButton.alpha = 1
        cell.trackerLabel.alpha = 1
        cell.notesTextField.alpha = 1
        
        //Hide the front
        cell.exerciseNameLabel.isHidden = true
        cell.needEquipmentImage.isHidden = true
        cell.needEquipmentLabel.isHidden = true
        cell.exerciseDescriptionLabel.isHidden = true
        cell.notesTextField.isEnabled = true
        
        cell.exerciseNameLabel.alpha = 0
        cell.needEquipmentLabel.alpha = 0
        cell.needEquipmentImage.alpha = 0
        cell.exerciseDescriptionLabel.alpha = 0

        
    }
    
    //Flip the cell front where user can see exercise and desscription
    //Although isHidden and alpha are sort of are the same, I added both to allow for more fluidity
    func flipCellFront(_ cell: DisplayExercisesTableCell){
        
        //Show the front
        cell.exerciseNameLabel.isHidden = false
        cell.needEquipmentImage.isHidden = false
        cell.needEquipmentLabel.isHidden = false
        cell.exerciseDescriptionLabel.isHidden = false
        
        cell.exerciseNameLabel.alpha = 1
        cell.needEquipmentLabel.alpha = 1
        cell.needEquipmentImage.alpha = 1
        cell.exerciseDescriptionLabel.alpha = 1
        cell.notesTextField.alpha = 1
        
        //Hide the back
        cell.setsAddButton.isHidden = true
        cell.setsSubtractButton.isHidden = true
        cell.setsLabel.isHidden = true
        cell.unitsLabel.isHidden = true
        cell.unitsAddButton.isHidden = true
        cell.unitsubtractButton.isHidden = true
        cell.addToWorkoutButton.isHidden = true
        cell.trackerLabel.isHidden = true
        cell.notesTextField.isHidden = true
        
        cell.setsAddButton.alpha = 0
        cell.setsSubtractButton.alpha = 0
        cell.setsLabel.alpha = 0
        cell.unitsLabel.alpha = 0
        cell.unitsAddButton.alpha = 0
        cell.unitsubtractButton.alpha = 0
        cell.addToWorkoutButton.alpha = 0
        cell.trackerLabel.alpha = 0
        cell.notesTextField.resignFirstResponder()
    }
    
    
    // MARK: updating sets and units based on user clicking on the add/subtract buttons
    func getSelectedCell() -> DisplayExercisesTableCell{
        let newIndexPath = table.indexPathForSelectedRow
        let cell = table.cellForRow(at: newIndexPath!) as! DisplayExercisesTableCell
        
        //Change the text back to default. Useful for when user just added but wants to revise
        cell.addToWorkoutButton.setTitle("Add to workout", for: .normal)
        
        return cell
    }
    
    // Add sets
    @IBAction func setsAddClicked(){
        sets+=1
        let cell = getSelectedCell()
        cell.trackerLabel.text = "Sets: \(sets) | " + cell.unitsLabel.text! + " \(units)"
        
    }
    
    // Subtract sets. If statement to avoid displaying negative
    @IBAction func setsSubtractClicked(){
        if sets > 0{
            sets -= 1
        }
        
        let cell = getSelectedCell()
        cell.trackerLabel.text = "Sets: \(sets) | " + cell.unitsLabel.text! + " \(units)"
    }
    
    // Add units
    @IBAction func unitsAddClicked(){
        //Handing exception cases where the counter may want to increment by a non-one value
        let indexPath = table.indexPathForSelectedRow
        let cardio = ["Running", "Swimming", "Cycling"]
        let unit = exercisesToDisplay[indexPath!.row].unit.lowercased()
        
        if cardio.contains(exercisesToDisplay[indexPath!.row].name){           //Exception: Cardio exercises
            units += 0.1
        }
        else if unit == "seconds"  || unit == "second"{                        //Exception: Seconds Unit
            units += 5
        }
        else{
            units += 1
        }
        
        //Update the tracker label
        units =  (units * 100).rounded() / 100                                 //Round the value to avoid any weird possible values
        let cell = getSelectedCell()
        cell.trackerLabel.text = "Sets: \(sets) | " + cell.unitsLabel.text! + " \(units)"
    }
    
    // Subtract units. If statement to avoid displaying negative
    @IBAction func unitsSubtractClicked(){
        //Handing exception cases where the counter may want to decrement by a non-one value
        let indexPath = table.indexPathForSelectedRow
        let cardio = ["Running", "Swimming", "Cycling"]
        let unit = exercisesToDisplay[indexPath!.row].unit.lowercased()
        
        if (unit == "seconds" || unit == "second") && units > 0{                    //Exception: Seconds Unit
            units -= 5
        }
        else if cardio.contains(exercisesToDisplay[indexPath!.row].name){           //Exception: Cardio exercises
            units -= 0.1
        }
        else if units > 0{
            units -= 1
        }
        
        //Update the tracker label
        units =  (units * 100).rounded() / 100                                      //Round the value to avoid any weird possible values
        let cell = getSelectedCell()
        cell.trackerLabel.text = "Sets: \(sets) | " + cell.unitsLabel.text! + " \(units)"
    }
    
    // MARK: (ACTION) add more exercises
    // Prompt the user to fill in fields via an alert
    @IBAction func addMoreClicked(){
        let alert = UIAlertController(title: "New Exercise", message: "Fill in the fields to add an exercise", preferredStyle: .alert)
        
        //Add fields to the alert
        alert.addTextField { (nameField) in
            nameField.attributedPlaceholder = NSAttributedString(string: "Enter Name: " , attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            nameField.autocapitalizationType = .words
        }
        alert.addTextField { (descriptionField) in
            descriptionField.attributedPlaceholder = NSAttributedString(string: "Enter description (optional): ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            descriptionField.autocapitalizationType = .words
        }
        alert.addTextField { (unitField) in
            unitField.attributedPlaceholder = NSAttributedString(string: "Enter unit: (seconds, reps, etc)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            unitField.autocapitalizationType = .words
        }
        alert.addTextField { (needEquipmentField) in
            needEquipmentField.attributedPlaceholder = NSAttributedString(string: "Equipment needed: (Yes or No)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            needEquipmentField.autocapitalizationType = .words
        }
        
        //Add actions to the alert
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) {_ in
            
            //Each input has a variable to improve code readibility
            let userName = alert.textFields![0].text!                       //User input from Name text field
            let userDescription = alert.textFields![1].text!                //User input from Description text field
            let userUnit = alert.textFields![2].text!                       //User input from Unit text field
            let userNeedEquipment = alert.textFields![3].text!.lowercased() //User input from Need Equipment text field. lower cased to prevent errors like "yes"                                                                 or "Yes", and vice versa
            //If a field is left empty, prompt user to enter all fields
            if userName == "" || userUnit == "" || userNeedEquipment == ""{
                alert.message = "Please fill in ALL fields"
                self.present(alert, animated: true)
                return
            }
            //Convert's the user's answer to a bool value in order to create a new Exercises object
            let needEquipmentBool = (userNeedEquipment == "yes") ? true : false
            
            //Add the new entry to the appropriate array and reload
            let newExerciseObject = Exercise(name: userName, exerciseDescription: userDescription, unit: userUnit, needEquipment: needEquipmentBool)
            let newEntry = ExerciseItem(context: PersistenceService.context)
            newEntry.focusArea = self.titleText
            newEntry.name = userName
            newEntry.summary = userDescription
            newEntry.unit = userUnit
            newEntry.needEquipment = needEquipmentBool
            
            userCreatedExercisesData.append(newEntry)
            PersistenceService.saveContext()
            
            //PersistenceService.saveContext()
            self.exercisesToDisplay.append(newExerciseObject)
            
            //Update the table for user
            let indexPath = IndexPath(row: self.exercisesToDisplay.count - 1, section: 0)
            DispatchQueue.main.async {
                self.table.insertRows(at: [indexPath], with: .fade)
            }
        }
        //Combine all fields and actions, and present
        alert.addAction(cancelAction)
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: (ACTION) add to workout
    //Pass data to another view controller when clicked
    @IBAction func addToWorkoutClicked(){
        //Present an alert if sets and units are zero
        if sets == 0 || units == 0{
            let invalidError = UIAlertController(title: "Error", message: "Please add more reps/sets", preferredStyle: .alert)
            invalidError.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(invalidError, animated: true, completion: nil)
            return
        }
        
        
        let newIndexPath = table.indexPathForSelectedRow
        let cell = getSelectedCell()
        let exercise = exercisesToDisplay[newIndexPath!.row]
        let toAddItem = WorkoutItem(sets: sets, units: units, exercise: exercise, notes: cell.notesTextField.text!)
        
        workoutList[exercise.name] = toAddItem
        
        //Reset the values and the tracker
        sets = 0
        units = 0
        cell.trackerLabel.text = "Sets: \(sets) | " + cell.unitsLabel.text! + " \(units)"
        cell.exerciseNameLabel.text = exercisesToDisplay[newIndexPath!.row].name + " (Added)"
        cell.notesTextField.isEnabled = false
        
        //Flip the cell approproately as well
        if timesClicked % 2 == 1{
            UIView.animate(withDuration: 0.3, animations: {
                self.flipCellFront(cell)
            })
        }
        else{
            flipCellBack(cell)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindHome"{
            let xmarkButton = sender as! UIButton
            (segue as? cornerPopUp)?.circleOrigin = xmarkButton.center
            view.endEditing(true)                       //Hide keyboard if up
        }
    }
}

/* Plan:
    I decided to add a "flip card" feature for adding the exercise to circumvent an error in the code where if you do not click a cell, you will get a nil value from .indexPathForSelectedRow.
    Originally I wanted to expand the cell, but that did not work well.
 */
extension DisplayExercisesPageVC: UITableViewDelegate, UITableViewDataSource, DisplayExercisesCellDelegate, UITextFieldDelegate{
    // MARK: build the table
    // Return the number of cells/rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return searchForExercises.count
        }
        else{
            return exercisesToDisplay.count
        }
        
    }
    
    // Build the cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath) as! DisplayExercisesTableCell
        
        //If the user is searching, use the filtered array instead of the unfiltered array
        if searching{
            cell.exerciseNameLabel.text = searchForExercises[indexPath.row]
        }
        else{
            cell.exerciseNameLabel.text = exercisesToDisplay[indexPath.row].name
        }
        
        //Configure the cell
        /*
            //CHANGE 1: Change the color of the cell for any user created exercises.
            //CHANGE 2: Show the xmark if the exercise is a user created one. Hide if a stock exercise
            This control flow first checks if the focus area clicked on exist in the stock focus areas. If not, apply the correct two changes above. If so, the check to see if the exercise in the cell is a user created one. If so, apply the correct two changes above.
        */
        let stockFocusAreas = Array(stockFocusAreaData.keys)
        if !stockFocusAreas.contains(titleText){                                                  //User created exercise in user created focus area
            cell.backView.backgroundColor = applyRedColor()
            cell.xmarkButton.isHidden = false
        }
        else if indexPath.row > stockFocusAreaData[titleText]!.count - 1{                         //User created exercise in stock focus area
            cell.backView.backgroundColor = applyRedColor()
            cell.xmarkButton.isHidden = false
        }
        else{                                                                                     //Stock exercise in stock focus area
            cell.backView.backgroundColor = UIColor(red: 1, green: 104/255, blue: 104/255, alpha: 1)
            cell.xmarkButton.isHidden = true
        }
        
        cell.delegate = self
        cell.backgroundColor = .white
        cell.backView.layer.cornerRadius = 20                                                     //Changes
        cell.needEquipmentLabel.text = "Equipment Needed: "
        cell.unitsLabel.text = exercisesToDisplay[indexPath.row].unit + ":"
        cell.exerciseNameLabel.font = UIFont.boldSystemFont(ofSize: 25)
        cell.exerciseDescriptionLabel.text = exercisesToDisplay[indexPath.row].exerciseDescription
        cell.setsLabel.font = UIFont.boldSystemFont(ofSize: 25)
        cell.unitsLabel.font = UIFont.boldSystemFont(ofSize: 25)
        cell.needEquipmentImage.tintColor = .white
        cell.notesTextField.attributedPlaceholder = NSAttributedString(string: "Enter notes", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        cell.addToWorkoutButton.setTitleColor( UIColor(red: 216/255, green: 203/255, blue: 203/255, alpha: 1), for: .normal)
        cell.notesTextField.delegate = self
        
        //Have the cell face front when loaded up from memory
        flipCellFront(cell)
        
        //Apply customizations to the buttons
        cell.setsLabel.text = "Sets:"
        cell.trackerLabel.text = "Sets: \(sets) | " + cell.unitsLabel.text! + " \(units)"
        cell.setsAddButton.applyCustomization(text: "+", textColor: .white, backGroundColor: UIColor(red: 78/255, green: 179/255, blue: 1, alpha: 1))
        cell.setsSubtractButton.applyCustomization(text: "-", textColor: .white, backGroundColor: UIColor(red: 78/255, green: 179/255, blue: 1, alpha: 1))
        cell.unitsAddButton.applyCustomization(text: "+", textColor: .white, backGroundColor: UIColor(red: 78/255, green: 179/255, blue: 1, alpha: 1))
        cell.unitsubtractButton.applyCustomization(text: "-", textColor: .white, backGroundColor: UIColor(red: 78/255, green: 179/255, blue: 1, alpha: 1))
        
        
        
        //If an index of exerciseNeedsEquipment returns "false", then that means no equipment is needed and use the xmark image
        if exercisesToDisplay[indexPath.row].needEquipment == false{
            cell.needEquipmentImage.image = UIImage(systemName: "xmark.circle.fill")
        }
        else{
            cell.needEquipmentImage.image = UIImage(systemName: "checkmark.circle.fill")
        }
        
        return cell
    }
    
    //Dismiss keyboard when return is clicked on thhe notes text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    // Change the appearance of the cell when clicked by "flipping" it
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! DisplayExercisesTableCell
        timesClicked+=1
        
        UIView.animate(withDuration: 0.20) {
            if self.timesClicked % 2 == 1{
                self.flipCellBack(cell)
            }
            else{
                self.flipCellFront(cell)
            }
            
        }
    }
    
    
    // Return height of each cell/row
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 390
    }
    
    // MARK: add some animations to the cell
    // Add a slide in animation when cells are drawn in
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.selectionStyle = .none
        UIView.animate(withDuration: 0.45, delay: 0.2) {
            cell.alpha = 1
        }
    }
    
    //Scale down the cell when user clicks the cell
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let scaleDown = CGAffineTransform(scaleX: 0.95, y: 0.95)
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
    
    //MARK: delete the cell when xmark is clicked
    func delete(cell: DisplayExercisesTableCell) {
        //First check if we can get the indexPath. If so start the deleting process
        //Only delete any user created exercises. Stock exercises remove the same
        if let indexPath = self.table.indexPath(for: cell){
            if userCreatedExercisesData.count > 0{                                //Delete the data from data source
                let itemToDelete: ExerciseItem!
                if indexPath.row == 0 && self.exercisesToDisplay.count > 1{
                    itemToDelete = userCreatedExercisesData[0]
                    userCreatedExercisesData.remove(at: 0)
                }
                else{
                    itemToDelete = userCreatedExercisesData[indexPath.row - self.exercisesToDisplay.count + 1]
                    userCreatedExercisesData.remove(at: indexPath.row - self.exercisesToDisplay.count + 1)
                }
                PersistenceService.context.delete(itemToDelete)                  //Delete from core data stack
                PersistenceService.saveContext()
                self.exercisesToDisplay.remove(at: indexPath.row)
                table.deleteRows(at: [indexPath], with: .fade)                   //Delete from table view
            }
            //Present an alert if user tries to delete a stock exercise
            else{
                let cantDeleteStockAlert = UIAlertController(title: nil, message: "Can't delete a stock exercise!", preferredStyle: .alert)
                cantDeleteStockAlert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                
                self.present(cantDeleteStockAlert, animated: true, completion: nil)
            }
        }
        
    }
}

extension DisplayExercisesPageVC: UISearchBarDelegate {
    
    //React to the changes in text in searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var exerciseNames = [String]()
        for i in exercisesToDisplay{
            exerciseNames.append(i.name)
        }
        
        searchForExercises = exerciseNames.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        searching = true
        table.reloadData()
    }
    
    //MARK: Enable the search bar and dismiss keyboard
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        table.reloadData()
        view.endEditing(true)       //Dismiss keyboard
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
