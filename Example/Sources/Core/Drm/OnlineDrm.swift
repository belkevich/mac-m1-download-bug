//
//  OnlineDrm.swift
//  Example
//
//  Created by Megogo on 05.01.2024.
//

import Foundation
import AVFoundation

final class OnlineDrm: NSObject, AVAssetResourceLoaderDelegate {
    private let drm: Drm
    private let loader = URLLoader()

    init(drm: Drm) {
        self.drm = drm
        super.init()
    }

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader,
                        shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        guard loadingRequest.request.url?.scheme == "skd" else { return false }
        handle(request: loadingRequest)
        return true
    }

    func resourceLoader(_ resourceLoader: AVAssetResourceLoader,
                        shouldWaitForRenewalOfRequestedResource renewalRequest: AVAssetResourceRenewalRequest) -> Bool {
        guard renewalRequest.request.url?.scheme == "skd" else { return false }
        handle(request: renewalRequest)
        return true
    }

    private func handle(request: AVAssetResourceLoadingRequest) {
        loader.load(url: drm.cert) {
            [weak self] in
            switch $0 {
                case .success(let data):
                    if let context = self?.createContext(for: request, certificate: data) {
                        self?.loadKey(request: request, context: context)
                    } else {
                        request.finishLoading(with: nil)
                    }
                case .failure(let error):
                    request.finishLoading(with: error)
            }
        }
    }

    private func createContext(for loadingRequest: AVAssetResourceLoadingRequest,
                               certificate: Data) -> Data? {
        guard let id = loadingRequest.request.url?.host else { return nil }
        let contentId = hexData(with: id).base64EncodedData()
        return try? loadingRequest.streamingContentKeyRequestData(
            forApp: certificate,
            contentIdentifier: contentId
        )
    }

    private func loadKey(request: AVAssetResourceLoadingRequest,
                         context: Data) {
        loader.load(url: drm.key, body: context) {
            switch $0 {
                case .success(let data):
                    request.dataRequest?.respond(with: data)
                    request.finishLoading()
                case .failure(let error):
                    request.finishLoading(with: error)
            }
        }
    }
}
