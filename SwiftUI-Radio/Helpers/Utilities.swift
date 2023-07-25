//
//  Utilities.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 20/07/2023.
//

import Foundation

class Utilities {
    private static var timeHMSFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = [.pad]
        return formatter
    }()
    
    static func formatSecondsToHMS(_ seconds: Double) -> String {
        guard !seconds.isNaN,
            let text = timeHMSFormatter.string(from: seconds) else {
                return "00:00"
        }
        return text
    }
    
    static var defaultTheme: StationTheme {
        return .init(firstColor: "#F2EFE4", secondColor: "#1D180C", thirdColor: "#000000")
    }
}
