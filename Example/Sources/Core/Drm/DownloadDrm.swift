//
//  DownloadDrm.swift
//  Example
//
//  Created by Megogo on 22.01.2024.
//

import Foundation
import AVFoundation


final class DownloadDrm: NSObject, AVAssetResourceLoaderDelegate {
    private let loader = URLLoader()
    private let keyCallback: (URL, Data) -> Void

    init(callback: @escaping (URL, Data) -> Void) {
        keyCallback = callback
        super.init()
    }

    var drm: Drm?

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
        guard let drm else { return }
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
        let options = [AVAssetResourceLoadingRequestStreamingContentKeyRequestRequiresPersistentKey: true]
        return try? loadingRequest.streamingContentKeyRequestData(
            forApp: certificate,
            contentIdentifier: contentId,
            options: options
        )
    }

    private func loadKey(request: AVAssetResourceLoadingRequest,
                         context: Data) {
        guard let drm,
              let url = request.request.url else { return }
        loader.load(url: drm.key, body: context) {
            [weak self] in
            switch $0 {
                case .success(let data):
                    guard let key = try? request.persistentContentKey(fromKeyVendorResponse: data) else {
                        request.finishLoading(with: nil)
                        break
                    }
                    request.contentInformationRequest?.contentType = AVStreamingKeyDeliveryPersistentContentKeyType
                    request.dataRequest?.respond(with: key)
                    request.finishLoading()
                    self?.keyCallback(url, key)
                case .failure(let error):
                    request.finishLoading(with: error)
            }
        }
    }
}
