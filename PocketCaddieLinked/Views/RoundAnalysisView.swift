//
//  RoundAnalysisView.swift
//  PocketCaddieLinked
//
//  Created by Alex Liu on 6/4/23.
//

import SwiftUI

struct RoundCollectionView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView{
            
    
                ForEach(vm.scorecards){ round in
                    NavigationLink (destination: RoundDisplayView(currRound: round)) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 1)
                            Text("\(round.descrip ?? "no name given")").padding(.horizontal)
                        }.aspectRatio(8/1, contentMode: .fit)
                    }.padding(.horizontal).navigationTitle("Completed Rounds").simultaneousGesture(TapGesture().onEnded{
                        vm.getSpecHoles(scorecard: round)
                        vm.getSpecialPutts(scorecard: round)
                        print(vm.putts.count)
                        print(vm.putts)
                    })
                    
                }
            
        }
        
    }
}

struct RoundDisplayView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    @Environment(\.dismiss) private var dismiss
    let currRound: ScorecardModel
    @State private var showAlert = false
    var body: some View {
        VStack{
            ScrollView(.vertical){
                NavigationLink(destination: CollectDataView(currRound: currRound)){ZStack{
                    RoundedRectangle(cornerRadius: 20)
                    Text("Edit Round").foregroundColor(.white).font(.headline)
                        .font(.largeTitle)
                }
                .padding(.horizontal)}.simultaneousGesture(TapGesture().onEnded{
                    
                    vm.getSpecHoles(scorecard: currRound)
                    vm.updateHoleNum(scorecard: currRound, index: 0)
                    vm.collectPutts(hole: vm.holes[0])
                })
                
                Button("Greeting"){
                    self.showAlert = true
                    dismiss()
                    
                }
               
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                          alignment: .center, spacing: 10){
                    
                    ForEach(vm.holes) { hole in
                        HoleDisplayView(currHole: hole)
                    }
                    
                }.navigationTitle("\(currRound.descrip ?? "")")
                HStack{
                    
                    Text("  Analysis")
                        .font(.title)
                        .fontWeight(.bold).frame(alignment: .leading)
                    Spacer()
                }
                FinalScoreView(currRound: currRound)
                
                FairwayAnalysisView(currRound: currRound )
                PuttAnalysisView(currRound: currRound )
                if currRound.advPutt{
                    AdvPuttAnalysisView(currRound: currRound, breakDir: "Straight")
                    AdvPuttAnalysisView(currRound: currRound, breakDir: "Left-Right")
                    AdvPuttAnalysisView(currRound: currRound , breakDir: "Right-Left")
                }
                
            }.padding(.all).frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
        }.alert(isPresented: $showAlert) {
            Alert(title: Text("Confirm Deletion"),
                message: Text("Are you sure you want to delete xxx?"),
                primaryButton: .destructive(Text("Delete")) {
                vm.deleteSpecScorecard(scorecard: currRound)
                
                
                },
                secondaryButton: .cancel())
        }
        
        
    }
}

struct FinalScoreView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    let currRound: ScorecardModel
    var body: some View {
        
        
        ZStack{
            RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 3)
            
            VStack{
                HStack{
                    
                    Text("Strokes: \(vm.totalScore(scorecard: currRound))")
                    Spacer()
                    Text("Par: \(vm.totalPar(scorecard: currRound))")
                    Spacer()
                    
                    switch Int(vm.totalScore(scorecard: currRound) - vm.totalPar(scorecard: currRound) ) {
                    case let x where x < 0:
                        Text("Score: \(vm.totalScore(scorecard: currRound) - vm.totalPar(scorecard: currRound))")
                        
                    case 0:
                        Text("Score: E")
                        
                    default:
                        
                        Text("Score: \(vm.totalScore(scorecard: currRound) - vm.totalPar(scorecard: currRound))")
                        
                    }
                   
                }
            }.padding(.all)
        }
        .padding([.leading, .bottom, .trailing])
    }
}


struct FairwayAnalysisView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    let currRound: ScorecardModel
    var body: some View {
        let values = vm.faiwayHits(scorecard: currRound)
        
        ZStack{
            RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 3)
            
            VStack{
                HStack{
                    //Spacer()
                    Text("Fairway Stats")
                    Spacer()
                    Text("Left: \(values[0])")
                    Spacer()
                    
                    Text("Hit: \(values[2])")
                    Spacer()
                    Text("Right: \(values[1])")
                    //Spacer()
                }
            }.padding(.all)
        }
        .padding([.leading, .bottom, .trailing])
    }
}



struct PuttAnalysisView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    let currRound: ScorecardModel
    var body: some View {

        let values = vm.puttResults()
        ZStack{
            RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 3)

            VStack{
                HStack{

                    //Spacer()
                    Text("# Putts: \(vm.totalPutts(scorecard: currRound))")
                    Spacer()

                    Text("Miss L: \(values[0])")
                    Spacer()

                    Spacer()

                    Text("Miss R: \(values[1])")
                   // Spacer()

                }
            }.padding(.all)
        }
        .padding([.leading, .bottom, .trailing])
        
        
        
    }
}


struct AdvPuttAnalysisView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    let currRound: ScorecardModel
    let breakDir: String
    var body: some View {

        
        ZStack{
            RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 3)

            VStack{
                HStack{

                    //Spacer()
                    Text("# \(breakDir): \(vm.breakResults(loc: breakDir)[0])")
                    Spacer()

                    Text("Miss L: \(vm.breakMiss( loc:breakDir)[0])")
                    Spacer()


                    Text("Miss R: \(vm.breakMiss( loc:breakDir)[1])")
                   // Spacer()

                }
            }.padding(.all)
        }
        .padding([.leading, .bottom, .trailing])
        
        
        
    }
}

struct HoleDisplayView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    let currHole: HoleModel
    var body: some View {
        
        
        ZStack{
            RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 3)
            
            VStack{
                Spacer()
                HStack{
                    Text("  Hole:")
                    Spacer()
                    Text("\(currHole.holeNo+1)  ")
                }
                

                RoundedRectangle(cornerRadius: 0)
                    .fill().frame(height: 1)
                

                HStack{
                    Text("  Score:")
                    Spacer()
                    Text("\(currHole.score)  ")
                }
               

                RoundedRectangle(cornerRadius: 0)
                    .fill().frame(height: 1)
                

                HStack{
                    Text("  Par:")
                    Spacer()
                    Text("\(currHole.par)  ")
                }
                
                Spacer()
            }
        }
//        .padding(.horizontal)
        
        
    }
}



    
