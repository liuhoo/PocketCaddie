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
            LazyVGrid(columns: [GridItem()]){
                
            }
            ForEach(vm.scorecards){ round in
                
                
                
                NavigationLink (destination: RoundDisplayView(currRound: round)) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 10).strokeBorder(lineWidth: 1)
                        Text("\(round.descrip ?? "no name given")")
                    }.aspectRatio(8/1, contentMode: .fit)
                }.padding(.horizontal).navigationTitle("Completed Rounds").simultaneousGesture(TapGesture().onEnded{
                    vm.getSpecHoles(scorecard: round)
                })
            }
        }
        
    }
}

struct RoundDisplayView: View{
    @EnvironmentObject var vm: CoreDataViewModel
    let currRound: ScorecardModel
    
    var body: some View {
        VStack{
            ScrollView(.vertical){
                
                
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())],
                          alignment: .center, spacing: 10){
                    
                    ForEach(vm.holes) { hole in
                        HoleDisplayView(currHole: hole)
                    }
                    
                }.navigationTitle("\(currRound.descrip ?? "") Scorecard")
                HStack{
                    
                    Text("  Analysis")
                        .font(.title)
                        .fontWeight(.bold).frame(alignment: .leading)
                    Spacer()
                }
            }.padding(.all).frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
        }
        
        
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



    
