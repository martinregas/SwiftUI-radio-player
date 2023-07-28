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
        guard let selectedStation = stations[index] else { return Utilities.defaultTheme }
        return selectedStation.theme
    }
    
    func checkIfStationIsFavorite(index: Int) -> Bool {
        guard let selectedStation = stations[index] else { return false }
        return favoriteStation == selectedStation
    }
    
    func markStationAsFavorite(index: Int) {
        favoriteStation = checkIfStationIsFavorite(index: index) ? nil : stations[index]
    }
}
