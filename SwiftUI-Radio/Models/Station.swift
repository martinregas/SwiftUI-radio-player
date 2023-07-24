//
//  Station.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 18/07/2023.
//

import Foundation

struct StationList: Codable {
    let station: [Station]
    
    private enum CodingKeys: String, CodingKey {
        case station
    }
}

struct Station: Codable, Identifiable, Hashable, Equatable {
    var id = UUID()
    let name: String
    let streamURL: String
    let imageURL: String
    let desc: String
    let theme: StationTheme
    
    private enum CodingKeys: String, CodingKey {
        case name
        case streamURL
        case imageURL
        case desc
        case theme
    }
    
    static func ==(lhs: Station, rhs: Station) -> Bool {
        return lhs.name == rhs.name
    }
}

struct StationTheme: Codable, Identifiable, Hashable {
    var id = UUID()
    var firstColor: String
    var secondColor: String
    var thirdColor: String
    
    private enum CodingKeys: String, CodingKey {
        case firstColor
        case secondColor
        case thirdColor
    }
}
