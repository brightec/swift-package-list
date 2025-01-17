//
//  File.swift
//  
//
//  Created by Dave Thompson on 16/03/2023.
//

import Foundation

extension FileManager {
    func createDirectoryIfNotExists(atPath path: String) throws {
        guard !fileExists(atPath: path) else { return }
        try createDirectory(atPath: path, withIntermediateDirectories: true)
    }
}
