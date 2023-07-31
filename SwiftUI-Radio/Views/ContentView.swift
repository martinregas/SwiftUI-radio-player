//
//  ContentView.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 18/07/2023.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @EnvironmentObject var storage: StationStorage
    
    @State var selectedIndex: Int = 0
    
    var theme: StationTheme {
        return storage.selectedTheme(selectedIndex)
    }
    
    var body: some View {
        VStack {
            switch storage.state {
            case .idle: playerStationsView
            case .loading: Spinner()
            case .notFound: errorView
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: theme.firstColor))
        .task {
            getStations()
        }
    }
    
    var playerStationsView: some View {
        VStack {
            StationSelectorView(selectedIndex: $selectedIndex)
            PlayerView(selectedIndex: $selectedIndex)
        }
        .frame(maxHeight: .infinity)
    }
    
    var errorView: some View {
        return ErrorView {
            getStations()
        }
    }
    
    func getStations() {
        Task {
            try await storage.getStations()
            selectedIndex = storage.favoriteIndex
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(StationStorage())
    }
}
