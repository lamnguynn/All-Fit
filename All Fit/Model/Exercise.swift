
//
//  Exercise.swift
//  All Fit
//
//  Created by Lam Nguyen on 1/11/21.
//

import Foundation

class Exercise{

    
    
    var name: String!                   //Name of exercise
    var exerciseDescription: String!    //Description of exercise
    var unit: String!                   //Units of the exercise (reps, miles, seconds)
    var needEquipment: Bool!            //Whether the exercise needs equipment

    init(name: String, exerciseDescription: String, unit: String, needEquipment: Bool){
        self.name = name
        self.exerciseDescription = exerciseDescription
        self.unit = unit
        self.needEquipment = needEquipment
    }
    
    convenience init(){
        self.init(name: "", exerciseDescription: "", unit: "", needEquipment: false)
    }
    

    
    


    

}
