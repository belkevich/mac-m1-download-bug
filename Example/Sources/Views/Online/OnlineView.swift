//
//  OnlineView.swift
//  Example
//
//  Created by Megogo on 15.01.2024.
//

import Foundation
import SwiftUI
import AVKit

struct OnlineView: UIViewControllerRepresentable {
    let viewModel: OnlineViewModel
    let title: String

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = true
        controller.title = title
        controller.player = viewModel.player
        controller.player?.play()
        return controller
     }

     func updateUIViewController(_ uiViewController: AVPlayerViewController, 
                                 context: Context) {
        // does nothing
     }
}
