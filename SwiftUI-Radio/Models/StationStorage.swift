//
//  StationStorage.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 18/07/2023.
//

import Foundation
import SwiftUI

enum LoadingState {
    case idle
    case notFound
    case loading
}

@MainActor class StationStorage: ObservableObject {
    @Published var stations: [Station] = []
    @Published var state: LoadingState = .loading
    
    @AppStorage("favorite") var favoriteStation: Station? = nil

    var webService: Webservice
    
    init() {
        webService = .init()
    }
    
    func getStations() async throws {
        state = .loading

        do {
            stations = try await webService.getStations()
            orderStationsByFavorite()
            state = stations.isEmpty ? .notFound : .idle
        } catch(let error) {
            print(error)
            state = .notFound
        }
    }
    
    private func orderStationsByFavorite() {
        if let favoriteStation = favoriteStation, let favoriteIndex = stations.firstIndex(of: favoriteStation) {
            stations.swapAt(favoriteIndex, 0)
        }
    }

    func selectedTheme(_ index: Int) -> StationTheme {
        if stations.isEmpty { return Utilities.defaultTheme }
        return stations[index].theme
    }
    
    func checkIfStationIsFavorite(index: Int) -> Bool {
        return favoriteStation == stations[index]
    }
    
    func markStationAsFavorite(index: Int) {
        favoriteStation = checkIfStationIsFavorite(index: index) ? nil : stations[index]
    }
}
