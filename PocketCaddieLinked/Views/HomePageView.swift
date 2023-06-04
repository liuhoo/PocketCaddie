//
//  HomePageView.swift
//  PocketCaddieLinked
//
//  Created by Alex Liu on 5/30/23.
//

import SwiftUI

struct HomePageView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    @EnvironmentObject var appState: AppState
    var body: some View {
        VStack {
            NavigationLink(value:"intermediateView"){
                NewRoundView()
            }
            NavigationLink(value:"statisticView"){
                StatisticView()
            }
            
            ScrollView{
                VStack(spacing: 20){
                    
//                    Button(action: {
//                        vm.addScorecard(name: "TEST", numHoles: 5, advPutt: true)
//                        vm.save()
//                    }, label:{
//                        Text("Add scorecard").foregroundColor(.white).frame(height: 55).frame(maxWidth: .infinity).background(Color.blue.cornerRadius(10))
//                    })
//
//                    Button(action: {
//                        vm.save()
//                    }, label:{
//                        Text("Add Hole").foregroundColor(.white).frame(height: 55).frame(maxWidth: .infinity).background(Color.blue.cornerRadius(10))
//                    })
//
//                    Button(action: {
//
//                        vm.save()
//                    }, label:{
//                        Text("Add Putt").foregroundColor(.white).frame(height: 55).frame(maxWidth: .infinity).background(Color.blue.cornerRadius(10))
//                    })
                    
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
            }
        }.navigationDestination(for: String.self){ viewItem in
            selectView(item: viewItem)
            
        }.navigationTitle("Pocket Caddie")
        
        
    }

    func selectView(item: String) ->  AnyView{
        switch item{
        case "intermediateView":
            return AnyView(intermediateView())
        case "statisticView":
            return AnyView(RoundCollectionView())
        default:
            return AnyView(Text("Error"))
        }
    }
}
struct RoundCollectionView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    
    var body: some View {
        List(){
            ForEach(vm.scorecards){ round in
                NavigationLink {
                    Text("\(round.date ?? Date())")
                } label: {
                    Text("\(round.descrip ?? "no name given")")
                }.navigationTitle("Completed Rounds")
            }
        }
    }
}
    

struct intermediateView:  View{
    
    @EnvironmentObject var vm: CoreDataViewModel
    @State private var id = ""
    @State private var desc = ""
    @State private var advancedPutting = false
    @State private var speed = 9.0
    @State private var isEditing = false
    
    
    var body: some View {
        
        
        VStack {
            
            Form {
                Section(header: Text("General"), footer: Text("Round name needs to be unique.")) {
                    TextField(text: $id, prompt: Text("Unique Round Name")) {
                        Text("Round Name")
                    }.autocorrectionDisabled(true).disableAutocorrection(true)
                    TextField(text: $desc, prompt: Text("Description")) {
                        Text("Description")
                    }.autocorrectionDisabled(true).disableAutocorrection(true)
                }
                Section(header: Text("Round Options")){
                    Toggle("Advanced Putting Stats", isOn: $advancedPutting)
                }
                
                Section(header: Text("User Profiles")) {
                    Text(String(format: "Number of Holes: %.0f", speed))
                        .foregroundColor(isEditing ? .red : .blue)
                    Slider(
                        value: $speed,
                        in: 1...18,
                        step: 1,
                        onEditingChanged: { editing in
                            isEditing = editing
                        }
                    )
                }
                
                Section(){
                    Button("Clear Current Inputs") {
                        desc = ""
                        id = ""
                        advancedPutting = false
                    }
                }
            }
            
                        NavigationLink(destination: CollectDataView()){BeginRoundView()}.navigationTitle("New Round").simultaneousGesture(TapGesture().onEnded{
                            vm.addScorecard(name: id, numHoles: Int16(speed), advPutt: advancedPutting)
                            vm.getSpecHoles(scorecard: vm.scorecards[0])
                            vm.collectPutts(hole: vm.holes[0])
                        })
            
        }
        
        
    }
}

struct StatisticView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20).strokeBorder(lineWidth: 3).opacity(0.2)
            Text("Statistics")
                .font(.largeTitle)
        }
        .padding(.horizontal)
    }
}

struct NewRoundView: View {
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 20).strokeBorder(lineWidth: 3).opacity(0.2)
            Text("New Round")
                .font(.largeTitle)
        }
        .padding(.horizontal)
        //                Button(action: {}, label: {Text("Begin Round (Goodluck!)").font(.headline).frame(height:55).background(Color.accentColor).cornerRadius(10)})
        
    }
}

struct ScorecardView: View{
    let entity: ScorecardModel
    @EnvironmentObject var vm: CoreDataViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            Text("Name: \(entity.descrip ?? "ERROR")")
            
            if let holes = entity.holes?.allObjects as? [HoleModel]{
                let sholes = holes.sorted{$0.holeNo < $1.holeNo}
                Text("Holes: ").bold()
                ForEach(sholes) { hole in
                    Text(String(hole.holeNo))
                    
                }
            }
            
        }).padding().frame(maxWidth: 300, alignment: .leading).background(Color.gray.opacity(0.5)).cornerRadius(10).shadow(radius: 10)
    }
}


struct HoleView: View{
    let entity: HoleModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            Text("Name: \(entity.holeNo)")
            
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
            
            Text("Hole \(entity.hole?.holeNo ?? 0)")
            Text("Scorecard \(entity.hole?.scorecard?.descrip ?? "ERROR")")
                
            
        }).padding().frame(maxWidth: 300, alignment: .leading).background(Color.gray.opacity(0.5)).cornerRadius(10).shadow(radius: 10)
    }
}


struct BeginRoundView: View {
    var body: some View {
        
        
        ZStack{
            RoundedRectangle(cornerRadius: 20)
            Text("Begin Round (Goodluck!)").foregroundColor(.white).font(.headline)
                .font(.largeTitle)
        }
        .padding(.horizontal).frame(maxHeight: UIScreen.main.bounds.size.height/10)
//                Button(action: {}, label: {Text("Begin Round (Goodluck!)").font(.headline).frame(height:55).background(Color.accentColor).cornerRadius(10)})
   
    }
}

