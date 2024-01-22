//
//  DownloadService.swift
//  Example
//
//  Created by Oleksii Belkevych on 16.01.2024.
//

import Foundation
import AVFoundation

protocol DownloadServiceDelegate: AnyObject {
    func willDownload(to url: URL)
    func didProgress(_ percent: Double)
    func didFinish()
    func didFail(_ error: Error)
}

final class DownloadService: NSObject {
    static let shared = DownloadService()

    weak var noDrmDelegate: DownloadServiceDelegate?
    weak var drmDelegate: DownloadServiceDelegate?

    private lazy var session = AVAssetDownloadURLSession(
        configuration: .download,
        assetDownloadDelegate: self,
        delegateQueue: .main
    )

    func loadNoDrm(_ url: URL) {
        let asset = AVURLAsset(url: url)
        let task = session.aggregateAssetDownloadTask(
            with: asset,
            mediaSelections: [asset.preferredMediaSelection],
            assetTitle: "NO DRM",
            assetArtworkData: nil
        )
        task?.resume()
    }

    func load(drm: Drm, url: URL) {

    }
}

extension DownloadService: AVAssetDownloadDelegate {
    func urlSession(_ session: URLSession,
                    aggregateAssetDownloadTask: AVAggregateAssetDownloadTask,
                    willDownloadTo location: URL) {
        delegate(for: aggregateAssetDownloadTask)?
            .willDownload(to: location)
    }

    func urlSession(_ session: URLSession,
                    aggregateAssetDownloadTask: AVAggregateAssetDownloadTask,
                    didLoad timeRange: CMTimeRange,
                    totalTimeRangesLoaded loadedTimeRanges: [NSValue],
                    timeRangeExpectedToLoad: CMTimeRange,
                    for mediaSelection: AVMediaSelection) {
        guard case .running = aggregateAssetDownloadTask.state else { return }
        let rawPercent = loadedTimeRanges.reduce(into: 0.0) {
            (result: inout Double, value: NSValue) in
            let actualSeconds = value.timeRangeValue.duration.seconds
            let expectedSeconds = timeRangeExpectedToLoad.duration.seconds
            result += expectedSeconds != 0 ? actualSeconds / expectedSeconds : 0
        }
        let progress = round(rawPercent * 100) / 100
        delegate(for: aggregateAssetDownloadTask)?
            .didProgress(progress)
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {
        if let error = error, error.isNotCancelled {
            delegate(for: task)?.didFail(error)
        } else if case .completed = task.state {
            delegate(for: task)?.didFinish()
        }
    }

    private func delegate(for task: URLSessionTask) -> DownloadServiceDelegate? {
        noDrmDelegate
    }
}

extension URLSessionConfiguration {
    static var download: URLSessionConfiguration {
        let configuration: URLSessionConfiguration = .background(withIdentifier: "Megogo")
        configuration.sessionSendsLaunchEvents = true
        configuration.shouldUseExtendedBackgroundIdleMode = true
        configuration.isDiscretionary = false
        configuration.waitsForConnectivity = true
        return configuration
    }
}

extension Error {
    var isCancelled: Bool {
        let error = self as NSError
        return error.domain == NSURLErrorDomain && error.code == NSURLErrorCancelled
    }

    var isNotCancelled: Bool { !isCancelled }
}
