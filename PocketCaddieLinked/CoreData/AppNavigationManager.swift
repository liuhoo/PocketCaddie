//
//  AppNavigationManager.swift
//  PocketCaddieLinked
//
//  Created by Alex Liu on 6/4/23.
//


import SwiftUI
class AppState: ObservableObject {
    @Published var path = NavigationPath()
    func popToRoot(){
        path.removeLast(path.count)
    }
}
