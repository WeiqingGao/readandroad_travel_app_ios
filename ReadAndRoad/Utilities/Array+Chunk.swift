//
//  Array+Chunk.swift
//  ReadAndRoad
//
//  Created by Weiqing Gao on 12/10/25.
//

import Foundation

extension Array {
    /// Splits the array into chunks of a given size.
    func chunked(into size: Int) -> [[Element]] {
        guard size > 0 else { return [] }

        var result: [[Element]] = []
        var index = 0

        while index < count {
            let nextIndex = Swift.min(index + size, count)
            result.append(Array(self[index..<nextIndex]))
            index = nextIndex
        }

        return result
    }
}
