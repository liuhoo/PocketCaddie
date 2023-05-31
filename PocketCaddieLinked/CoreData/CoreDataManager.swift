//
//  CoreDataManager.swift
//  PocketCaddieLinked
//
//  Created by Alex Liu on 5/30/23.
//

import CoreData
import SwiftUI

class CoreDataManager{
    static let instance = CoreDataManager()
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init(){
        container = NSPersistentContainer(name: "ScorecardContainer")
        container.loadPersistentStores{(description, error) in
            if let error = error{
                print("ERROR LOADING CORE DATE. \(error)")
            }
        }
        context = container.viewContext
    }
    
    func save(){
        do {
            try context.save()
            print("SAVED SUCCESSFULLY")
        } catch let error {
            print("ERROR SAVING CORE DATA. \(error.localizedDescription)")
        }
        
    }
}

class CoreDataViewModel: ObservableObject {
    let manager = CoreDataManager.instance
    @Published var scorecards: [ScorecardModel] = []
    @Published var holes: [HoleModel] = []
    @Published var putts: [PuttModel] = []
    
    init(){
        getScorecards()
        getHoles()
        getPutts()
        
    }
    
    func getScorecards(){
        let request = NSFetchRequest<ScorecardModel>(entityName: "ScorecardModel")
        let sort = NSSortDescriptor(keyPath: \ScorecardModel.date, ascending: false)
        request.sortDescriptors = [sort]
        do{
            scorecards = try manager.context.fetch(request)
            print("GOT SCORECARD")
            
        } catch let error {
            print("ERROR FETCHING. \(error.localizedDescription)")
        }
    }
    
    func getSpecHoles(scorecard: ScorecardModel){
        let request = NSFetchRequest<HoleModel>(entityName: "HoleModel")
        let sort = NSSortDescriptor(keyPath: \HoleModel.holeNo, ascending: true)
        let filter = NSPredicate(format: "scorecard == %@", scorecard )
        request.sortDescriptors = [sort]
        request.predicate = filter
        do{
            holes = try manager.context.fetch(request)

        } catch let error {
            print("ERROR FETCHING. \(error.localizedDescription)")
        }
    }
    
    
    
    func getHoles(){
        let request = NSFetchRequest<HoleModel>(entityName: "HoleModel")
        let sort = NSSortDescriptor(keyPath: \HoleModel.holeNo, ascending: true)
        request.sortDescriptors = [sort]
        do{
            holes = try manager.context.fetch(request)
            
        } catch let error {
            print("ERROR FETCHING. \(error.localizedDescription)")
        }
    }
    func getPutts(){
        let request = NSFetchRequest<PuttModel>(entityName: "PuttModel")
        let sort = NSSortDescriptor(keyPath: \PuttModel.num, ascending: true)
        request.sortDescriptors = [sort]
        do{
            putts = try manager.context.fetch(request)
        } catch let error {
            print("ERROR FETCHING. \(error.localizedDescription)")
        }
    }
    
    func addScorecard(name: String, numHoles: Int16){
        let newScorecard = ScorecardModel(context: manager.context)
        newScorecard.currHole = 0
        newScorecard.detail = ""
        newScorecard.descrip = name
        newScorecard.totalScore = 10
        newScorecard.date = Date.now
        newScorecard.id = UUID()
        
        save()
        
        for i in 0..<numHoles {
            addHole(index: i, scorecard: newScorecard)
        }
        
        
            

    }
    
    func addHole(index: Int16, scorecard: ScorecardModel){
        
        let newHole = HoleModel(context: manager.context)
        
        newHole.holeNo = index
        
        newHole.scorecard = scorecard
        
        save()
    }
    
    func addPutt(){
        let newPutt = PuttModel(context: manager.context)
        newPutt.num = 1
        newPutt.hole = holes[0]
        save()
    }
    
    
    func deleteScorecard(){
        let scorecard = scorecards[0]
        manager.context.delete(scorecard)
        save()
    }
    
    func reload(){
        save()
    }
    func save(){
        
        scorecards.removeAll()
        holes.removeAll()
        putts.removeAll()
        manager.save()
        getScorecards()
        getHoles()
        getPutts()
        
    }
}

