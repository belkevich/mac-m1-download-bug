//
//  DownloadView.swift
//  Example
//
//  Created by Megogo on 16.01.2024.
//

import Foundation
import SwiftUI

struct DownloadView: View {
    let viewModel: DownloadViewModel

    var body: some View {
        switch viewModel.state {
            case .empty: download
            case .progress: progress
            case .ready: ready
            case .failure: failure
        }
    }
    
    private var download: some View {
        Button(
            "Download",
            action: { viewModel.onDownload() }
        )
        .buttonStyle(Style())
    }
    
    private var progress: some View {
        VStack(spacing: 50) {
            Text(String(Int(viewModel.progress * 100)) + "%")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.accentColor)
            key
        }
    }
    
    private var ready: some View {
        VStack(spacing: 50) {
            Button(
                "Play",
                action: { viewModel.onPlay() }
            )
            .buttonStyle(Style())
            Button(
                "Remove",
                action: { viewModel.onRemove() }
            )
            .buttonStyle(Style())
            key
        }
    }
    
    private var failure: some View {
        VStack(spacing: 50) {
            Text("Failure")
                .font(.system(size: 60, weight: .bold))
                .foregroundColor(.accentColor)
            Button(
                "Remove",
                action: { viewModel.onRemove() }
            )
            .buttonStyle(Style())
        }
    }

    private var key: some View {
        Text(keyText)
            .font(.system(size: 35, weight: .bold))
            .foregroundColor(.launch)
    }

    private var keyText: String {
        switch viewModel.key {
            case .empty: return "No DRM keys"
            case .loaded: return "DRM keys loaded"
            case .waiting: return "Waiting for DRM keys"
        }
    }
}

#Preview {
    DownloadView(viewModel: .mock)
}
