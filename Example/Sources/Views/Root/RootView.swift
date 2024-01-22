//
//  RootView.swift
//  Example
//
//  Created by Megogo on 27.12.2023.
//

import Foundation
import SwiftUI

struct RootView: View {
    let viewModel: RootViewModel

    var body: some View {
        VStack(spacing: 20) {
            Button(
                "Player NO DRM",
                action: { viewModel.onOnlineNonDrm() }
            )
            .buttonStyle(Style())
            Button(
                "Player DRM",
                action: { viewModel.onOnlineDrm() }
            )
            .buttonStyle(Style())
            Button(
                "Offline NO DRM",
                action: { viewModel.onOfflineNonDrm() }
            )
            .buttonStyle(Style())
            Button(
                "Offline DRM",
                action: { viewModel.onOfflineDrm() }
            )
            .buttonStyle(Style())
        }
    }
}

#Preview {
    RootView(viewModel: .default)
}
