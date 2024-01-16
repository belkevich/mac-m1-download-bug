//
//  OnlineViewModel.swift
//  Example
//
//  Created by Megogo on 05.01.2024.
//

import Foundation
import AVFoundation

final class OnlineViewModel {
    private let url: URL
    private let drm: Drm?

    init(url: URL, drm: Drm? = nil) {
        self.url = url
        self.drm = drm
    }

    lazy var player = AVPlayer(playerItem: item)

    private var item: AVPlayerItem {
        .init(asset: asset)
    }

    private var asset: AVURLAsset {
        let asset = AVURLAsset(url: url)
        if let resourceLoader {
            asset.resourceLoader.setDelegate(resourceLoader, queue: .main)
        }
        return asset
    }

    private lazy var resourceLoader: OnlineDrm? = {
        guard let drm else { return nil }
        return OnlineDrm(drm: drm)
    }()
}
