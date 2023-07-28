//
//  RandomAccessCollection+Extensions.swift
//  SwiftUI-Radio
//
//  Created by Martin Regas on 28/07/2023.
//

import Foundation

extension RandomAccessCollection {
    subscript(index: Index) -> Element? {
        self.indices.contains(index) ? (self[index] as Element) : nil
    }
}
