//
//  StationRepository.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 05/04/2023.
//

import Foundation

enum DataError: Error {
    case fileNotFound
    case readError
    case decodingError
}

class StationRepository {
    private let filename = "stations"

    func getStations() async throws -> [Station] {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw DataError.fileNotFound
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw DataError.readError
        }
        
        guard let stationList = try? JSONDecoder().decode(StationList.self, from: data) else {
            throw DataError.decodingError
        }
        
        return stationList.station
    }
}
