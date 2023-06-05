//
//  RoundAnalysisView.swift
//  PocketCaddieLinked
//
//  Created by Alex Liu on 6/4/23.
//

import SwiftUI

struct RoundCollectionView: View {
    @EnvironmentObject var vm: CoreDataViewModel
    
    var body: some View {
        List(){
            ForEach(vm.scorecards){ round in
                NavigationLink {
                    RoundDisplayView(currRound: round)
                } label: {
                    Text("\(round.descrip ?? "no name given")")
                }.navigationTitle("Completed Rounds")
            }
        }
    }
}

struct RoundDisplayView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    let currRound: ScorecardModel
    var body: some View {
        
        VStack{
            LazyVGrid(columns: [GridItem(),GridItem(),GridItem()]){
                
                ForEach(vm.holes) { hole in
                    HoleDisplayView(currHole: hole)
                }
                
            }.padding().cornerRadius(20).overlay(RoundedRectangle(cornerRadius: 10).inset(by: -10).strokeBorder(lineWidth: 1 ).padding(.all)).navigationTitle("\(currRound.descrip ?? "") Scorecard")
            HStack{
                
                Text("  Analysis")
                    .font(.title)
                    .fontWeight(.bold).frame(alignment: .leading)
                Spacer()
            }
            Spacer()
        }
    }
}


struct HoleDisplayView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    let currHole: HoleModel
    var body: some View {
        
        
        ZStack{
            RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 1)
            
            VStack{
                Spacer()
                HStack{
                    Text(" Hole:")
                    Spacer()
                    Text("\(currHole.holeNo+1) ")
                }
                
                Text("-")
                
                HStack{
                    Text(" Score:")
                    Spacer()
                    Text("\(currHole.score) ")
                }
            
                Text("-")
                
                HStack{
                    Text(" Par:")
                    Spacer()
                    Text("\(currHole.par) ")
                }
                
                Spacer()
            }
        }
        
        
    }
}

struct KeyView: View{
    var body: some View {
        VStack{
            Text("Hole")
            Text("-")
            Text("Score")
            Text("-")
            Text("Par")
        }.font(.caption2)
    }
}



    
