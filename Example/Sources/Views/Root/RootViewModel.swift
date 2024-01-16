//
//  RootViewModel.swift
//  Example
//
//  Created by Megogo on 05.01.2024.
//

import Foundation
import SwiftUI
import AVKit

struct RootViewModel {
    static let `default` = RootViewModel()

    var navigation: UINavigationController? {
        let application = UIApplication.shared
        let scene = application.connectedScenes.first
        let delegate = scene?.delegate as? SceneDelegate
        return delegate?.rootController
    }

    func onOnlineNonDrm() {
        let view = OnlineView(
            viewModel: .init(url: C.stream),
            title: "Online NO DRM"
        )
        let controller = UIHostingController(rootView: view)
        navigation?.pushViewController(controller, animated: true)
    }

    func onOnlineDrm() {
        let view = OnlineView(
            viewModel: .init(url: C.drmStream, drm: (C.drmKey, C.drmCert)),
            title: "Online DRM"
        )
        let controller = UIHostingController(rootView: view)
        navigation?.pushViewController(controller, animated: true)
    }

    func onOfflineNonDrm() {

    }

    func onOfflineDrm() {

    }
    
    private struct C {
        static let stream = URL(string: "https://meta.vcdn.biz/e632a708fc98269c4341c76b53d27454_mgg/vod/hls/b/450_900_1350_1500_2000_5000/u_sid/0/o/84771/rsid/2f081b22-39be-4886-bb7c-03dbc70b488b/u_uid/24171371/u_vod/4/u_device/iphone_develop/u_devicekey/_iphone_develop/u_srvc/4981/te/1735568702/u_did/514d1fc660e745ab84f718f00b804ab4/a/0/type.amlst/playlist.m3u8")!
        static let drmStream = URL(string: "https://meta.vcdn.biz/62d8abb6327e9f48e497a7525d44b8cb_mgg/vod/hls/drm/2/b/450_900_1350_1500_2000_5000/u_sid/0/o/84771/rsid/7368dd35-2086-49ae-8b0a-43bb0e85b4b0/u_uid/24171371/u_vod/4/u_device/iphone_develop/u_devicekey/_iphone_develop/u_srvc/4981/te/1735568702/u_did/514d1fc660e745ab84f718f00b804ab4/wtrmrk/0/a/0/type.amlst/playlist.m3u8")!
        static let drmKey = URL(string: "https://drm-ls.megogo.net/fairplay?ref=/62d8abb6327e9f48e497a7525d44b8cb_mgg/vod/hls/drm/2/b/450_900_1350_1500_2000_5000/u_sid/0/o/84771/rsid/7368dd35-2086-49ae-8b0a-43bb0e85b4b0/u_uid/24171371/u_vod/4/u_device/iphone_develop/u_devicekey/_iphone_develop/u_srvc/4981/te/1735568702/u_did/514d1fc660e745ab84f718f00b804ab4/wtrmrk/0/a/0/type.amlst/playlist.m3u8")!
        static let drmCert = URL(string: "https://drm-ls.megogo.net/fairplay/cert.bin?ref=/62d8abb6327e9f48e497a7525d44b8cb_mgg/vod/hls/drm/2/b/450_900_1350_1500_2000_5000/u_sid/0/o/84771/rsid/7368dd35-2086-49ae-8b0a-43bb0e85b4b0/u_uid/24171371/u_vod/4/u_device/iphone_develop/u_devicekey/_iphone_develop/u_srvc/4981/te/1735568702/u_did/514d1fc660e745ab84f718f00b804ab4/wtrmrk/0/a/0/type.amlst/playlist.m3u8")!
    }
}
