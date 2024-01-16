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
                "Online NO DRM",
                action: { viewModel.onOnlineNonDrm() }
            )
            .buttonStyle(Style())
            Button(
                "Online DRM",
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
    
    struct Style: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(.system(size: 38, weight: .bold))
                .foregroundColor(.accentColor)
                .frame(width: 300)
                .padding()
                .background(Color.launch)
                .cornerRadius(15)
        }
    }
}

#Preview {
    RootView(viewModel: .default)
}
