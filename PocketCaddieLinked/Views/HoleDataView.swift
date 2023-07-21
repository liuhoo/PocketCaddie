//
//  HoleDataView.swift
//  PocketCaddieLinked
//
//  Created by Alex Liu on 5/30/23.
//

import SwiftUI

struct CollectDataView: View {
    @State var ParStepper: Int = 0
    @State var ScoreStepper: Int = 0
    @EnvironmentObject var vm: CoreDataViewModel
    @EnvironmentObject var appState: AppState
    var currRound: ScorecardModel
    var body: some View {
        
        let holeNo = Int(currRound.currHole)
        let currHole = vm.holes[holeNo]
        VStack(alignment: .center, spacing:0){
            ZStack{

                LazyVGrid(columns: [GridItem(),GridItem(),GridItem()]){
                    ForEach(vm.holes) { i in
                        HoleSelectView(HoleNumber: Int(i.holeNo), change: holeNo, round: currRound)
                    }
                }.padding().cornerRadius(20).overlay(RoundedRectangle(cornerRadius: 10).inset(by: -10).strokeBorder(lineWidth: 1 ).padding(.all))
                        

            }.frame(alignment: .topLeading)
            List{
                HStack{
                    Spacer()
                    Text("Hole No: \(currHole.holeNo + 1)")
                    Spacer()
                }
                HStack{
                    Stepper{Text("Par: \(currHole.par)")} onIncrement: {
                        vm.incrementPar(scorecard: currRound, index: holeNo)
                        if currHole.par > 5 { vm.decrementPar(scorecard: currRound, index: holeNo)}
                    } onDecrement: {
                        vm.decrementPar(scorecard: currRound, index: holeNo)
                        if currHole.par < 0 { vm.incrementPar(scorecard: currRound, index: holeNo)}
                    }
                }
                HStack{
                    Stepper{Text("Score: \(currHole.score)")} onIncrement: {
                        vm.incrementScore(scorecard: currRound, index: holeNo)
                    } onDecrement: {
                        vm.decrementScore(scorecard: currRound, index: holeNo)
                        if currHole.score < 0 { vm.incrementScore(scorecard: currRound, index: holeNo)}
                    }
                }
                FairwayButton(hole: currHole)
                GreenHitButton(hole: currHole)
                UpDownButton(hole: currHole)
                HStack{
                    
                    Text("Putts On Hole")
                    Spacer()
                }
                ForEach(Array(vm.putts.enumerated()), id: \.element) { index, element in
//                    PuttButton(putt: putt, adv: currRound.advPutt)
                    let putt = element
                    PuttButton(putt: putt, adv: currRound.advPutt, puttNum: index, breakInput: putt.breaking ?? "Break?", missInput: putt.miss ?? "Miss?")


                }.onDelete { indexSet in
                    
                    removePutt(offsets: indexSet, hole: currHole)
                }
                      
                
               
                        
                HStack{
                    Spacer()
                    Button{
                        vm.addPutt(hole: currHole)
                        
                    }label: {  HStack{Text("Add Putt");Image(systemName: "plus.rectangle")}}
                    Spacer()
                }.font(.title2)
                
            }.padding().navigationTitle(currRound.descrip ?? "").frame(maxHeight: .infinity)
            if vm.holes.count == 1{
                
                HStack{
                    Button("Finish Round"){
                        appState.popToRoot()
                    }.buttonStyle(.borderedProminent)
                }
                
            }
            else if holeNo == vm.holes.count-1{
                HStack{
                    Button("Previous Hole"){
                        vm.updateHoleNum(scorecard: currRound, index: holeNo-1)
                    }.buttonStyle(.borderedProminent)
                    Button("Finish Round"){
                        appState.popToRoot()
                    }.buttonStyle(.borderedProminent)
                }
            } else if holeNo == 0 {
                Button("Next Hole"){
                    vm.updateHoleNum(scorecard: currRound, index: holeNo+1)
                }.buttonStyle(.borderedProminent)
            }  else{
                HStack{
                    Button("Previous Hole"){
                        vm.updateHoleNum(scorecard: currRound, index: holeNo-1)
                    }.buttonStyle(.borderedProminent)
                    Button("Next Hole"){
                        vm.updateHoleNum(scorecard: currRound, index: holeNo+1)
                    }.buttonStyle(.borderedProminent)
                }
            }
            
        }
    }
    
    func removePutt(offsets: IndexSet, hole: HoleModel){
        offsets.sorted(by: > ).forEach { (i) in
            vm.deleteSpecPutt(Putt: vm.putts[i], Hole: hole)
        }
    }
}


struct PuttButton: View {
    @EnvironmentObject var vm: CoreDataViewModel
    var putt: PuttModel
    let adv : Bool
    let puttNum: Int
    let breaking = ["Break?", "Left-Right","Right-Left", "Straight"]
    let miss = ["Miss?", "Left","Right", "Make"]
    @State var breakInput: String = "Break?"
    @State var missInput: String = "Miss?"
    var body: some View {
        HStack{
            Text("#\(puttNum+1)").font(.body)
            Spacer()

            if adv {
                Picker("", selection: $breakInput) {
                    ForEach(breaking, id: \.self) {
                        Text($0).font(.body)
                    }
                }.padding(.trailing)
                .pickerStyle(.menu).labelsHidden().onChange(of: breakInput, perform:{ (value) in
                    vm.updatePuttBreak(putt: putt, update:value)
                }).overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .strokeBorder(.blue, lineWidth: 2)
                )
            }
                
            
            Spacer()
            Picker("", selection: $missInput) {
                ForEach(miss, id: \.self) {
                    Text($0).font(.body)
                }
            }.padding(.trailing)
            .pickerStyle(.menu).labelsHidden().onChange(of: missInput, perform:{ (value) in
                vm.updatePuttMiss(putt: putt, update:value)
            }).overlay(
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(.blue, lineWidth: 2)
            )
            
            
            
            //            if adv {
            //                switch putt.breaking {
            //                case "LR":
            //                    Button{vm.updatePuttBreak(putt: putt, update:"LR")}label: {  Image(systemName: "arrow.uturn.left.circle.fill")}
            //                    Button{vm.updatePuttBreak(putt: putt, update:"S")}label: {  Image(systemName: "arrow.up.circle")}
            //                    Button{vm.updatePuttBreak(putt: putt, update:"RL")}label: {  Image(systemName: "arrow.uturn.right.circle")}
            //                case "S":
            //                    Button{vm.updatePuttBreak(putt: putt, update:"LR")}label: {  Image(systemName: "arrow.uturn.left.circle")}
            //                    Button{vm.updatePuttBreak(putt: putt, update:"S")}label: {  Image(systemName: "arrow.up.circle.fill")}
            //                    Button{vm.updatePuttBreak(putt: putt, update:"RL")}label: {  Image(systemName: "arrow.uturn.right.circle")}
            //                case "RL":
            //                    Button{vm.updatePuttBreak(putt: putt, update:"LR")}label: {  Image(systemName: "arrow.uturn.left.circle")}
            //                    Button{vm.updatePuttBreak(putt: putt, update:"S")}label: {  Image(systemName: "arrow.up.circle")}
            //                    Button{vm.updatePuttBreak(putt: putt, update:"RL")}label: {  Image(systemName: "arrow.uturn.right.circle.fill")}
            //                default:
            //                    Button{vm.updatePuttBreak(putt: putt, update:"LR")}label: {  Image(systemName: "arrow.uturn.left.circle")}
            //                    Button{vm.updatePuttBreak(putt: putt, update:"S")}label: {  Image(systemName: "arrow.up.circle")}
            //                    Button{vm.updatePuttBreak(putt: putt, update:"RL")}label: {  Image(systemName: "arrow.uturn.right.circle")}
            //                }
            //                Text("|")
            //            }
                        
            //            switch putt.miss {
            //            case "L":
            //                HStack{
            //                    Button{vm.updatePuttMiss(putt: putt, update:"L")}label: {  Image(systemName: "arrow.left.circle.fill")}
            //                    Button{vm.updatePuttMiss(putt: putt, update:"R")}label: {  Image(systemName: "arrow.right.circle")}
            //                }
            //            case "R":
            //                HStack{
            //                    Button{vm.updatePuttMiss(putt: putt, update:"L")}label: {  Image(systemName: "arrow.left.circle")}
            //                    Button{vm.updatePuttMiss(putt: putt, update:"R")}label: {  Image(systemName: "arrow.right.circle.fill")}
            //                }
            //            default:
            //                HStack{
            //                    Button{vm.updatePuttMiss(putt: putt, update:"L")}label: {  Image(systemName: "arrow.left.circle")}
            //                    Button{vm.updatePuttMiss(putt: putt, update:"R")}label: {  Image(systemName: "arrow.right.circle")}
            //                }
            //            }
            //            VStack{
            //                switch putt.miss {
            //                case "L":
            //                    HStack{
            //                        Button{vm.updatePuttMiss(putt: putt, update:"L")}label: {  Image(systemName: "arrow.left.circle.fill")}
            //                        Button{vm.updatePuttMiss(putt: putt, update:"R")}label: {  Image(systemName: "arrow.right.circle")}
            //                    }
            //                case "R":
            //                    HStack{
            //                        Button{vm.updatePuttMiss(putt: putt, update:"L")}label: {  Image(systemName: "arrow.left.circle")}
            //                        Button{vm.updatePuttMiss(putt: putt, update:"R")}label: {  Image(systemName: "arrow.right.circle.fill")}
            //                    }
            //                default:
            //                    HStack{
            //                        Button{vm.updatePuttMiss(putt: putt, update:"L")}label: {  Image(systemName: "arrow.left.circle")}
            //                        Button{vm.updatePuttMiss(putt: putt, update:"R")}label: {  Image(systemName: "arrow.right.circle")}
            //                    }
            //                }
            //                Text("Miss").font(.body)
            //            }
            
            

        }.font(.title2).buttonStyle(.borderless)
    }
}

struct FairwayButton: View {
    @EnvironmentObject var vm: CoreDataViewModel
    var hole: HoleModel
    var body: some View {
        HStack{
            Text("Fairway?").font(.body)
            Spacer()
            switch hole.fairwayHit {
            case "L":
                Button{vm.updateFairway(hole: hole, update:"L")}label: {  Image(systemName: "arrow.up.left.circle.fill")}
                Button{vm.updateFairway(hole: hole, update:"H")}label: {  Image(systemName: "checkmark.circle")}
                Button{vm.updateFairway(hole: hole, update:"R")}label: {  Image(systemName: "arrow.up.right.circle")}
            case "H":
                Button{vm.updateFairway(hole: hole, update:"L")}label: {  Image(systemName: "arrow.up.left.circle")}
                Button{vm.updateFairway(hole: hole, update:"H")}label: {  Image(systemName: "checkmark.circle.fill")}
                Button{vm.updateFairway(hole: hole, update:"R")}label: {  Image(systemName: "arrow.up.right.circle")}
            case "R":
                Button{vm.updateFairway(hole: hole, update:"L")}label: {  Image(systemName: "arrow.up.left.circle")}
                Button{vm.updateFairway(hole: hole, update:"H")}label: {  Image(systemName: "checkmark.circle")}
                Button{vm.updateFairway(hole: hole, update:"R")}label: {  Image(systemName: "arrow.up.right.circle.fill")}
            default:
                Button{vm.updateFairway(hole: hole, update:"L")}label: {  Image(systemName: "arrow.up.left.circle")}
                Button{vm.updateFairway(hole: hole, update:"H")}label: {  Image(systemName: "checkmark.circle")}
                Button{vm.updateFairway(hole: hole, update:"R")}label: {  Image(systemName: "arrow.up.right.circle")}
            }
        }.font(.title2).buttonStyle(.borderless)
    }
}

struct GreenHitButton: View {
    @EnvironmentObject var vm: CoreDataViewModel
    var hole: HoleModel
    var body: some View {
        HStack{
            Text("Green Hit?").font(.body)
            Spacer()
            switch hole.greenHit {
            case "Y":
                Button{vm.updateGreenHit(hole: hole, update:"N")}label: {  Image(systemName: "x.square")}
                Button{vm.updateGreenHit(hole: hole, update:"Y")}label: {  Image(systemName: "checkmark.square.fill")}
            case "N":
                Button{vm.updateGreenHit(hole: hole, update:"N")}label: {  Image(systemName: "x.square.fill")}
                Button{vm.updateGreenHit(hole: hole, update:"Y")}label: {  Image(systemName: "checkmark.square")}
            default:
                Button{vm.updateGreenHit(hole: hole, update:"N")}label: {  Image(systemName: "x.square")}
                Button{vm.updateGreenHit(hole: hole, update:"Y")}label: {  Image(systemName: "checkmark.square")}
            }
        }.font(.title2).buttonStyle(.borderless)
    }
}
struct UpDownButton: View {
    @EnvironmentObject var vm: CoreDataViewModel
    var hole: HoleModel
    var body: some View {
        HStack{
            Text("Up and Down?").font(.body)
            Spacer()
            switch hole.upDown {
            case "Y":
                Button{vm.updateUpDown(hole: hole, update:"N")}label: {  Image(systemName: "x.square")}
                Button{vm.updateUpDown(hole: hole, update:"Y")}label: {  Image(systemName: "checkmark.square.fill")}
            case "N":
                Button{vm.updateUpDown(hole: hole, update:"N")}label: {  Image(systemName: "x.square.fill")}
                Button{vm.updateUpDown(hole: hole, update:"Y")}label: {  Image(systemName: "checkmark.square")}
            default:
                Button{vm.updateUpDown(hole: hole, update:"N")}label: {  Image(systemName: "x.square")}
                Button{vm.updateUpDown(hole: hole, update:"Y")}label: {  Image(systemName: "checkmark.square")}
            }
        }.font(.title2).buttonStyle(.borderless)
    }
}



struct HoleSelectView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    var HoleNumber: Int
    var num: Int = 0
    var change: Int
    var round: ScorecardModel
    var body: some View {
       
            if change == HoleNumber {
                Button{
                    vm.updateScorecardRound(round: round , newInd: HoleNumber)
                    vm.getSpecPutts(hole:vm.holes[HoleNumber])
                }label: {Text("\(HoleNumber+1)").font(.body) .frame(maxWidth: UIScreen.main.bounds.size.width/4)}.buttonStyle(.borderedProminent)
            } else{
                Button{
                    vm.updateScorecardRound(round: round , newInd: HoleNumber)
                    vm.getSpecPutts(hole:vm.holes[HoleNumber])
                }label: {Text("\(HoleNumber+1)").font(.body).frame(maxWidth: UIScreen.main.bounds.size.width/4)}.buttonStyle(.bordered)
            }
            
       
    }
}

