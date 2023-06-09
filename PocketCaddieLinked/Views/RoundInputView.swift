//
//  RoundInputView.swift
//  PocketCaddieLinked
//
//  Created by Alex Liu on 6/4/23.
//

import SwiftUI




struct InfoView:  View{
    
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
                        speed = 9
                    }
                }
            }
            
            NavigationLink(destination: CollectDataView(currRound: vm.scorecards[0])){BeginRoundView()}.navigationTitle("Customize Round").simultaneousGesture(TapGesture().onEnded{
                            vm.addScorecard(name: id, numHoles: Int16(speed), advPutt: advancedPutting)
                            vm.getSpecHoles(scorecard: vm.scorecards[0])
                            vm.collectPutts(hole: vm.holes[0])
                
            // CREATE ROUND IN THE MAIN PAGE AND THEN UPDATE ROUND IN THE INPUT PAGE
                        })
            
        }
        
        
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
    }
}


