//
//  SwiftUI_RadioApp.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 18/07/2023.
//

import SwiftUI

@main
struct SwiftUI_RadioApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(StationStorage())
        }
    }
}
