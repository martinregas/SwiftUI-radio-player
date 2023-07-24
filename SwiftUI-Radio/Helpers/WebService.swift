//
//  WebService.swift
//  Swift-UI-App
//
//  Created by Martin Regas on 05/04/2023.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case decodingError
    case badUrl
}

class Webservice {
    private let path = "https://apimocha.com/radio/all"
    
    func getStations() async throws -> [Station] {
        guard let url = URL(string: path) else {
            throw NetworkError.badUrl
        }

        let (data,response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        let str = String(decoding: data, as: UTF8.self)

        print(str)
        
        guard let stationList = try? JSONDecoder().decode(StationList.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return stationList.station
    }
}
