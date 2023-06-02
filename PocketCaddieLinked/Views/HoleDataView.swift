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
    var body: some View {
        let currRound = vm.scorecards[0]
        var holeNo = Int(currRound.currHole)
        var currHole = vm.holes[holeNo]
        VStack(alignment: .center, spacing:0){
            ZStack{

                LazyVGrid(columns: [GridItem(),GridItem(),GridItem()]){
                    //                    ForEach(currRound.holes[0..<currRound.holes.count], id: \.self) {i in
                    ////                        NavigationLink(destination: Text("HERE")){HoleSelectView(HoleNumber: i.id)}
                    //                        HoleSelectView(HoleNumber: i.holeNo+1)
                    //                    }
                    ForEach(vm.holes) { i in
                        HoleSelectView(HoleNumber: Int(i.holeNo), change: holeNo)
                    }
                }.padding().cornerRadius(20).overlay(RoundedRectangle(cornerRadius: 10).inset(by: -10).strokeBorder(lineWidth: 1 ).padding(.all))
                        

            }.frame(maxHeight: UIScreen.main.bounds.size.height/4)
            List{
//                HStack(){
//
//                    Text("Current Score")
//                    Spacer()
//                    ForEach(vm.getHoles(roundNo: element)) {hole in
//                        vm.getRound(index: element).totScore += 1
//                    }
//                }

                HStack{
                    Stepper{Text("Par: \(currHole.par)")} onIncrement: {
                        vm.incrementPar(scorecard: currRound, index: holeNo)
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
                FairwayButton(roundNumber: vm.scorecards.count-1, holeNo: holeNo)
                GreenHitButton(roundNumber: vm.scorecards.count-1, holeNo: holeNo)
                UpDownButton(roundNumber: vm.scorecards.count-1, holeNo: holeNo)
//                ForEach(currHole.putts {putt in
//
//                    HStack{
//                        Text("Putt #\(putt.id+1)").font(.body)
//                        Spacer()
//                        Button{}label: {  Image(systemName: "arrow.uturn.left.circle")}
//                        Button{}label: {  Image(systemName: "arrow.up.circle")}
//                        Button{}label: {  Image(systemName: "arrow.uturn.right.circle")}
//                        Text("|")
//                        Button{}label: {  Image(systemName: "arrow.left.circle")}
//                        Button{}label: {  Image(systemName: "arrow.right.circle")}
//                        Button{}label: {  Image(systemName: "arrow.up.circle")}
//                        Button{}label: {  Image(systemName: "arrow.down.circle")}
//                    }.font(.title3)
//                }
                        
                        
                HStack{
                    Text("New Putt").font(.body)
                    Spacer()
                    Button{}label: {  Image(systemName: "arrow.uturn.left.circle")}
                    Button{}label: {  Image(systemName: "arrow.up.circle")}
                    Button{}label: {  Image(systemName: "arrow.uturn.right.circle")}
                    Text("|")
                    Button{}label: {  Image(systemName: "arrow.left.circle")}
                    Button{}label: {  Image(systemName: "arrow.right.circle")}
                    Button{}label: {  Image(systemName: "arrow.up.circle")}
                    Button{}label: {  Image(systemName: "arrow.down.circle")}
                }.font(.title3)
                HStack{
                    Spacer()
                    Button{
                       
                    }label: {  HStack{Text("Add Putt");Image(systemName: "plus.rectangle")}}
                    Spacer()
                }.font(.title2)
            }
            .padding()
            

        }
    }
}

struct FairwayButton: View {
    @EnvironmentObject var vm: CoreDataViewModel
    var roundNumber: Int
    var holeNo: Int
    var body: some View {
        HStack{
            Text("Fairway?").font(.body)
            Spacer()
//            switch vm.getFairway(roundNo: roundNumber, hole: holeNo) {
//            case "L":
//                Button{vm.updateFairway(roundNo: roundNumber, hole: holeNo, state: "L")}label: {  Image(systemName: "arrow.up.left.circle.fill")}
//                Button{vm.updateFairway(roundNo: roundNumber, hole: holeNo, state: "H")}label: {  Image(systemName: "checkmark.circle")}
//                Button{vm.updateFairway(roundNo: roundNumber, hole: holeNo, state: "R")}label: {  Image(systemName: "arrow.up.right.circle")}
//            case "H":
//                Button{vm.updateFairway(roundNo: roundNumber, hole: holeNo, state: "L")}label: {  Image(systemName: "arrow.up.left.circle")}
//                Button{vm.updateFairway(roundNo: roundNumber, hole: holeNo, state: "H")}label: {  Image(systemName: "checkmark.circle.fill")}
//                Button{vm.updateFairway(roundNo: roundNumber, hole: holeNo, state: "R")}label: {  Image(systemName: "arrow.up.right.circle")}
//            case "R":
//                Button{vm.updateFairway(roundNo: roundNumber, hole: holeNo, state: "L")}label: {  Image(systemName: "arrow.up.left.circle")}.buttonStyle(.borderless)
//                Button{vm.updateFairway(roundNo: roundNumber, hole: holeNo, state: "H")}label: {  Image(systemName: "checkmark.circle")}
//                Button{vm.updateFairway(roundNo: roundNumber, hole: holeNo, state: "R")}label: {  Image(systemName: "arrow.up.right.circle.fill")}
//            default:
//                Button{vm.updateFairway(roundNo: roundNumber, hole: holeNo, state: "L")}label: {  Image(systemName: "arrow.up.left.circle")}
//                Button{vm.updateFairway(roundNo: roundNumber, hole: holeNo, state: "H")}label: {  Image(systemName: "checkmark.circle")}
//                Button{vm.updateFairway(roundNo: roundNumber, hole: holeNo, state: "R")}label: {  Image(systemName: "arrow.up.right.circle")}
//            }
        }.font(.title2).buttonStyle(.borderless)
    }
}

struct GreenHitButton: View {
    @EnvironmentObject var vm: CoreDataViewModel
    var roundNumber: Int
    var holeNo: Int
    var body: some View {
        HStack{
            Text("Green Hit?").font(.body)
            Spacer()
//            switch vm.getGreenHit(roundNo: roundNumber, hole: holeNo) {
//            case "Y":
//                Button{vm.updateGreenHit(roundNo: roundNumber, hole: holeNo, state: "N")}label: {  Image(systemName: "x.square")}
//                Button{vm.updateGreenHit(roundNo: roundNumber, hole: holeNo, state: "Y")}label: {  Image(systemName: "checkmark.square.fill")}
//            case "N":
//                Button{vm.updateGreenHit(roundNo: roundNumber, hole: holeNo, state: "N")}label: {  Image(systemName: "x.square.fill")}
//                Button{vm.updateGreenHit(roundNo: roundNumber, hole: holeNo, state: "Y")}label: {  Image(systemName: "checkmark.square")}
//            default:
//                Button{vm.updateGreenHit(roundNo: roundNumber, hole: holeNo, state: "N")}label: {  Image(systemName: "x.square")}
//                Button{vm.updateGreenHit(roundNo: roundNumber, hole: holeNo, state: "Y")}label: {  Image(systemName: "checkmark.square")}
//            }
        }.font(.title2).buttonStyle(.borderless)
    }
}
struct UpDownButton: View {
    @EnvironmentObject var vm: CoreDataViewModel
    var roundNumber: Int
    var holeNo: Int
    var body: some View {
        HStack{
            Text("Up and Down?").font(.body)
            Spacer()
//            switch vm.getUpDown(roundNo: roundNumber, hole: holeNo) {
//            case "Y":
//                Button{vm.updateUpDown(roundNo: roundNumber, hole: holeNo, state: "N")}label: {  Image(systemName: "x.square")}
//                Button{vm.updateUpDown(roundNo: roundNumber, hole: holeNo, state: "Y")}label: {  Image(systemName: "checkmark.square.fill")}
//            case "N":
//                Button{vm.updateUpDown(roundNo: roundNumber, hole: holeNo, state: "N")}label: {  Image(systemName: "x.square.fill")}
//                Button{vm.updateUpDown(roundNo: roundNumber, hole: holeNo, state: "Y")}label: {  Image(systemName: "checkmark.square")}
//            default:
//                Button{vm.updateUpDown(roundNo: roundNumber, hole: holeNo, state: "N")}label: {  Image(systemName: "x.square")}
//                Button{vm.updateUpDown(roundNo: roundNumber, hole: holeNo, state: "Y")}label: {  Image(systemName: "checkmark.square")}
//            }
        }.font(.title2).buttonStyle(.borderless)
    }
}



struct HoleSelectView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    var HoleNumber: Int
    var num: Int = 0
    var change: Int
    var body: some View {
        ZStack{
            if change == HoleNumber {
                RoundedRectangle(cornerRadius: 10)
            } else{
                RoundedRectangle(cornerRadius: 10).stroke()
            }
            Button{
                vm.updateScorecard(index: 0 , newInd: HoleNumber)
            }label: {Text("\(HoleNumber+1)").font(.body)}
        }.padding(.horizontal)
    }
}

