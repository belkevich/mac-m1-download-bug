//
//  Hex.swift
//  Example
//
//  Created by Megogo on 05.01.2024.
//

import Foundation

func hexData(with hexString: String) -> Data {
    var data = Data()
    var hexString = hexString
    while hexString.utf8.count > 0 {
        let length = min(hexString.utf8.count, 2)
        let startIndex = hexString.startIndex
        let offsetIndex = hexString.index(hexString.startIndex, offsetBy: length)
        let endIndex = hexString.endIndex
        let substring = hexString[startIndex ..< offsetIndex]
        let bytesString = String(substring)
        var bytes: UInt64 = 0
        if Scanner(string: bytesString).scanHexInt64(&bytes) {
            var shortBytes = UInt8(bytes)
            data.append(&shortBytes, count: 1)
        }
        hexString = String(hexString[offsetIndex ..< endIndex])
    }
    return data
}
