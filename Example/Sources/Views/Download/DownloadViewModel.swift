//
//  DownloadViewModel.swift
//  Example
//
//  Created by Megogo on 16.01.2024.
//

import Foundation
import SwiftUI

@Observable final class DownloadViewModel: Navigatable {
    enum Stream {
        case noDrm(_ url: URL)
        case drm(_ drm: Drm, url: URL)
    }

    private let stream: Stream
    private let defaults: UserDefaults?
    private let download: DownloadService = .shared
    private let files: FileManager = .default

    init(stream: Stream) {
        self.stream = stream
        switch stream {
            case .noDrm: defaults = UserDefaults(suiteName: "NoDrm")
            case .drm: defaults = UserDefaults(suiteName: "Drm")
        }
        let savedState = State(rawValue: defaults?.integer(forKey: Keys.state) ?? 0) ?? .empty
        state = savedState == .progress ? .failure : savedState
        path = defaults?.string(forKey: Keys.path)
        switch stream {
            case .noDrm: download.noDrmDelegate = self
            case .drm: download.drmDelegate = self
        }
    }

    enum State: Int {
        case empty = 0
        case progress
        case ready
        case failure
    }

    var state: State {
        didSet { defaults?.set(state.rawValue, forKey: Keys.state) }
    }
    var progress: Double = 0

    private var path: String? {
        didSet { defaults?.set(path, forKey: Keys.path) }
    }

    private var fullUrl: URL? {
        guard let path else { return nil }
        return files.home.appendingPathComponent(path)
    }

    func onDownload() {
        switch stream {
            case .noDrm(let url):
                download.loadNoDrm(url)
            case .drm(let drm, let url):
                download.load(drm: drm, url: url)
        }
        state = .progress
    }

    func onPlay() {
        guard let fullUrl else {
            state = .failure
            return
        }
        let view = PlayerView(
            viewModel: .init(url: fullUrl),
            title: "Offline NO DRM"
        )
        let controller = UIHostingController(rootView: view)
        navigation?.pushViewController(controller, animated: true)

    }

    func onRemove() {
        defer { state = .empty }
        guard let fullUrl else { return }
        try? files.removeItem(at: fullUrl)
        defaults?.removeObject(forKey: Keys.state)
        defaults?.removeObject(forKey: Keys.path)
    }

    static let mock = DownloadViewModel(stream: .noDrm(URL(filePath: "!!!")))
}

extension DownloadViewModel: DownloadServiceDelegate {
    func willDownload(to url: URL) {
        path = url.relativePath
        state = .progress
    }

    func didProgress(_ percent: Double) {
        progress = percent
        state = .progress
    }

    func didFinish() {
        state = .ready
    }

    func didFail(_ error: Error) {
        state = .failure
    }
}

private struct Keys {
    static let state = "state"
    static let path = "path"
}
