//
//  NetworkProvider.swift
//  WeatherForToday
//
//  Created by Azapsh on 30.03.2026.
//

import Foundation
import Alamofire

protocol NetworkProvider {
    func send<R: APIRequest>(_ request: R) async throws -> R.Response
}

protocol APIRequest {
    associatedtype Response: Decodable
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: Parameters? { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? { get }
}

extension APIRequest {
    var method: HTTPMethod { .get }
    var parameters: Parameters? { nil }
    var encoding: ParameterEncoding { URLEncoding.default }
    var headers: HTTPHeaders? { nil }
}

final class AlamofireNetworkProvider: NetworkProvider {
    private let baseURL: String
    private let session: Session
    private let decoder: JSONDecoder
    init(baseURL: String,
         session: Session = .default,
         decoder: JSONDecoder = JSONDecoder()) {
        self.baseURL = baseURL
        self.session = session
        self.decoder = decoder
    }
    func send<R: APIRequest>(_ request: R) async throws -> R.Response {
        let endpoint = baseURL + request.path
        guard let url = URL(string: endpoint) else {
            throw AFError.invalidURL(url: endpoint)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        if let headers = request.headers {
            headers.forEach { urlRequest.setValue($0.value, forHTTPHeaderField: $0.name) }
        }
        let encoded = try request.encoding.encode(urlRequest, with: request.parameters)
        if let full = encoded.url?.absoluteString {
            print("url>> \(full)")
        } else {
            print("url>> \(endpoint)")
        }

        let result = await session.request(encoded)
        .validate(statusCode: 200..<300)
        .serializingDecodable(R.Response.self, decoder: decoder)
        .response
        switch result.result {
        case .success(let model):
            return model
        case .failure(let error):
            throw error
        }
    }
}
