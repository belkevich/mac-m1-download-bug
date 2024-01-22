//
//  PlayerViewModel.swift
//  Example
//
//  Created by Megogo on 05.01.2024.
//

import Foundation
import AVFoundation

final class PlayerViewModel {
    private let url: URL
    private let drm: Drm?
    private let keys: [URL: Data]?

    init(url: URL) {
        self.url = url
        drm = nil
        keys = nil
    }

    init(url: URL, drm: Drm?) {
        self.url = url
        self.drm = drm
        keys = nil
    }

    init(url: URL, keys: [URL: Data]) {
        self.url = url
        self.keys = keys
        drm = nil
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

    private lazy var resourceLoader: AVAssetResourceLoaderDelegate? = {
        if let drm {
            return OnlineDrm(drm: drm)
        } else if let keys {
            return OfflineDrm(keys: keys)
        } else {
            return nil
        }
    }()
}
