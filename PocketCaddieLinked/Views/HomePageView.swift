//
//  HomePageView.swift
//  PocketCaddieLinked
//
//  Created by Alex Liu on 5/30/23.
//

import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    var body: some View {
        
        
        
        ScrollView{
            VStack(spacing: 20){
                Button(action: {
                    vm.addScorecard()
                    vm.save()
                }, label:{
                    Text("Add scorecard").foregroundColor(.white).frame(height: 55).frame(maxWidth: .infinity).background(Color.blue.cornerRadius(10))
                })
                Button(action: {
                    
                    vm.addHole()
                    vm.save()
                    
                }, label:{
                    Text("Add Hole").foregroundColor(.white).frame(height: 55).frame(maxWidth: .infinity).background(Color.blue.cornerRadius(10))
                })
                
                Button(action: {
                    vm.addPutt()
                    vm.save()
                }, label:{
                    Text("Add Putt").foregroundColor(.white).frame(height: 55).frame(maxWidth: .infinity).background(Color.blue.cornerRadius(10))
                })
                Button(action: {
                    vm.deleteScorecard()
                }, label:{
                    Text("DELETE").foregroundColor(.white).frame(height: 55).frame(maxWidth: .infinity).background(Color.blue.cornerRadius(10))
                })
                
                
                
                ScrollView(.horizontal, showsIndicators: true, content:{
                    HStack(alignment: .top){
                        ForEach(vm.scorecards){ hi in
                            ScorecardView(entity: hi)
                            
                        }
                    }
                })
                
                ScrollView(.horizontal, showsIndicators: true, content:{
                    HStack(alignment: .top){
                        ForEach(vm.holes){ hole in
                            HoleView(entity: hole)
                            
                        }
                    }
                })
                ScrollView(.horizontal, showsIndicators: true, content:{
                    HStack(alignment: .top){
                        ForEach(vm.putts){ putt in
                            PuttView(entity: putt)
                            
                        }
                    }
                })
            }.padding()
        }.navigationTitle("TEST")
        
        
        
        
    }
    
}


struct ScorecardView: View{
    let entity: ScorecardModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            Text("Name: \(entity.descrip ?? "ERROR")")
            
            if let holes = entity.holes?.allObjects as? [HoleModel]{
                Text("Holes: ").bold()
                ForEach(holes) { hole in
                    Text(hole.upDown ?? "")
                    
                }
            }
            
        }).padding().frame(maxWidth: 300, alignment: .leading).background(Color.gray.opacity(0.5)).cornerRadius(10).shadow(radius: 10)
    }
}


struct HoleView: View{
    let entity: HoleModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            Text("Name: \(entity.upDown ?? "ERROR")")
            
            Text("Hole \(entity.scorecard?.descrip ?? "ERROR")")
            if let putts = entity.putts?.allObjects as? [PuttModel]{
                Text("Putts: ").bold()
                ForEach(putts) { putt in
                    Text(String(putt.num))
                    
                }
            }
            
        }).padding().frame(maxWidth: 300, alignment: .leading).background(Color.gray.opacity(0.5)).cornerRadius(10).shadow(radius: 10)
    }
}

struct PuttView: View{
    let entity: PuttModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            Text("Name: \(String(entity.num))")
            
            Text("Hole \(entity.hole?.upDown ?? "ERROR")")
                
            
        }).padding().frame(maxWidth: 300, alignment: .leading).background(Color.gray.opacity(0.5)).cornerRadius(10).shadow(radius: 10)
    }
}



