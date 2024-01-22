//
//  FileManager+Extenstions.swift
//  Example
//
//  Created by Oleksii Belkevych on 22.01.2024.
//

import Foundation

extension FileManager {
    var home: URL { C.homeDir }

    struct C {
        static let homeDir = URL(fileURLWithPath: NSHomeDirectory())
    }
}
