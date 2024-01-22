//
//  OfflineDrm.swift
//  Example
//
//  Created by Megogo on 22.01.2024.
//

import Foundation

import AVFoundation

final class OfflineDrm: NSObject, AVAssetResourceLoaderDelegate {
    private let keys: [URL: Data]

    init(keys: [URL: Data]) {
        self.keys = keys
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
        guard let url = request.request.url,
              let key = keys[url] else {
            return
        }
        request.contentInformationRequest?.contentType = AVStreamingKeyDeliveryPersistentContentKeyType
        request.dataRequest?.respond(with: key)
        request.finishLoading()
    }
}
