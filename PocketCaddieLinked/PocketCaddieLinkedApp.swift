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
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                HomePageView()
            }.environmentObject(vm)
        }
    }
}
