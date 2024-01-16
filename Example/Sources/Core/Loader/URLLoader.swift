//
//  URLLoader.swift
//  Example
//
//  Created by Megogo on 05.01.2024.
//

import Foundation

final class URLLoader {
    private let session = URLSession(
        configuration: .default,
        delegate: nil,
        delegateQueue: .main
    )

    func load(url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        session.dataTask(with: url) {
            (data: Data?, _: URLResponse?, error: Error?) -> Void in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    func load(url: URL, body: Data, completion: @escaping (Result<Data, Error>) -> Void) {
        let request = request(url: url, body: body)
        session.dataTask(with: request) {
            (data: Data?, _: URLResponse?, error: Error?) -> Void in
            if let data = data {
                completion(.success(data))
            } else if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }

    private func request(url: URL, body: Data) -> URLRequest {
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 15
        )
        request.httpMethod = "POST"
        request.httpBody = body
        request.allHTTPHeaderFields?["Content-Type"] = "application/octet-stream"
        return request
    }
}
