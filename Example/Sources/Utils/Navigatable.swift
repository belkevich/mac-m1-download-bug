//
//  Navigatable.swift
//  Example
//
//  Created by Megogo on 22.01.2024.
//

import Foundation
import SwiftUI

protocol Navigatable {
    var navigation: UINavigationController? { get }
}

extension Navigatable {
    var navigation: UINavigationController? {
        let application = UIApplication.shared
        let scene = application.connectedScenes.first
        let delegate = scene?.delegate as? SceneDelegate
        return delegate?.rootController
    }
}
