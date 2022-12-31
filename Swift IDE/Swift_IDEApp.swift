//
//  Swift_IDEApp.swift
//  Swift IDE
//
//  Created by Murad Talibov on 05.12.22.
//

import SwiftUI

@main
struct Swift_IDEApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ViewModel())
        }
    }
}
