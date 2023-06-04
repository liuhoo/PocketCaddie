//
//  PocketCaddieLinkedApp.swift
//  PocketCaddieLinked
//
//  Created by Alex Liu on 5/30/23.
//

import SwiftUI

@main
struct PocketCaddieLinkedApp: App {
    @StateObject var vm = CoreDataViewModel()
    @StateObject var appState: AppState = AppState()
    var body: some Scene {
        WindowGroup {
            NavigationStack (path: $appState.path){
                HomePageView()
            }.environmentObject(vm).environmentObject(appState)
        }
    }
}
