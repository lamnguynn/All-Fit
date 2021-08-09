//
//  HomePageV.swift
//  All Fit
//
//  Created by Lam Nguyen on 7/16/21.
//

import UIKit
import CoreData

class HomePageV: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    // MARK: asset initialization
    
    var collection: UICollectionView!
    var table: UITableView = UITableView()
    lazy var dumbbellImage = UIImageView(image: UIImage(named: "dumbbell(1)"))
    lazy var dumbbellLabel = UILabel()
    
    var settingsButton: UIButton = {                                                                //Settings Button
        let settingsButton = UIButton()
        settingsButton.setImage(UIImage(systemName: "gear"), for: .normal)
        
        return settingsButton
    }()
    
    var addButton: UIButton = {
        let addButton = UIButton()
        addButton.setImage(UIImage(systemName: "plus"), for: .normal)
        
        return addButton
    }()
    
    var notesButton: UIButton = {
        let notesButton = UIButton()
        notesButton.setImage(UIImage(systemName: "square.and.pencil"), for: .normal)
        
        return notesButton
    }()
    
    var titleLabel: UILabel = {                                                                     //Title label
        let titleLabel = UILabel()
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 40)]
        titleLabel.attributedText = NSAttributedString(string: "Welcome,", attributes: attributes)
        
        return titleLabel
    }()
    
    var subtitleLabel: UILabel = {                                                                  //Subtitle label
        let subtitleLabel = UILabel()
        subtitleLabel.font = UIFont(name: "Poppins-Thin", size: 14)
        subtitleLabel.font = UIFont.systemFont(ofSize: 15)
        subtitleLabel.text = "Click on any focus area to get started!"
        
        return subtitleLabel
    }()
    
    // MARK: view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Load the saved data in
        let fetchFocusAreaRequest: NSFetchRequest<ExerciseFocusArea> = ExerciseFocusArea.fetchRequest()
        let fetchExerciseRequest:NSFetchRequest<ExerciseItem> = ExerciseItem.fetchRequest()
        do{
            let fetchedFocusAreaData = try PersistenceService.context.fetch(fetchFocusAreaRequest)
            let fetchedExerciseData = try PersistenceService.context.fetch(fetchExerciseRequest)
            userCreatedFocusAreasData = fetchedFocusAreaData
            userCreatedExercisesData = fetchedExerciseData
        }
        catch{
            print("ERROR: Could not load saved data")
        }
        
        //Set a gradient for the home screen
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [applyRedColor().cgColor, UIColor.white.cgColor]
        gradient.locations = [0,1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1.25)
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height  )
        self.view.layer.insertSublayer(gradient, at: 0)
        
        //Set up the title and subtitle label
        setupLabels()
        
        //Set up the collection
        setupCollection()
        
        //Set up the table
        setupTable()
        
        //Set up the settings button
        setupSettingButton()
        
        //Set up the notes button
        setupNotesButton()
        
        //Set up the add button
        setupAddButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(workoutList.isEmpty){
            dumbbellImage.isHidden = false
            dumbbellImage.isHidden = false
        }
        else{
            dumbbellImage.isHidden = true
            dumbbellImage.isHidden = true
        }
    }
    
    // MARK: asset set up
    
    //Set up the title labels
    fileprivate func setupLabels(){
        self.subtitleLabel.textColor = .darkGray
        //self.subtitleLabel.font = UIFont(name: "Poppins-Thin", size: 14)
        self.titleLabel.textColor = .white
        self.titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 40)
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitleLabel)
        addLabelConstraints(titleLabel, topAnchor: self.view.topAnchor, topConstant: self.view.frame.height / 11.2)
        addLabelConstraints(subtitleLabel, topAnchor: self.titleLabel.bottomAnchor, topConstant: -5)
    }
    
    //Set up the setting button
    fileprivate func setupSettingButton(){
        settingsButton.imageView?.tintColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        settingsButton.backgroundColor = .clear
        settingsButton.addTarget(self, action: #selector(settingsClicked), for: .touchUpInside)
        settingsButton.contentHorizontalAlignment = .fill
        settingsButton.contentVerticalAlignment = .fill
        settingsButton.imageEdgeInsets = UIEdgeInsets(top: 11, left: 11, bottom: 11, right: 11)
        
        self.view.addSubview(settingsButton)
        addButtonConstraints(settingsButton)
    }
    
    //Set up the notes button
    fileprivate func setupNotesButton(){
        notesButton.backgroundColor = .gray
        notesButton.imageView?.tintColor = .white
        notesButton.layer.cornerRadius = 27
        notesButton.addTarget(self, action: #selector(notesClicked), for: .touchUpInside)
        
        self.view.addSubview(notesButton)
        addLowerButtonConstraints(notesButton)
        notesButton.bottomAnchor.constraint(equalTo: self.table.bottomAnchor, constant: -(self.view.frame.height / 22.4)).isActive = true
    }
    
    //Set up the add button
    fileprivate func setupAddButton(){
        addButton.backgroundColor = .gray
        addButton.imageView?.tintColor = .white
        addButton.layer.cornerRadius = 27
        addButton.addTarget(self, action: #selector(addClicked), for: .touchUpInside)
        
        self.view.addSubview(addButton)
        addLowerButtonConstraints(addButton)
        addButton.bottomAnchor.constraint(equalTo: self.notesButton.topAnchor, constant: -5).isActive = true
    }
    
    //Set up the collection
    fileprivate func setupCollection(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collection.delegate = self
        collection.dataSource = self
        collection.register(HomePageCollectionCelll.self, forCellWithReuseIdentifier: "datacell")
        collection.showsHorizontalScrollIndicator = false
        
        self.view.addSubview(collection)
        
        addCollectionConstraints()
    }
    
    //Set up the table
    fileprivate func setupTable(){
        table.delegate = self
        table.dataSource = self
        table.register(HomePageTableCell.self, forCellReuseIdentifier: "datacell")
        table.layer.cornerRadius = 30
        table.separatorStyle = .none
        table.backgroundColor = UIColor(red: 250/255, green: 249/255, blue: 229/255, alpha: 1)
        table.tableFooterView = UIView()
        table.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        /*
        table.layer.shadowColor = UIColor.lightGray.cgColor
        table.layer.shadowRadius = 6
        table.layer.shadowOpacity = 0.8
        table.layer.shadowOffset = CGSize(width: 0, height: 3)
        table.layer.shadowPath = .none
         */
        
        self.view.addSubview(table)
        addTableConstraints()
        
        if(workoutList.isEmpty){
            //Add a dumbbell image
            dumbbellImage.alpha = 0.25
            dumbbellImage.transform = CGAffineTransform(rotationAngle: -210)
            table.addSubview(dumbbellImage)
            
            dumbbellImage.translatesAutoresizingMaskIntoConstraints = false
            dumbbellImage.centerXAnchor.constraint(equalTo: table.centerXAnchor).isActive = true
            dumbbellImage.centerYAnchor.constraint(equalTo: table.centerYAnchor, constant: -90).isActive = true
            
            dumbbellLabel.text = "Nothing yet..."
            dumbbellLabel.textColor = .lightGray
            dumbbellLabel.alpha = 0.7
            table.addSubview(dumbbellLabel)
            
            dumbbellLabel.translatesAutoresizingMaskIntoConstraints = false
            dumbbellLabel.topAnchor.constraint(equalTo: dumbbellImage.bottomAnchor, constant: -60).isActive = true
            dumbbellLabel.centerXAnchor.constraint(equalTo: table.centerXAnchor).isActive = true
        }
    }
    
    // MARK: asset constraints
    
    /*
        @addLowerButtonConstraints
        Adds constraints to the lower buttons
     */
    func addLowerButtonConstraints(_ button: UIButton){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        button.widthAnchor.constraint(equalToConstant: 54).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -25).isActive = true
    }
    
    /*
        @addButtonConstraints
        Adds constraints to a button
        -- button: button to apply constraints to
     */
    func addButtonConstraints(_ button: UIButton){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: self.view.topAnchor, constant: self.view.frame.height / 11.2 + (self.view.frame.height / 179.2)).isActive = true
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.widthAnchor.constraint(equalToConstant: 50).isActive = true
        button.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10).isActive = true
    }
    
    /*
        @addTableConstraints
        Adds constraints to table
     */
    func addTableConstraints(){
        table.translatesAutoresizingMaskIntoConstraints = false
        table.topAnchor.constraint(equalTo: collection.bottomAnchor, constant: 10).isActive = true
        table.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15).isActive = true
        table.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15).isActive = true
        table.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -(self.view.frame.height / 22.4)).isActive = true
    }
    
    /*
        @addCollectionConstraints
        Adds constraints to the collection view
     */
    func addCollectionConstraints(){
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.backgroundColor = .clear
        collection.topAnchor.constraint(equalTo: self.subtitleLabel.bottomAnchor, constant: 10).isActive = true
        collection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collection.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collection.heightAnchor.constraint(equalToConstant: self.view.frame.height / 7.46).isActive = true
    }
    
    /*
        @addLabelConstraints
        Adds constraints to a table
        -- label: label to apply constraints to
        -- tA: top anchor of the label
        -- tC: top anchor constant of the label
     */
    func addLabelConstraints(_ label: UILabel, topAnchor tA: NSLayoutYAxisAnchor,topConstant tC: CGFloat = 0){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: tA, constant: tC).isActive = true
        label.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true
    }
    
    // MARK: segue function
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showNotes"{
            (segue as! cornerPopUp).circleOrigin = notesButton.center
        }
        else if segue.identifier == "showStockExercises"{                       //Pass data for any stock focus areas / exercises
            if let nextPage = segue.destination as? DisplayExercisesPageVC{
                
                //Set up the passing of data
                let keys = Array(stockFocusAreaData.keys)
                let values = Array(stockFocusAreaData.values)
                let newIndexPath = collection.indexPathsForSelectedItems                    //IndexPath to use as reference
                let index = newIndexPath!.last![1]                                          //Numberical value for the IndexPath clicked
                nextPage.indexClicked = index
                nextPage.homeTable = table
                nextPage.dumbbellImage = dumbbellImage
                nextPage.dumbbellLabel = dumbbellLabel
                
                //Set the start coordinates of the segue animation
                (segue as! cornerPopUp).circleOrigin =  collection.center
                
                // Initialize the title label and the table's data in the next page
                nextPage.titleText = keys[index]
                
                //Pass the appropriate exercise data
                for exercise in values[index]{                                          //Load the data from the stock focus area
                    nextPage.exercisesToDisplay.append(exercise)
                }
                
                for i in userCreatedExercisesData{                                      //Load the data from the user created focus area
                    if i.focusArea == keys[index]{
                        nextPage.exercisesToDisplay.append(Exercise(name: i.name!, exerciseDescription: i.summary!, unit: i.unit!, needEquipment: i.needEquipment))
                    }
                }
            }
            
            
        }
        else if segue.identifier == "showUserExercises"{                        //Pass data for any user generated focus areas / exercises
            if let nextPage = segue.destination as? DisplayExercisesPageVC{
                // Get the indexPath to be able to access which cell is clicked
                let newIndexPath = collection.indexPathsForSelectedItems
                let index = newIndexPath!.last![1]
                nextPage.indexClicked = index
                nextPage.homeTable = table
                nextPage.dumbbellImage = dumbbellImage
                nextPage.dumbbellLabel = dumbbellLabel
                
                //Set the start coordinates of the segue animation
                (segue as! cornerPopUp).circleOrigin =  collection.center
                
                // Initialize the title label and pass info to table's data in the next page
                let focusAreaToDisplay = userCreatedFocusAreasData[index - 7].name
                nextPage.titleText = focusAreaToDisplay
                
                //Pass the appropriate exercise data
                for i in userCreatedExercisesData{
                    if i.focusArea == focusAreaToDisplay{
                        nextPage.exercisesToDisplay.append(Exercise(name: i.name!, exerciseDescription: i.summary!, unit: i.unit!, needEquipment: i.needEquipment))
                    }
                }
            }
        }
    }
    
    // MARK: objc functions
    
    /*
        @settingsClicked
        Transitions to the settings
     */
    @objc func settingsClicked(){
        let vc = SettingsPageVC()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false, completion: nil)
    }
    
    /*
        @notesClicked
        Transition to the notes
     */
    @objc func notesClicked(){
        performSegue(withIdentifier: "showNotes", sender: self)
    }
    
    /*
        @addClicked
        Present an alert 
     */
    @objc func addClicked(){
        let addAlert = UIAlertController(title: "Add Focus Area", message: "Fill in the field to add a new focus area", preferredStyle: .alert)
        
        //Create actions
        addAlert.addTextField { (nameField) in                                                      //Text Field Action
            nameField.attributedPlaceholder = NSAttributedString(string: "Enter name: ", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            nameField.autocapitalizationType = .words
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)             //Cancel Action
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in                       //Save Action
            let nameInput = addAlert.textFields![0].text!                                           //Name of the new entry
            if nameInput == ""{                          //If nothing is added to the text, present the alert again
                self.present(addAlert, animated: true, completion: nil)
                return
            }
            
            //Excpetion handling: If the focus area already exist, then present an alert.
            let allFocusAreas = self.getUserCreatedFocusAreas()
            if allFocusAreas.contains(nameInput){
                let existAlreadyAlert = UIAlertController(title: "Error", message: "\(nameInput) already exist!", preferredStyle: .alert)
                existAlreadyAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(existAlreadyAlert, animated: true, completion: nil)
                return
            }
            
            //Create a new entry from user input
            let dummyEntry = ExerciseFocusArea(context: PersistenceService.context)
            dummyEntry.name = nameInput
            
            userCreatedFocusAreasData.append(dummyEntry)
            PersistenceService.saveContext()
            
            //Reload the table to show new field
            let indexPath = IndexPath(item: userCreatedFocusAreasData.count + stockFocusAreaData.count - 1, section: 0)
            DispatchQueue.main.async {
                self.collection.insertItems(at: [indexPath])
            }
            
        }
        
        //Add actions to alert and present
        addAlert.addAction(cancelAction)
        addAlert.addAction(saveAction)
        present(addAlert, animated: true, completion: nil)
    }
    
    @IBAction func unwindBackHome(_ segue: UIStoryboardSegue ){}
    
    // MARK: helper functions
    
    /*
        @getUserCreatedFocusAreas
        Get all the focus areas created by the user
     */
    func getUserCreatedFocusAreas() -> [String]{
        var focusAreas = [String]()
        if userCreatedFocusAreasData.count - 1 < 0 {     //Exception catching
            return [""]
        }
        
        for i in 0...userCreatedFocusAreasData.count - 1{
            focusAreas.append(userCreatedFocusAreasData[i].name!)
        }
        return focusAreas
    }
}

// MARK: collection functions
extension HomePageV: UICollectionViewDelegateFlowLayout{
    
    /*
        @numberOfItemsInSection
        Returns the number of cells
     */
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userCreatedFocusAreasData.count + stockFocusAreaData.count
    }
    
    /*
        @cellForItemAt
        Returns a cell
     */
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "datacell", for: indexPath) as! HomePageCollectionCelll
        cell.layer.cornerRadius = 20
        cell.backgroundColor = UIColor(red: 250/255, green: 216/255, blue: 171/255, alpha: 1)
        cell.applyShadow()
        cell.subtitleLabel.isHidden = true
        
        if indexPath.row == 0{
            cell.subtitleLabel.isHidden = false
            cell.subtitleLabel.text = "Click to see more"
        }
        
        //Customize the cells contents
        if indexPath.row < 7{
            let keys = Array(stockFocusAreaData.keys)
            cell.titleLabel.text = keys[indexPath.row]
        }
        else{
            let focusArea = userCreatedFocusAreasData[indexPath.row - 7]
            cell.titleLabel.text = focusArea.name
        }
        
        return cell
    }
    
    /*
        @didSelectItemAt
        Shows all the workouts when a cell is clicked
     */
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row < 7{
            performSegue(withIdentifier: "showStockExercises", sender: self)
        }
        else{
            performSegue(withIdentifier: "showUserExercises", sender: self)
        }
    }
    
    /*
        @insetForSectionAt
        Returns an inset to set for the collection view
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 15)
    }
    
    /*
        @sizeForItemAt
        Returns a size for each item in collection view
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 115, height: self.view.frame.height / 7.46 - 11) // OG: 65
    }
    
    /*
        @contextMenuConfigurationForItemAt
        Return a menu with actions on a long hold
     */
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration{
        if indexPath.row < 7{ return UIContextMenuConfiguration() }
        
        let contextMenu = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash")){ [weak self] action in
                
                //Prompt an alert to delete
                let warningAlert = UIAlertController(title: "Warning!", message: "Are you sure you want to delete?", preferredStyle: .alert)
                
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)     //Cancel action
                let deleteAction = UIAlertAction(title: "Confirm", style: .destructive) { _ in      //Delete action
                    //Delete from data source
                    let itemToDelete = userCreatedFocusAreasData[indexPath.row - 7]
                    
                    userCreatedFocusAreasData.remove(at: indexPath.row - 7)
                    
                    //Delete the cell
                    self?.collection.deleteItems(at: [indexPath])
                    
                    //Delete from core data
                    PersistenceService.context.delete(itemToDelete)
                    PersistenceService.saveContext()
                }
                
                warningAlert.addAction(deleteAction)
                warningAlert.addAction(cancelAction)
                self?.present(warningAlert, animated: true, completion: nil)
                
            }
            
            return UIMenu(title: "", children: [delete])
        }
        
        return contextMenu
    }
    
    
}

// MARK: table functions
extension HomePageV: UITableViewDelegate, UITableViewDataSource{
    
    /*
        @cellForRowAt
        Builds a cell
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath) as! HomePageTableCell
        cell.backgroundColor = UIColor(red: 250/255, green: 249/255, blue: 229/255, alpha: 1)
        cell.selectionStyle = .none
        
        //Configure the cell
        let workoutListKeys = Array(workoutList.keys)
        let workoutListValues = Array(workoutList.values)
        
        if(!workoutList.isEmpty){
            let sets = workoutListValues[indexPath.row].sets
            let reps = workoutListValues[indexPath.row].units
            let units = workoutListValues[indexPath.row].exercise.unit
            
            cell.exerciseLabel.text = workoutListKeys[indexPath.row]
            cell.setsLabel.text = "Sets: \(sets!) | Reps: \(reps!) " + units!
            cell.notesLabel.text = "Notes: " + workoutListValues[indexPath.row].notes
        }
        return cell
    }
    
    /*
        @trailingSwipeActionsConfigurationForRowAt
        Delete the exercise from the workout on swipe
     */
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let workoutListKeys = Array(workoutList.keys)
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { action, view, completion in
            //Delete from model
            workoutList.removeValue(forKey: workoutListKeys[indexPath.row])
            
            //Delete from view
            self.table.deleteRows(at: [indexPath], with: .fade)
            
            //Update dumbbell image
            DispatchQueue.main.async {
                if workoutList.isEmpty{
                    self.dumbbellImage.isHidden = false;
                    self.dumbbellLabel.isHidden = false;
                }
            }
            
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction])
        return swipeConfig
    }
    
    /*
        @numberOfRowsInSection
        Returns the number of cells in the table
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workoutList.count
    }
    
    /*
        @heightForRowAt
        Returns a value for the height of a cell
     */
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    /*
        @didSelectRowAt
        Deselects the cell when clicked
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
