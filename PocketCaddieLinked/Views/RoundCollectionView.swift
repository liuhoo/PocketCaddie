//
//  RoundCollectionView.swift
//  PocketCaddieLinked
//
//  Created by Alex Liu on 7/19/23.
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
