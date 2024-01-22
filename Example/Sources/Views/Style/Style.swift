//
//  Style.swift
//  Example
//
//  Created by Megogo on 22.01.2024.
//

import Foundation
import SwiftUI

struct Style: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 38, weight: .bold))
            .foregroundColor(.accentColor)
            .frame(width: 250)
            .padding()
            .background(Color.launch)
            .cornerRadius(15)
    }
}
