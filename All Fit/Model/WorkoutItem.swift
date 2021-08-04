//
//  WorkoutItem.swift
//  All Fit
//
//  Created by Lam Nguyen on 1/11/21.
//

import Foundation

class WorkoutItem{
    var sets: Int!                      //Number of sets
    var units: Float!                   //Number of repitions to do
    var notes: String!                  //Notes from user
    var exercise: Exercise!             //Exercise added
    
    init(sets: Int, units: Float, exercise: Exercise, notes: String){
        self.sets = sets
        self.units = units
        self.exercise = exercise
        self.notes = notes
    }

}
