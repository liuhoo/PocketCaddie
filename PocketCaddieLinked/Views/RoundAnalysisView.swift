//
//  RoundAnalysisView.swift
//  PocketCaddieLinked
//
//  Created by Alex Liu on 6/4/23.
//

import SwiftUI




struct roundView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    let currRound: ScorecardModel
    var body: some View {
        VStack {
            ZStack{
                RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
                ).fill(Color("Text"))
                RoundedRectangle(cornerRadius:  20).strokeBorder(.blue, lineWidth: 4)
                VStack{
                    headingView(side: true)
                        .padding(.top)
                    Rectangle().fill(Color.blue).frame(height: 4, alignment: .center)
                    parView(side: true)
                    scoreView(side: true).padding([.bottom], 15).padding([.top], 5)
                }
            }.padding(.all)
            
            
           
            
            
            
            if (vm.holes.count  > 9){
                
                ZStack{
                    RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                    ).fill(Color("Text"))
                    RoundedRectangle(cornerRadius:  20).strokeBorder(.blue, lineWidth: 4)
                    VStack{
                        headingView(side: false)
                            .padding(.top)
                        Rectangle().fill(Color.blue).frame(height: 4, alignment: .center)
                        parView(side: false)
                        scoreView(side: false).padding([.bottom], 15).padding([.top], 5)
                        
                    }
                }.padding(.all)
                
                
            }
           
        }.background(Color("Background")).roundedCorner(20, corners: [.topLeft, .topRight, .bottomRight])
        
    }
    struct headingView: View {
        @EnvironmentObject var vm: CoreDataViewModel
        let side: Bool
        var body: some View {
            
            HStack {
                Text("Hole ")
                    .foregroundColor(Color.white).font(.system(size: 15, weight: .regular, design: .default))
                Spacer()
                HStack{
                    if (side) {
                        ForEach(vm.holes.prefix(9)) { hole in
                            Spacer()
                            Text("\(hole.holeNo+1)")
                                .font(.system(size: 15, weight: .regular, design: .default))
                            //.padding(.trailing)
                                .foregroundColor(Color.white)
                            Spacer()
                        }
                        
                    } else{
                        
                        ForEach(vm.holes.suffix(vm.holes.count-9)) { hole in
                            Spacer()
                            Text("\(hole.holeNo+1)")
                                .font(.system(size: 15, weight: .regular, design: .default))
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
                    .foregroundColor(Color.white).font(.system(size: 15, weight: .regular, design: .default))
                Spacer()
                HStack{
                    if(side){
                        ForEach(vm.holes.prefix(9)) { hole in
                            Spacer()
                            Text("\(hole.par)")
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                    } else{
                        
                        ForEach(vm.holes.suffix(vm.holes.count-9)) { hole in
                            Spacer()
                            Text("\(hole.par)")
                                .font(.system(size: 15, weight: .regular, design: .default))
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
                    .foregroundColor(Color.white).font(.system(size: 15, weight: .regular, design: .default))
                Spacer()
                HStack{
                    if (side) {
                        ForEach(vm.holes.prefix(9)) { hole in
                            Spacer()
                            Text("\(hole.score)")
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                    } else{
                        ForEach(vm.holes.suffix(vm.holes.count-9)) { hole in
                            Spacer()
                            Text("\(hole.score)")
                                .font(.system(size: 15, weight: .regular, design: .default))
                                .foregroundColor(Color.gray)
                            Spacer()
                        }
                    }
                    
                    
                }
               
            }
            
            .padding(.horizontal)
            
        }
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
                
                
                
                
                if currRound.advPutt{
                    PuttTable(currRound: currRound)
                    HighLowView(currRound: currRound)
//                    AdvPuttAnalysisView(currRound: currRound, breakDir: "Straight")
//                    AdvPuttAnalysisView(currRound: currRound, breakDir: "Left-Right")
//                    AdvPuttAnalysisView(currRound: currRound , breakDir: "Right-Left")
                    
                } else{
                    PuttAnalysisView(currRound: currRound)
                }
                PuttCountView(currRound: currRound)
                StatView(currRound: currRound)
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
        }.navigationTitle("\(currRound.descrip ?? "")")
        
        
        
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
                    Text("One Putts").font(.body)
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
                    Text("Two Putts").font(.body)
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
                    Text("Three Putts +").font(.body)
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
                        Text("# Putts: \(vm.totalPutts(scorecard: currRound))")
                        Spacer()
                        Text("Miss L: \(values[0])")
                        Spacer()
                        Text("Miss R: \(values[1])")
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


struct PuttTable: View{
    @EnvironmentObject var vm: CoreDataViewModel
    let currRound: ScorecardModel
    var body: some View {
       
        
        
        VStack{
            HStack{
                Text("  Putts")
                    .font(.title)
                    .fontWeight(.bold).frame(alignment: .leading)
                Spacer()
            }
            ZStack{
                RoundedRectangle(
                cornerRadius: 20,
                style: .continuous)
                .fill(Color(.white))
                RoundedRectangle(cornerRadius:  20).strokeBorder(.blue, lineWidth: 4)
                
                VStack{
                    Header().padding(.top)
                    Rectangle().fill(Color.blue).frame(height: 4, alignment: .center)
                    Straight().padding(.bottom)
                    LeftRight().padding(.bottom)
                    RightLeft().padding(.bottom)
                    Total().padding(.bottom)
                }
            }.padding([.bottom, .horizontal])
            
        }
        
        
        
    }
    
    
    struct Header: View {
        @EnvironmentObject var vm: CoreDataViewModel
        var body: some View {
            
                HStack {
                    Text("Putt Table")
                    //                    .foregroundColor(Color.white).font(.system(size: 15, weight: .regular, design: .default))
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Text("Makes")
                        Spacer()
                        Text("Miss L")
                        Spacer()
                        Text("Miss R")
                        Spacer()
                        Text("Total")
                        
                    }
                    
                    
                }.padding(.horizontal)
               
            
        }
    }
//    let breaking = ["Break?", "Left-Right","Right-Left", "Straight"]
//    let miss = ["Miss?", "Left","Right", "Make"]
    struct Straight: View {
        @EnvironmentObject var vm: CoreDataViewModel
        var body: some View {
            let total = vm.breakResults(loc: "Straight")
            let miss = vm.breakMiss(loc: "Straight")
            HStack {
                Text("Straight    ")

                Spacer()
                HStack{
                    Spacer()
                    Text("\(total[0] - miss[0] - miss[1])")
                    Spacer()
                    Text("\(miss[0])")
                    Spacer()
                    Text("\(miss[1])")
                    Spacer()
                    Text("\(total[0])")
                }
            }.padding(.horizontal)
        }
    }
    
    
    struct LeftRight: View {
        @EnvironmentObject var vm: CoreDataViewModel
        var body: some View {
            let total = vm.breakResults(loc: "Left-Right")
            let miss = vm.breakMiss(loc: "Left-Right")
            HStack {
                Text("Left-Right")

                Spacer()
                HStack{
                    Spacer()
                    Text("\(total[0] - miss[0] - miss[1])")
                    Spacer()
                    Text("\(miss[0])")
                    Spacer()
                    Text("\(miss[1])")
                    Spacer()
                    Text("\(total[0])")
                }
            }.padding(.horizontal)
        }
    }
    
    struct RightLeft: View {
        @EnvironmentObject var vm: CoreDataViewModel
        var body: some View {
            let total = vm.breakResults(loc: "Right-Left")
            let miss = vm.breakMiss(loc: "Right-Left")
            HStack {
                Text("Right-Left")

                Spacer()
                HStack{
                    Spacer()
                    Text("\(total[0] - miss[0] - miss[1])")
                    Spacer()
                    Text("\(miss[0])")
                    Spacer()
                    Text("\(miss[1])")
                    Spacer()
                    Text("\(total[0])")
                }
            }.padding(.horizontal)
        }
    }
    
    struct Total: View {
        @EnvironmentObject var vm: CoreDataViewModel
        var body: some View {
            let S = vm.breakResults(loc: "Straight")
            let LR = vm.breakResults(loc: "Left-Right")
            let RL = vm.breakResults(loc: "Right-Left")
            let btot = zip(RL, LR).map(+)
            let Stot = zip(btot, S).map(+)
            
            let miss = vm.breakMiss(loc: "Straight")
            let LRmiss = vm.breakMiss(loc: "Left-Right")
            let RLmiss = vm.breakMiss(loc: "Right-Left")
            let bmiss = zip(RLmiss, LRmiss).map(+)
            let Smiss = zip(bmiss, miss).map(+)
            
            
          
            HStack {
                Text("Total         ")

                Spacer()
                HStack{
                    Spacer()
                    Text("\(Stot[0] - Smiss[0] - Smiss[1])")
                    Spacer()
                    Text("\(Smiss[0])")
                    Spacer()
                    Text("\(Smiss[1])")
                    Spacer()
                    Text("\(Stot[0])")
                }
            }.padding(.horizontal)
        }
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



    
