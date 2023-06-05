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
    
    
    
    
    func getSpecPutts(hole: HoleModel){
        let request = NSFetchRequest<PuttModel>(entityName: "PuttModel")
        let sort = NSSortDescriptor(keyPath: \PuttModel.num, ascending: true)
        let filter = NSPredicate(format: "hole == %@", hole )
        request.sortDescriptors = [sort]
        request.predicate = filter
        do{
            putts = try manager.context.fetch(request)

        } catch let error {
            print("ERROR FETCHING. \(error.localizedDescription)")
        }
        
    }
    

    
    func addPutt(hole: HoleModel){
        let newPutt = PuttModel(context: manager.context)
        newPutt.num = Int16(hole.putts?.count ?? 0)
        hole.addToPutts(newPutt)
        putts.removeAll()
        manager.save()
        getSpecPutts(hole: hole)
        
    }
    
    func collectPutts(hole: HoleModel){
        putts.removeAll()
        manager.save()
        getSpecPutts(hole: hole)
    }
    
    
    
    
    
    
    
    
    func addScorecard(name: String, numHoles: Int16, advPutt: Bool){
        let newScorecard = ScorecardModel(context: manager.context)
        newScorecard.currHole = 0
        newScorecard.detail = ""
        newScorecard.descrip = name
        newScorecard.totalScore = 10
        newScorecard.date = Date.now
        newScorecard.id = UUID()
        newScorecard.advPutt = advPutt
        save()
        
        for i in 0..<numHoles {
            addHole(index: i, scorecard: newScorecard)
        }
    }
    
    func addHole(index: Int16, scorecard: ScorecardModel){
        
        let newHole = HoleModel(context: manager.context)
        
        newHole.holeNo = index
        newHole.score = 0
        newHole.scorecard = scorecard
        
        save()
    }
    
    
    
    func incrementScore(scorecard: ScorecardModel, index: Int){
        let filter = scorecard.holes?.allObjects as? [HoleModel]
        
        let item = filter!.first(where:{$0.holeNo == index})!
        item.score = item.score + 1
        holes.removeAll()
        manager.save()
        getSpecHoles(scorecard: scorecard)
            
    }
    
    func decrementScore(scorecard: ScorecardModel, index: Int){
        let filter = scorecard.holes?.allObjects as? [HoleModel]
        
        let item = filter!.first(where:{$0.holeNo == index})!
        item.score = item.score - 1
        holes.removeAll()
        manager.save()
        getSpecHoles(scorecard: scorecard)
            
    }
    
    func updateHoleNum(scorecard: ScorecardModel, index: Int){
        scorecard.currHole = Int16(index)
        putts.removeAll()
        manager.save()
        getSpecPutts(hole: holes[index])
    }
    
    
    func incrementPar(scorecard: ScorecardModel, index: Int){
        let filter = scorecard.holes?.allObjects as? [HoleModel]
        
        let item = filter!.first(where:{$0.holeNo == index})!
        item.par = item.par + 1
        holes.removeAll()
        manager.save()
        getSpecHoles(scorecard: scorecard)
            
    }
    
    func decrementPar(scorecard: ScorecardModel, index: Int){
        let filter = scorecard.holes?.allObjects as? [HoleModel]

        let item = filter!.first(where:{$0.holeNo == index})!
        item.par = item.par - 1
        
        holes.removeAll()
        manager.save()
        getSpecHoles(scorecard: scorecard)
            
    }
    
    func updateFairway(hole: HoleModel, update: String){
        if update == hole.fairwayHit{
            hole.fairwayHit = ""
        } else {
            hole.fairwayHit = update
        }
        
        putts.removeAll()
        manager.save()
        getSpecPutts(hole: hole)
    }
    
    func updateGreenHit(hole: HoleModel, update: String){
        if update == hole.greenHit{
            hole.greenHit = ""
        } else {
            hole.greenHit = update
        }
        
        putts.removeAll()
        manager.save()
        getSpecPutts(hole: hole)
    }
    
    func updateUpDown(hole: HoleModel, update: String){
        if update == hole.upDown{
            hole.upDown = ""
        } else {
            hole.upDown = update
        }
        putts.removeAll()
        manager.save()
        getSpecPutts(hole: hole)
    }
    
    
    func updatePuttBreak(putt: PuttModel, update: String){
        if update == putt.breaking{
            putt.breaking = ""
        } else {
            putt.breaking = update
        }
        scorecards.removeAll()
        manager.save()
        getScorecards()
    }
    
    
    
    func updatePuttMiss(putt: PuttModel, update: String){
        if update == putt.miss{
            putt.miss = ""
        } else {
            putt.miss = update
        }
        scorecards.removeAll()
        manager.save()
        getScorecards()
    }
    
    func updateMiss(putt: PuttModel, update: String){
        if update == putt.miss{
            putt.breaking = ""
        } else {
            putt.breaking = update
        }
        putts.removeAll()
        manager.save()
        getPutts()
        
    }
    
    func updateScorecard(index: Int, newInd: Int){
        let existingScorecard = scorecards[index]
        existingScorecard.currHole = Int16(newInd)
        scorecards.removeAll()
        manager.save()
        getScorecards()
    }
    
    func deleteScorecard(){
        let scorecard = scorecards[0]
        manager.context.delete(scorecard)
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

