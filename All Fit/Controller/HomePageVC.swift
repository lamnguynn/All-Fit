//
//  ViewController.swift
//  AllFit
//
//  Created by Lam Nguyen on 1/12/21.
//
/*
   ADDITIONAL: I could have loaded the exercise data from a database or JSON API, but whatever way I chose I would have to type all the info. Doing this would reduce the amount of code and hurdles needed to get the app running.
   ADDITIONAL: I could have also could have adopted a child view controller to display more exercises, but I chose this option for right now...
*/
/*
   PLAN:
    - To be able to access, pass, and store data, I used what I call a HandShake method, where when the collection view cell is clicked, it matches the focus area clicked to the appropriate exercises in the form of a NSManagedObject, and passes it to the next scene to display.
    - I also separated the focus area and exercises into their own arrays to ease coding; I used an array instead of something like a dictionary
    - Use stack views to support in animations
 */
/*
   CONCEPTS:
    - Core Data.
    - Table/Collection View Cell
    - Pass data by segue.
    - Animations
    - Delegate/Protocol
 */

import UIKit
import CoreData


// MARK: colors
//Returns a powder blue color
internal func applyPowderBlueColor() -> UIColor{
    return UIColor(red: 203/255, green: 234/255, blue: 242/255, alpha: 1)
}

//Returns a red color
internal func applyRedColor() -> UIColor{
    return UIColor(red: 1, green: 96/255, blue: 93/255, alpha: 1)
}

//Returns a powder red color
internal func applyPowderRedColor() -> UIColor{
    return UIColor(red: 162/255 , green: 151/255, blue: 151/255, alpha: 1)
}

//Returns a off grey color
internal func applyOffGreyColor() -> UIColor{
    return UIColor(red: 233/255, green: 224/255, blue: 224/255, alpha: 1)
}

//Return a tan color
internal func applyTanColor() -> UIColor{
    return UIColor(red: 246/255, green: 205/255, blue: 150/255, alpha: 1)
}

//Returns a purple color
internal func applyPurpleColor() -> UIColor{
    return UIColor(red: 204/255, green: 204/255, blue: 1, alpha: 1)
}

//
internal func applyGreenColor() -> UIColor{
    return UIColor(red: 194/255, green: 246/255, blue: 168/255, alpha: 1)
}

// MARK: exercise data
//Instance of the Exercise class to store chest exercises
fileprivate var chestExercise: [Exercise] = [Exercise(name: "Flatbed Dumbbell Press", exerciseDescription: "This exercise aims to strengthens your chest muscles. To avoid injury and get the most benefits, maintain tension in your abs and refrain from having your back arch excessively. Avoid bumping the weights together at the top.", unit: "Reps", needEquipment: true),
                                 Exercise(name: "Push-Ups", exerciseDescription: "A classic workout that can be done anywhere to strengthen your triceps and chest. To get the most benefits, keep your body straight and elbow at 45 degrees to your body. Slowly descend and ascend. Repeat and maintain that form.", unit: "Reps", needEquipment: false),
                                 Exercise(name: "Incline Dumbbell Press", exerciseDescription: "Similar to the other dumbbell presses, this workout aims to strengthen your chest muscles. To get the most benefit, when raising the weights, keep tension in your abs as much as possible and avoid bumping the weights once you reach the top.", unit: "Reps", needEquipment: true),
                                 Exercise(name: "Barbell Bench Press", exerciseDescription: "This exercise aims to strengthen your chest muscles and arms. To get most benefits, firstly try to position your grip at an appropriate width and keep the bar in line with your wrist. Doing so avoids injury and is considered good form. As you start the workout, make sure you pick an appropriate weight and when lowering the bar, try to lower it in a linear way to avoid imbalances.", unit: "Reps", needEquipment: true),
                                 Exercise(name: "Decline Bench Press", exerciseDescription: "This exercise aims to strengthen your chest muscles. To get the most benefit, when raising the weights, keep tension in your abs as much as possible and avoid bumping the weights once you reach the top.", unit: "Reps", needEquipment: true),
                                 Exercise(name: "Cable Cross-Over", exerciseDescription: "This exercise aims to strengthens your chest. Setting the pulleys to the highest position will work on your lower pecs, while the lowest position will work on your upper pec. To get the most benefit, grab the handles and take a step backwards. Pull the weights down to your chest, and walk forward and stagger your feet. Try not to lean forward too much.", unit: "Reps", needEquipment: true)]

//Instance of the Exercise class to store cardio exercises
fileprivate var cardioExercise: [Exercise] = [Exercise(name: "Running", exerciseDescription: "This classic exercise is used to improve cardiovascular health and burn calories. To get the most performance, avoid eating two hours or more before your run and stretch plenty beforehand. Keep an appropriate pace to your distance planned. For example, you should not be running at a quicker pace if you plan to train for a long distance.", unit: "Miles", needEquipment: false),
                                              Exercise(name: "Swimming", exerciseDescription: "This exercise aims to strengthen muscles throughout the body, and burn calories. Some tips are to do three strokes and come up to get oxygen and be sure to do plenty of stretches beforehand.", unit: "Miles", needEquipment: false),
                                              Exercise(name: "Cycling", exerciseDescription: "This exercise aims to strengthen your leg muscles and burn calories. Be sure to position your saddle at a higher height (to hip) to reduce strain on your knee. Also be sure to keep your shoulders low and arms semi-extended.", unit: "Miles", needEquipment: true),
                                              Exercise(name: "Jump Ropes", exerciseDescription: "While simple, this exercise aims to strengthen a majority of your body such as your legs and back. To get the most benefit, keep your back straight and keep a pace that is appropriate for you. Best to do in an open environment to avoid hitting something unintentionally.", unit: "Seconds", needEquipment: true),
                                              Exercise(name: "Jumping Jacks", exerciseDescription: "This exercise aims to strengthen your cardiovascular system. To get the most benefit, raise your hands above your head, keeping your elbow straight", unit: "Seconds", needEquipment: false)]

//Instance of the Exercise class to store legs exercises
fileprivate var legExercise: [Exercise] = [Exercise(name: "Barbell Squat (High or Low)", exerciseDescription: "This exercise aims to strengthen the glute, quadriceps, and calves. For the most benefits, be sure to wear flat shoes as it provides stability. As you squat, be sure to keep your chest and chin up as they help avoid unhelpful movements in your spine that will cause stress.", unit: "Reps", needEquipment: true),
                                           Exercise(name: "Leg Extensions", exerciseDescription: "This exercise aims to strengthen your quadriceps. To get the most benefit, use the appropriate weight, and do not go fast as it will use momentum more than muscle strength.", unit: "Reps", needEquipment: true),
                                           Exercise(name: "Dumbbell Lunge", exerciseDescription: "This exercise aims to strengthen your quadriceps for balance and mobility. To get the most benefit and correct form, avoid letting your knee track farther than your toes. Doing this can place stress on your knees.", unit: "Reps", needEquipment: true),
                                           Exercise(name: "Calve Raises", exerciseDescription: "Whether you are using a dumbbell or a machine, this exercise aims to strengthen your calves for stablity. To get the most benefit, slowly raise your body using your calves and hold it at the top for a few seconds.", unit: "Reps", needEquipment: true),
                                           Exercise(name: "Single Leg Deadlift", exerciseDescription: "This exercise aims to strengthen the same areas as its two-legged namesake does, but with less stress on your back. To get the most benefit, shift your weight to the standing leg, and keep it straight. You can add a dumbbell or kettlebell for an extra challenge", unit: "Reps", needEquipment: false),
                                           Exercise(name: "Walking Lunge", exerciseDescription: "This exercise aims to strengthen your calves, quadriceps, core, and range of motion. Since this exercise is about mobility, keep your core engaged and body upright throughout to provide balance. Add dumbbells for an extra challenge.", unit: "Reps", needEquipment: false)]

//Instance of the Exercise class to store ab exercises
fileprivate var abExercise: [Exercise] = [Exercise(name: "Plank", exerciseDescription: "This exercise aims to strengthen your core and abs. To get the most benefits, keep your back straight and look at the floor to avoid stress on your spine.", unit: "Seconds", needEquipment: false),
                                          Exercise(name: "Crunches", exerciseDescription: "This exercise aims to strengthen your obliques and core. To get the most benefits, raise your body slowly using your core instead of your neck or head to avoid injury.", unit: "Reps", needEquipment: false),
                                          Exercise(name: "Medicine Ball Russian Twist", exerciseDescription: "This exercise aims to strengthen your obliques, quads, and lower abs. To get the most benefits, select a medicine ball of appropriate weight and keep your back straight throughout the workout.", unit: "Reps", needEquipment: true),
                                          Exercise(name: "Russian Twist", exerciseDescription: "This exercise aims to strengthen your obliques, quads, and lower abs. To get the most benefits, keep your back straight throughout the workout.", unit: "Reps" ,needEquipment: false),
                                          Exercise(name: "Leg Raises", exerciseDescription: "This exercise aims to strengthen your lower abs. To get the most benefit, as you raise your legs, you should be keeping them straight and pressing your thighs together. For extra challenge, use a medicine ball and apply the same tips.", unit: "Reps", needEquipment: false),
                                          Exercise(name: "Sit-Ups", exerciseDescription: "Similar to crunches, this exercise aims to strengthen your core and abs. To get the most benefits, avoid putting your hands behind your head as this can lead to excess strain on your neck.", unit: "Reps", needEquipment: false)]

//Instance of the Exercise class to store tricep exercises
fileprivate var tricepExercise: [Exercise] = [Exercise(name: "Tricep Cable Pushdown", exerciseDescription: "This exercise aims to strengthen your entire tricep muscle, and core. To get the most benefits, choose an approproiate weight and position your elbows inwards. As you pull down, engage your core and move down slowly.", unit: "Reps", needEquipment: true),
                                            Exercise(name: "Overhead Cable Tricep Extension", exerciseDescription: "This exercise aims to strengthen your tricep muscles. To get the most benefit, choose an appropriate weight to where you can maintain a stable balance as your feet will be staggered. Keep your elbows tucked in to get the most muscle engagement.", unit: "Reps", needEquipment: true),
                                            Exercise(name: "Tricep Dips", exerciseDescription: "This exercise aims to strengthen your tricep muscle. To get the most benefit and avoid injury, keep your grip/fingers very close to your body and as you descend, keep your core tight and do not flare out your elbows. Doing so avoids stress on your shoulder joints.", unit: "Reps", needEquipment: true),
                                            Exercise(name: "Seated Overhead Dumbbell Extension", exerciseDescription: "This exercise aims to strengthen your tricep muscles. To get the most benefit, keep your elbows close to your head as it will put more emphasis on your triceps. Additionally, it is best if you tilt your body forward a tiny bit to avoid accidental dropping of the weight.", unit: "Reps", needEquipment: true),
                                            Exercise(name: "Close Grip Bench Press", exerciseDescription: "This exercise aims to strengthen your tricep and chest muscles. To get the most benefits, firstly lay down on the bench straight. Then raise your hand up straight, and the width between your hands will be your grip width while holding the bar. Doing this over a closer grip avoids your shoulders from rotating. Keep your elbow close as comfortably as possible to your body.", unit: "Reps", needEquipment: true),
                                            Exercise(name: "Push-Ups", exerciseDescription: "This exercise aims to strengthen your tricep and chest muscles. To get the most benefits, keep your elbow tucked in closely to your body, and try to go up and down slowly. ", unit: "Reps", needEquipment: false)]

//Instance of the Exercise class to store bicep exercises
fileprivate var bicepExercise: [Exercise] = [Exercise(name: "Barbell Curl", exerciseDescription: "This exercise aims to strengthen your bicep muscles. To get the most benefit, curl the weight up slowly while trying to keep your elbows inwards.", unit: "Reps", needEquipment: true),
                                            Exercise(name: "Cable Hammer Curl", exerciseDescription: "This exercise aims to strengthen your bicep muscles. To get the most benefit, stand up straight and keep your elbows to the side as much as possible, then curl to the top and squeeze. Slowly lower the weight down and repeat.", unit: "Reps", needEquipment: true),
                                            Exercise(name: "EZ-Bar Curl", exerciseDescription: "This exercise aims to strengthen your bicep muscle. To get the most benefit, keep your head up high, chest upright, and elbows tucked in at all times. It may tempting to avoid these tips when fatigue, but following them will reduce spine stress and maintains a high muscle engagment.", unit: "Repd", needEquipment: true),
                                            Exercise(name: "Reverse-Grip Bent-Over Row", exerciseDescription: "This exercise aims to strengthen your bicep and back conjuctively. To get the most benefits, undergrip the barbell a shoulders width away. Row the weight to your stomach, making sure your back is straight. ", unit: "Reps", needEquipment: true),
                                            Exercise(name: "Dumbbell Curl", exerciseDescription: "This exercise aims to strengthen your biceps. To get the most benefit, keep the reps slow and controlled. It is ok if you have to lighten the weight. Additionally, do not swing your body as you curl up.", unit: "Reps", needEquipment: true),
                                            Exercise(name: "Pull-Ups", exerciseDescription: "This exercise aims to strengthen your biceps. To get the most benefit, your movement up and down should be straight, and done slowly, especially lowering. ", unit: "Reps", needEquipment: true)]

//Instance of the Exercise class to store back exercises
fileprivate var backExerice: [Exercise] = [Exercise(name: "Lat Pulldown", exerciseDescription: "This exercise aims to strengthen the back muscle and shoulders. To get the most benefits, you want to puff your chest up and lean your body back to about 70 degrees to get more activation from your lats.", unit: "Reps", needEquipment: true),
                                            Exercise(name: "Bent-Over Barbell Row", exerciseDescription: "This exercise aims to strengthen your back muscles and tricep conjuctively. To get the most benefits and avoid injury, choose an appropriate weight to ensure you keep your back straight. You should be pulling your elbows behind you rather than the bar up, and hold when at the top to build your back further.", unit: "Reps", needEquipment: true),
                                            Exercise(name: "Dumbbell Rows", exerciseDescription: "This exercise aims to strengthen your back and biceps. To get the most benefits, you want to keep your body close to parallel to the ground, then row to your abs, and squeeze your shoulder blades when the weight is at the top.", unit: "Reps", needEquipment: true),
                                            Exercise(name: "Seated Cable Rows", exerciseDescription: "This exercise aims to strengthen your back and arm muscles. To get the most benefits, you want to have your back straight the entire process to engage your muscles, and pull the handle to your stomach, not your chest. You also want to return the weight slowly and keep your elbows close to your body.", unit: "Reps", needEquipment: true),
                                            Exercise(name: "V-bar Pulldown", exerciseDescription: "This exercise aims to strengthen your back muscle. To get the most benefit, you want to puff up your chest and keep your elbows close to your body as well.", unit: "Reps", needEquipment: true),
                                            Exercise(name: "Pull-Ups", exerciseDescription: "This exercise aims to strengthen your grip and back muscles. To get the most benefits, your movement up and down should be straight, and done slowly, especially lowering.", unit: "Reps", needEquipment: true)]


var stockFocusAreaData: [String: [Exercise]] = ["Chest": chestExercise, "Back": backExerice, "Tricep": tricepExercise, "Bicep": bicepExercise, "Abs": abExercise, "Cardio": cardioExercise, "Legs": legExercise]        //Stores the stock focus areas and exercises.

var userCreatedFocusAreasData = [ExerciseFocusArea]()                        //Stores any user-added focus areas. Incorporates Core Data
var userCreatedExercisesData = [ExerciseItem]()                              //Stores any user-added exercises. Incorporates Core Data

// MARK: class functions and properties
class HomePageVC: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var titleView: UIView!
    
    @IBOutlet var plusButton: UIButton!
    @IBOutlet var notesButton: UIButton!
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var viewWorkoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set a gradient for the home screen
        titleView.alpha = 0
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = [applyRedColor().cgColor, UIColor.white.cgColor]
        gradient.locations = [0,1]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 0, y: 1)
        gradient.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.layer.insertSublayer(gradient, at: 0)
        
        
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
        
        //Configure the labels
        titleLabel.text = "Welcome to All Fit"
        subtitleLabel.text = "Scroll to see more focus areas"
        
        //Configure the collection
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor(red: 178/255, green: 166/255, blue: 166/255, alpha: 0)
        
        //Configure the buttons
        plusButton.tintColor = .darkGray
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Store the keys and values into a 1D Array
        
        //Segue to display the exercises
        if segue.identifier == "showExercises"{
            if let nextPage = segue.destination as? DisplayExercisesPageVC{
                // Get the indexPath to be able to access which cell is clicked
                let newIndexPath = collectionView.indexPathsForSelectedItems            //IndexPath to use as reference
                let index = newIndexPath!.last![1]                                      //Numberical value for the IndexPath
                let keys = Array(stockFocusAreaData.keys)
                let values = Array(stockFocusAreaData.values)
                nextPage.indexClicked = index
                
                //Have the segue circle start at the bottom left if button is on the left side, and vice versa.
                let x = UIScreen.main.bounds.width
                let y = UIScreen.main.bounds.height
                (segue as! cornerPopUp).circleOrigin =  index % 2 == 0 ? CGPoint(x: 0, y: y) : CGPoint(x: x, y: y)
                
                // Initialize the title label and the table's data in the next page
                nextPage.titleText = keys[index]
        
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
        
        //Segue to display the exercises
        else if segue.identifier == "showExerciseFromUser"{
            if let nextPage = segue.destination as? DisplayExercisesPageVC{
                // Get the indexPath to be able to access which cell is clicked
                let newIndexPath = collectionView.indexPathsForSelectedItems
                let index = newIndexPath!.last![1]
                nextPage.indexClicked = index
                
                //Have the segue circle start at the bottom left if button is on the left side, and vice versa.
                let x = UIScreen.main.bounds.width
                let y = UIScreen.main.bounds.height
                (segue as! cornerPopUp).circleOrigin =  index % 2 == 0 ? CGPoint(x: 0, y: y) : CGPoint(x: x, y: y)
                
                // Initialize the title label and pass info to table's data in the next page
                let focusAreaToDisplay = userCreatedFocusAreasData[index - 7].name
                nextPage.titleText = focusAreaToDisplay
                for i in userCreatedExercisesData{
                    if i.focusArea == focusAreaToDisplay{
                        nextPage.exercisesToDisplay.append(Exercise(name: i.name!, exerciseDescription: i.summary!, unit: i.unit!, needEquipment: i.needEquipment))
                    }
                }
                
            }
        }
         
        
        // Segue to show the more info page. Set the center of the circle animated segue to the button's center
        else if segue.identifier == "showMore"{
            let morebutton = sender as! UIButton
            (segue as! cornerPopUp).circleOrigin = morebutton.center
        }
        
        // Segue to show the workout. Set the center of the circle animated segue to the button's center
        else if segue.identifier == "showWorkout"{
            let workoutButton = sender as! UIButton
            (segue as! cornerPopUp).circleOrigin = workoutButton.center
        }
        
        // Segue to show the notes. Set the center of the circle animated segue to the button's center
        else if segue.identifier == "showNotes"{
            let noteButton = sender as! UIButton
            (segue as! cornerPopUp).circleOrigin = noteButton.center
        }
        
        else if segue.identifier == "showCalendarPlanner"{
            (segue as! cornerPopUp).circleOrigin = CGPoint(x: 128, y: 613)
        }
        
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue ){
        
    }
    
    //When add button is clicked, present an alert with text fields
    @IBAction func addClicked(){
        let addAlert = UIAlertController(title: "Add Focus Area", message: "Fill in fields to add more focus areas", preferredStyle: .alert)
        
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
                self.collectionView.insertItems(at: [indexPath])
            }
            
        }
        
        //Add actions to alert and present
        addAlert.addAction(cancelAction)
        addAlert.addAction(saveAction)
        present(addAlert, animated: true, completion: nil)
    }
    
}


// MARK: collection view set up
extension HomePageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    //HELPER FUNCTION: get all the focus areas created by the user
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
    
    // Build the cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row < 7{
            let keys = Array(stockFocusAreaData.keys)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "focusAreaCell", for: indexPath) as! HomePageCollectionCell
            
            //Configure the cell
            if indexPath.row == 0{
                cell.backView.backgroundColor = UIColor(red: 250/255, green: 216/255, blue: 171/255, alpha: 1)
            }
            else if indexPath.row == 1 || indexPath.row == 2{
                cell.backView.backgroundColor = UIColor(red: 255/255, green: 243/255, blue: 229/255, alpha: 1)
            }
            else if indexPath.row == 3 || indexPath.row == 4{
                cell.backView.backgroundColor = UIColor(red: 250/255, green: 249/255, blue: 229/255, alpha: 1)
            }
            else{
                cell.backView.backgroundColor = UIColor(red: 250/255, green: 247/255, blue: 242/255, alpha: 1)
            }
            
            cell.exerciseNameLabel.text = keys[indexPath.row]
            cell.exerciseNameLabel.textColor = .darkGray
            cell.backView.layer.cornerRadius = 25
            cell.applyShadow()

        
            //Only show the text for the first cell
            if indexPath.row < 1{
                cell.subtitleLabel.text = "Click to see more"
                cell.subtitleLabel.textColor = .black
            }
            else{
                cell.subtitleLabel.text = ""
            }

            return cell
        }
        else{
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "userFocusAreaCell", for: indexPath) as! HomePageCollectionUserDefinedCell

            cell2.delegate = self
            
            //Configure the cell
            let focusArea = userCreatedFocusAreasData[indexPath.row - 7]                                            //Focus Area to reference
            cell2.exerciseNameLabel.text = focusArea.name
            cell2.exerciseNameLabel.textColor = .darkGray
            cell2.backView.layer.cornerRadius = 25
            cell2.backView.backgroundColor = .white
            cell2.subtitleLabel.isHidden = true
            cell2.applyShadow()
            return cell2

        }

    }
    
    // Return the number of cells/rows
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userCreatedFocusAreasData.count + stockFocusAreaData.count
    }

    // Set the bounds of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Apply a dynamic width and height
        if indexPath.row == 0{
            let width = UIScreen.main.bounds.width - 25
            return CGSize(width: width, height: width / 1.84)
        }
        else if indexPath.row == 1 || indexPath.row == 2 {
            let width = UIScreen.main.bounds.width
            return CGSize(width: width / 2 - 14, height: width / 2.3)
        }
        else if indexPath.row == 3{
            let width = UIScreen.main.bounds.width / 1.60
            return CGSize(width: width, height: UIScreen.main.bounds.width / 3.28)
        }
        else{
            let width = UIScreen.main.bounds.width / 3.28
            return CGSize(width: width, height: width)
        }
    }
    
    //Spacing vertically
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    //Spacing horizontally
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    // MARK: add some animations to the cell
    //Apply a slide in animation when cell is being drawn in
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 600, y: 600)
        UIView.animate(withDuration: 0.49, delay: 0.05, animations: {
            cell.alpha = 1
            cell.transform = .identity
        })
    }
    
    //Animation to make the cell scale down when click to "mimic" a real button
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            cell?.transform = .identity
        }
    }
    
    //Spring animation down when cell is highlighted
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            //cell?.transform = .identity
        }
    }
    
    //Spring animation up when cell is unhighlighted
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 0.8, delay: 0.1, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.5, options: .curveEaseIn) {
            cell?.transform = .identity
        }
    }
    
    
}

// MARK: delegate to delete cell and data
extension HomePageVC: HomePageCellDelegate{
    
    //Conform to protocol of deleting
    func delete(cell: HomePageCollectionUserDefinedCell) {
        let warningAlert = UIAlertController(title: "Warning!", message: "Are you sure you want to delete?", preferredStyle: .alert)
        
        //Create actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteAction = UIAlertAction(title: "Yes", style: .destructive) { _ in
            if let indexPath = self.collectionView?.indexPath(for: cell){
                //Delete from data source
                let itemToDelete = userCreatedFocusAreasData[indexPath.row - 7]
                
                userCreatedFocusAreasData.remove(at: indexPath.row - 7)
                //Delete the cell
                self.collectionView.deleteItems(at: [indexPath])
                
                //Delete from core data
                PersistenceService.context.delete(itemToDelete)
                PersistenceService.saveContext()

            }
        }
        
        //Add actions and present
        warningAlert.addAction(cancelAction)
        warningAlert.addAction(deleteAction)
        present(warningAlert, animated: true, completion: nil)
    }
}

// MARK: shadow function
//Add a shadow to UICollectionViewCell
extension UICollectionViewCell{
    func applyShadow(){
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.22
        self.layer.shadowOffset = CGSize(width: 1, height: 3)
        self.layer.masksToBounds = false
        
    }
}

//Add a shadow to UIView
extension UIView{
    func applyShadowToView(){
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 20
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.masksToBounds = true
    }
}
