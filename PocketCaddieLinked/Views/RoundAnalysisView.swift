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
                            HStack{
                                Text("\(round.descrip ?? "no name given")").padding(.horizontal)
                                Spacer()
                                Text("\(round.date?.formatted(date: .numeric, time: .omitted) ?? "")  ")
                            }
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
                
                
                
               
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                          alignment: .center, spacing: 10){
                    
                    ForEach(vm.holes) { hole in
                        HoleDisplayView(currHole: hole)
                    }
                    
                }.navigationTitle("\(currRound.descrip ?? "")")
                NavigationLink(destination: CollectDataView(currRound: currRound)){
                    ZStack{
                        RoundedRectangle(cornerRadius: 10)
                        Text("Edit Round").foregroundColor(.white).font(.headline)
                            .font(.largeTitle).padding(.all)
                        
                    }
                    .padding(.horizontal)}.simultaneousGesture(TapGesture().onEnded{
                        
                        vm.getSpecHoles(scorecard: currRound)
                    vm.updateHoleNum(scorecard: currRound, index: 0)
                    vm.collectPutts(hole: vm.holes[0])
                })
                
                FinalScoreView(currRound: currRound)
                
                FairwayAnalysisView(currRound: currRound )
                
                
                PuttAnalysisView(currRound: currRound )
                if currRound.advPutt{
                    AdvPuttAnalysisView(currRound: currRound, breakDir: "Straight")
                    AdvPuttAnalysisView(currRound: currRound, breakDir: "Left-Right")
                    AdvPuttAnalysisView(currRound: currRound , breakDir: "Right-Left")
                }
                
                StatView(currRound: currRound).padding(.bottom)
//                HStack{
//
//                    Text("  Stats")
//                        .font(.title)
//                        .fontWeight(.bold).frame(alignment: .leading)
//                    Spacer()
//                }
                
                
                
                
                Button("Delete Round", role:.destructive){
                    self.showAlert = true
                    dismiss()
                    
                }.buttonStyle(.borderedProminent)
            }.padding(.all).frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
        }.alert(isPresented: $showAlert) {
            Alert(title: Text("Confirm Deletion"),
                  message: Text("Are you sure you want to delete \(currRound.descrip ?? "")?"),
                primaryButton: .destructive(Text("Delete")) {
                vm.deleteSpecScorecard(scorecard: currRound)
                
                
                },
                secondaryButton: .cancel())
        }
        
        
    }
}

struct StatView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    let currRound: ScorecardModel
    var body: some View {
        let fairwayVal = vm.faiwayHits(scorecard: currRound)
        let updownVal = vm.upDownCount(scorecard: currRound)
        let greenHitVal = vm.greenHits(scorecard: currRound)
        VStack{
            HStack{
                
                Text("  Stats")
                    .font(.title)
                    .fontWeight(.bold).frame(alignment: .leading)
                Spacer()
            }
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                      alignment: .center, spacing: 10){
//                Text("Fairway Hits: \(fairwayVal[2])")
//                Text("Fairway Miss: \(fairwayVal[0]+fairwayVal[1])")
//                Text("\(String(format: "%.1f", (Float(fairwayVal[2]*100)/Float(fairwayVal.reduce(0,+)))))")
                fairwayCalc(percentage: (Float(fairwayVal[2]*100)/Float(fairwayVal.reduce(0,+))))
//                Text("Updown Hits: \(updownVal[1])")
//                Text("Updown Miss: \(updownVal[0])")
                updownCalc(percentage: (Float(updownVal[1]*100)/Float(updownVal.reduce(0,+))))
//                Text("\(String(format: "%.1f", (Float(updownVal[1]*100)/Float(updownVal.reduce(0,+)))))")
//                Text("Green Hits: \(greenHitVal[1])")
//                Text("Green Miss: \(greenHitVal[0])")
//                Text("\(String(format: "%.1f", (Float(greenHitVal[1]*100)/Float(greenHitVal.reduce(0,+)))))")
                greenCalc(percentage: (Float(greenHitVal[1]*100)/Float(greenHitVal.reduce(0,+))))
                
            }
        }
    }
    
    struct fairwayCalc : View{
        let percentage: Float
        var body: some View {
            
            ZStack{
                RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 1)
                VStack{
                    Text("\(String(format: "%.1f", percentage))").font(.title)
                    Text("Fairway %").font(.body)
                }
            }
           
        }
    }
    
    struct updownCalc : View{
        let percentage: Float
        var body: some View {
            
            ZStack{
                RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 1)
                VStack{
                    Text("\(String(format: "%.1f", percentage))").font(.title)
                    Text("Up & Down %").font(.body)
                }
            }
            
        }
    }
    struct greenCalc : View{
        let percentage: Float
        var body: some View {
            ZStack{
                RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 1)
                VStack{
                    Text("\(String(format: "%.1f", percentage))").font(.title)
                    Text("Green Hit %").font(.body)
                }
            }
        }
    }
}


struct FinalScoreView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    let currRound: ScorecardModel
    var body: some View {
        VStack{
            HStack{
                
                Text("  Overall")
                    .font(.title)
                    .fontWeight(.bold).frame(alignment: .leading)
                Spacer()
            }.padding(.top)
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
        
        VStack{
            HStack{
                
                Text("  Putts")
                    .font(.title)
                    .fontWeight(.bold).frame(alignment: .leading)
                Spacer()
            }
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



    
