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
            print("GOT THE SCORECARDS: \(scorecard.descrip!)")

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
    
    func getSpecialPutts(scorecard: ScorecardModel){
        let request = NSFetchRequest<PuttModel>(entityName: "PuttModel")
        let sort = NSSortDescriptor(keyPath: \PuttModel.num, ascending: true)
        let filter = NSPredicate(format: "hole.scorecard == %@", scorecard )
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
    
//    func updateMiss(putt: PuttModel, update: String){
//        if update == putt.miss{
//            putt.breaking = ""
//        } else {
//            putt.breaking = update
//        }
//        putts.removeAll()
//        manager.save()
//        getPutts()
//        
//    }
//    
    func updateScorecard(round: ScorecardModel, newInd: Int){
        
        round.currHole = Int16(newInd)
        scorecards.removeAll()
        manager.save()
        getScorecards()
    }
    
    func deleteScorecard(){
        let scorecard = scorecards[0]
        manager.context.delete(scorecard)
        save()
    }
    
    func deleteSpecScorecard(scorecard: ScorecardModel){
        
        manager.context.delete(scorecard)
        save()
        
        
    }
    
    
    
    
    
    
    // STATS GETTERS
    
    func totalScore(scorecard: ScorecardModel) -> Int16 {
        let filter = scorecard.holes?.allObjects as? [HoleModel]
        let sum =  filter!.reduce(0){$0 + $1.score}
        return sum
    }
    
    func totalPar(scorecard: ScorecardModel) -> Int16 {
        let filter = scorecard.holes?.allObjects as? [HoleModel]
        let par =  filter!.reduce(0){$0 + $1.par}
        return par
    }
    
    func totalPutts(scorecard: ScorecardModel) -> Int {
        let filter = scorecard.holes?.allObjects as? [HoleModel]
        let numPutts =  filter!.reduce(0){$0 + $1.putts!.count}
        return numPutts
    }
    
    func puttResults() -> [Int] {
        let missLeft = putts.reduce(0){$0 + ($1.miss ==  "Left" ? 1 : 0)}
        let missRight = putts.reduce(0){$0 + ($1.miss == "Right" ? 1 : 0)}
        return [missLeft, missRight]
    }
    
    func breakResults(loc: String) -> [Int] {
        let misses = putts.reduce(0){$0 + ($1.breaking == loc ? 1 : 0)}
        return [misses]
    }
    
    func breakMiss(loc: String) -> [Int] {
        let misses = putts.filter({$0.breaking == loc})
        let LCount = misses.reduce(0){$0 + ($1.miss == "Left" ? 1 : 0)}
        let RCount = misses.reduce(0){$0 + ($1.miss == "Right" ? 1 : 0)}
        return [LCount, RCount]
    }

    
    func faiwayHits(scorecard: ScorecardModel) -> [Int] {
        let filter = scorecard.holes?.allObjects as? [HoleModel]
        
        let left = filter!.reduce(0){$0 + ($1.fairwayHit ==  "L" ? 1 : 0)}
        let right = filter!.reduce(0){$0 + ($1.fairwayHit ==  "R" ? 1 : 0)}
        let hit = filter!.reduce(0){$0 + ($1.fairwayHit ==  "H" ? 1 : 0)}
        return [left, right, hit]
    }
    
    func greenHits(scorecard: ScorecardModel) -> [Int] {
        let filter = scorecard.holes?.allObjects as? [HoleModel]
        let miss = filter!.reduce(0){$0 + ($1.greenHit ==  "N" ? 1 : 0)}
        let hit = filter!.reduce(0){$0 + ($1.greenHit ==  "Y" ? 1 : 0)}
        return [miss, hit]
    }
    
    func upDownCount(scorecard: ScorecardModel) -> [Int] {
        let filter = scorecard.holes?.allObjects as? [HoleModel]
        let miss = filter!.reduce(0){$0 + ($1.upDown ==  "N" ? 1 : 0)}
        let hit = filter!.reduce(0){$0 + ($1.upDown ==  "Y" ? 1 : 0)}
        return [miss, hit]
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

