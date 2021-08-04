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
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 30)]
        subtitleLabel.attributedText = NSAttributedString(string: "subtitle", attributes: attributes)
        
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
    
    // MARK: asset set up
    
    //Set up the title labels
    fileprivate func setupLabels(){
        self.subtitleLabel.textColor = .darkGray
        self.subtitleLabel.font = UIFont(name: "Poppins-Thin", size: 30)
        self.titleLabel.textColor = .white
        self.titleLabel.font = UIFont(name: "Poppins-SemiBold", size: 40)
        
        self.view.addSubview(titleLabel)
        self.view.addSubview(subtitleLabel)
        addLabelConstraints(titleLabel, topAnchor: self.view.topAnchor, topConstant: self.view.frame.height / 11.2)
        addLabelConstraints(subtitleLabel, topAnchor: self.titleLabel.bottomAnchor, topConstant: -2)
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
        table.register(UITableViewCell.self, forCellReuseIdentifier: "datacell")
        table.layer.cornerRadius = 30
        table.separatorStyle = .none
        table.backgroundColor = UIColor(red: 250/255, green: 249/255, blue: 229/255, alpha: 1)
        table.tableFooterView = UIView()
        
        self.view.addSubview(table)
        addTableConstraints()
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
        table.topAnchor.constraint(equalTo: collection.bottomAnchor, constant: 24).isActive = true
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
    
    // MARK: objc functions
    
    /*
        @settingsClicked
        Transitions to the settings
     */
    @objc func settingsClicked(){
        performSegue(withIdentifier: "showMore", sender: self)
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
        
    }
    
    /*
        @insetForSectionAt
        Returns an inset to set for the collection view
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 15)
    }
    
    /*
        @sizeForItemAt
        Returns a size for each item in collection view
     */
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 115, height: self.view.frame.height / 7.46 - 1) // OG: 65
    }
}

// MARK: table functions
extension HomePageV: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell", for: indexPath)
        cell.backgroundColor = UIColor(red: 250/255, green: 249/255, blue: 229/255, alpha: 1)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}
