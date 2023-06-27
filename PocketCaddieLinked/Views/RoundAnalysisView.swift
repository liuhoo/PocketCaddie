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
                       
                    })
                    
                }
            
        }
        
    }
}

struct headingView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    let side: Bool
    var body: some View {
        
        HStack {
            Text("Hole ")
                .foregroundColor(Color.white).font(.system(size: 18, weight: .regular, design: .default))
            Spacer()
            HStack{
                if (side) {
                    ForEach(vm.holes.prefix(9)) { hole in
                        Spacer()
                        Text("\(hole.holeNo+1)")
                            .font(.system(size: 18, weight: .regular, design: .default))
                        //.padding(.trailing)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    
                } else{
                    
                    ForEach(vm.holes.suffix(vm.holes.count-9)) { hole in
                        Spacer()
                        Text("\(hole.holeNo+1)")
                            .font(.system(size: 18, weight: .regular, design: .default))
                        //.padding(.trailing)
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                }
                
            }
            
           
        }
        
        .padding(.horizontal)
        
    }
}
struct parView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    let side: Bool
    var body: some View {
        
        HStack {
            Text("Par    ")
                .foregroundColor(Color.white).font(.system(size: 18, weight: .regular, design: .default))
            Spacer()
            HStack{
                if(side){
                    ForEach(vm.holes.prefix(9)) { hole in
                        Spacer()
                        Text("\(hole.par)")
                            .font(.system(size: 18, weight: .regular, design: .default))
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                } else{
                    
                    ForEach(vm.holes.suffix(vm.holes.count-9)) { hole in
                        Spacer()
                        Text("\(hole.par)")
                            .font(.system(size: 18, weight: .regular, design: .default))
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                }
            }
            
           
        }
        
        .padding(.horizontal)
        
    }
}
struct scoreView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    let side: Bool
    var body: some View {
        
        HStack {
            Text("Score")
                .foregroundColor(Color.white).font(.system(size: 18, weight: .regular, design: .default))
            Spacer()
            HStack{
                if (side) {
                    ForEach(vm.holes.prefix(9)) { hole in
                        Spacer()
                        Text("\(hole.score)")
                            .font(.system(size: 18, weight: .regular, design: .default))
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                } else{
                    ForEach(vm.holes.suffix(vm.holes.count-9)) { hole in
                        Spacer()
                        Text("\(hole.score)")
                            .font(.system(size: 18, weight: .regular, design: .default))
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                }
                
                
            }
           
        }
        
        .padding(.horizontal)
        
    }
}
struct roundView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    let currRound: ScorecardModel
    var body: some View {
        VStack {
            ZStack{
                RoundedRectangle(cornerRadius:  20).strokeBorder(.blue, lineWidth: 4)
                VStack{
                    headingView(side: true)
                        .padding(.top)
                    parView(side: true).padding(.top)
                    scoreView(side: true).padding([.top, .bottom])
                }
            }.padding(.all)
            
            
            if (vm.holes.count  > 9){
                headingView(side: false)
                    .padding(.top)
                parView(side: false).padding(.top)
                scoreView(side: false).padding(.top)
                
            }
           
        }
        .background(Color.black)
        .roundedCorner(20, corners: [.topLeft, .topRight, .bottomRight])
        
    }
}


struct RoundDisplayView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    let currRound: ScorecardModel
    @State private var showAlert = false
    var body: some View {
        
        VStack(spacing: 0) {
            ScrollView {
                roundView(currRound: currRound)
                    .padding(.horizontal)
                
                
            }
            
        }
//        VStack{
//            ScrollView(.vertical){
//
//
//
//                LazyVGrid(columns: [GridItem(.flexible(minimum: 55), spacing: -2), GridItem(.flexible(), spacing: -2), GridItem(.flexible(), spacing: -2),GridItem(.flexible(), spacing: -2), GridItem(.flexible(), spacing: -2), GridItem(.flexible(), spacing: -2),GridItem(.flexible(), spacing: -2), GridItem(.flexible(), spacing: -2), GridItem(.flexible(), spacing: -2), GridItem(.flexible(), spacing: -2)],
//                          alignment: .center, spacing: 4){
//                    ZStack{
//                        Rectangle().strokeBorder(lineWidth: 2)
//
//                        VStack{
//
//                            HStack{
//            //                    Text("  Hole:")
//            //                    Spacer()
//
//                                Text(" Hole")
//                                Spacer()
//
//                            }
//                            Divider().frame(height: 1).background(colorScheme == .light ? Color.black : Color.white)
//                            HStack{
//            //                    Text("  Score:")
//            //                    Spacer()
//
//                                Text(" Score")
//                                Spacer()
//                            }
//                            Divider().frame(height: 1).background(colorScheme == .light ? Color.black : Color.white)
//                            HStack{
//            //
//                                Text(" Par")
//                                Spacer()
//
//                            }
//
//
//                        }
//                    }.font(.system(size: 16))
//                    ForEach(vm.holes.prefix(9)) { hole in
//                        HoleDisplayView(currHole: hole)
//                    }
//
//                    if vm.holes.count > 9 {
//                        ZStack{
//
//                            Rectangle().strokeBorder(lineWidth: 2)
//                            VStack{
//
//                                HStack{
//                //                    Text("  Hole:")
//                //                    Spacer()
//
//                                    Text(" Hole")
//                                    Spacer()
//
//                                }
//                                Divider().frame(height: 1).background(Color.black)
//                                HStack{
//                //                    Text("  Score:")
//                //                    Spacer()
//
//                                    Text(" Score")
//                                    Spacer()
//                                }
//                                Divider().frame(height: 1).background(Color.black)
//                                HStack{
//                //
//                                    Text(" Par")
//                                    Spacer()
//
//                                }
//
//
//                            }
//                        }.font(.system(size: 16))
//                        ForEach(vm.holes.suffix(vm.holes.count-9)) { hole in
//                            HoleDisplayView(currHole: hole)
//                        }
//
//                    }
//
//                }.navigationTitle("\(currRound.descrip ?? "")")
//                NavigationLink(destination: CollectDataView(currRound: currRound)){
//                    ZStack{
//                        RoundedRectangle(cornerRadius: 10)
//                        Text("Edit Round").foregroundColor(.white).font(.headline)
//                            .font(.largeTitle).padding(.all)
//
//                    }
//                    .padding(.horizontal)}.simultaneousGesture(TapGesture().onEnded{
//
//                        vm.getSpecHoles(scorecard: currRound)
//                    vm.updateHoleNum(scorecard: currRound, index: 0)
//                    vm.collectPutts(hole: vm.holes[0])
//                })
//
//                FinalScoreView(currRound: currRound)
//
//                FairwayAnalysisView(currRound: currRound )
//
//
//                PuttAnalysisView(currRound: currRound )
//                if currRound.advPutt{
//                    AdvPuttAnalysisView(currRound: currRound, breakDir: "Straight")
//                    AdvPuttAnalysisView(currRound: currRound, breakDir: "Left-Right")
//                    AdvPuttAnalysisView(currRound: currRound , breakDir: "Right-Left")
//                    HighLowView(currRound: currRound)
//                }
//                PuttCountView(currRound: currRound)
//                StatView(currRound: currRound)
//
//
//                Button("Delete Round", role:.destructive){
//                    self.showAlert = true
//                    dismiss()
//
//                }.buttonStyle(.borderedProminent)
//
//
//
//            }.padding(.all).frame(maxWidth: .infinity, maxHeight: .infinity)
//
//
//        }.alert(isPresented: $showAlert) {
//            Alert(title: Text("Confirm Deletion"),
//                  message: Text("Are you sure you want to delete \(currRound.descrip ?? "")?"),
//                primaryButton: .destructive(Text("Delete")) {
//                vm.deleteSpecScorecard(scorecard: currRound)
//
//
//                },
//                secondaryButton: .cancel())
//        }
        
        
    }
}







struct PuttCountView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    let currRound: ScorecardModel
    var body: some View {
        let stat = vm.puttCount(scorecard: currRound)
        VStack{
                
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                      alignment: .center, spacing: 10){
                onePutt(num: stat[0])
                twoPutt(num: stat[1])
                threePuttPlus(num: stat[2])
            }
                
//
        }
    }
    struct onePutt : View{
        let num: Int
        var body: some View {
            
            ZStack{
                RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 1)
                VStack{
                    Text("\(String(format: "%d", num))").font(.title)
                    Text("# One Putts").font(.body)
                }
            }
           
        }
    }
    
    struct twoPutt : View{
        let num: Int
        var body: some View {
            
            ZStack{
                RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 1)
                VStack{
                    Text("\(String(format: "%d", num))").font(.title)
                    Text("# Two Putts").font(.body)
                }
            }
            
        }
    }
    struct threePuttPlus : View{
        let num: Int
        var body: some View {
            ZStack{
                RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 1)
                VStack{
                    Text("\(String(format: "%d", num))").font(.title)
                    Text("# Three Putts+").font(.body)
                }
            }
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

struct HighLowView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    let currRound: ScorecardModel
    var body: some View {

        let RL = vm.breakMiss(loc: "Right-Left")
        let LR = vm.breakMiss(loc: "Left-Right")
        
            VStack{
                HStack{
                    ZStack{
                        RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 1)
                        VStack{
                            Text("\(RL[0]+LR[1])").font(.title)
                            Text("# Putts Miss Low").font(.body)
                        }
                    }
                    ZStack{
                        RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 1)
                        VStack{
                            Text("\(RL[1]+LR[0])").font(.title)
                            Text("# Putts Miss High").font(.body)
                        }
                    }
                    
                    
                }
            }.padding([.horizontal])
        



    }
}

struct HoleDisplayView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    @Environment(\.colorScheme) var colorScheme
    let currHole: HoleModel
    var body: some View {
        
        
        ZStack{
            Rectangle().strokeBorder(lineWidth: 2)
            
            VStack{
                Spacer()
                HStack{
//                    Text("  Hole:")
//                    Spacer()
                    Spacer()
                    Text("\(currHole.holeNo+1)")
                    Spacer()
                }
                

                Divider().frame(height: 1).background(colorScheme == .light ? Color.black : Color.white)
                

                HStack{
//                    Text("  Score:")
//                    Spacer()
                    Spacer()
                    Text("\(currHole.score)")
                    Spacer()
                }
               

                Divider().frame(height: 1).background(colorScheme == .light ? Color.black : Color.white)
                

                HStack{
//Spacer()
                    Spacer()
                    Text("\(currHole.par)")
                    Spacer()
                }
                
                Spacer()
            }
        }.font(.system(size: 16))
//        .padding(.horizontal)
        
        
    }
}



    
