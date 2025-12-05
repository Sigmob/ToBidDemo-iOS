//
//  TBNetwork.swift
//  WindMillSDK
//
//  Created by Codi on 2025/7/22.
//


import Foundation

typealias TBHTTPCompletion = (Data?, HTTPURLResponse?, Error?) -> Void

class NetworkManager {
    static let shared = NetworkManager()
    private let session: URLSession
    private let baseHeaders: [String: String]
    
    // 支持依赖注入的初始化方法
    init(session: URLSession = .shared,
         baseHeaders: [String: String] = [:]) {
        self.session = session
        self.baseHeaders = baseHeaders
    }
    
    private init() {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 5
        self.session = URLSession(configuration: config)
        self.baseHeaders = [:]
    }
    
    // GET请求 - 新增retryCount参数
    func get(url: String, queryParams: [String: String]? = nil, headers: [String: String]? = nil, retryCount: Int = 0, completion: @escaping TBHTTPCompletion) -> Void {
        return self.request(url, method: .GET, queryParams: queryParams, headers: headers, retryCount: retryCount, completion: completion)
    }
    
    // POST请求 - 新增retryCount参数
    func post(url: String, queryParams: [String: String]? = nil, headers: [String: String]? = nil, retryCount: Int = 0, completion: @escaping TBHTTPCompletion) -> Void {
        return self.request(url, method: .POST, queryParams: queryParams, headers: headers, retryCount: retryCount, completion: completion)
    }
}

extension NetworkManager {
    
    // POST请求 - 新增retryCount参数
    private func request(_ url: String, method: TBHTTPMethod,  queryParams: [String: String]? = nil, headers: [String: String]? = nil, retryCount: Int = 0, completion: @escaping TBHTTPCompletion) -> Void {
        do {
            let request = try self.buildRequest(url: url, method: method, queryParams: queryParams, headers: headers)
            return dataTaskWithRetry(request: request, retryCount: retryCount, completion: completion)
        } catch {
            completion(nil, nil, error)
        }
    }
    
    
    // 新增：请求构建器
    private func buildRequest(url: String,
                              method: TBHTTPMethod,
                              queryParams: [String: String]?,
                              headers: [String: String]?) throws -> URLRequest {
        guard var components = URLComponents(string: url) else {
            throw NetworkError.invalidURL
        }
        var queryItem = components.queryItems
        if let items = queryParams {
            var queryValues = items.map { URLQueryItem(name: $0.key, value: $0.value) }
            components.queryItems?.forEach { queryValues.append($0) }
            queryItem = queryValues
        }
        components.queryItems = queryItem
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = baseHeaders.merging(headers ?? [:]) { $1 }
        request.timeoutInterval = 5
        return request
    }
    
    /// 带重试逻辑的数据任务
    private func dataTaskWithRetry(request: URLRequest, retryCount: Int, completion:  @escaping TBHTTPCompletion) -> Void {
        dataTask(request: request) { data, response, error in
            if (retryCount > 0 && self.shouldRetry(for: error)) {
                return self.dataTaskWithRetry(request: request, retryCount: retryCount - 1, completion: completion)
            }
            completion(data, response, error)
        }
    }
    
    /// 数据任务
    private func dataTask(request: URLRequest, completion: @escaping TBHTTPCompletion) {
        session.dataTask(with: request) { data, response, error in
            if error != nil {
                DispatchQueue.main.async {
                    completion(nil, nil, error)
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(nil, nil, NetworkError.invalidResponse)
                }
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    completion(nil, nil, NetworkError.httpError(statusCode: httpResponse.statusCode))
                }
                return
            }
            DispatchQueue.main.async {
                completion(data, httpResponse, nil)
            }
        }.resume()
    }
    
    
    /// 判断是否应该重试
    private func shouldRetry(for error: Error?) -> Bool {
        guard let errorValue = error else {
            return false
        }
        if let networkError = errorValue as? NetworkError {
            switch networkError {
            case .httpError(let statusCode):
                // 对5xx服务器错误进行重试
                return statusCode >= 500 && statusCode < 600
            case .invalidResponse:
                return true
            default:
                return false
            }
        }
        // 对网络连接错误进行重试
        return (errorValue as NSError).domain == NSURLErrorDomain
    }
}

enum NetworkError: Error {
    case invalidURL
    case parameterEncodingFailed
    case invalidResponse
    case httpError(statusCode: Int)
    case noData
}

// 新增：HTTP方法枚举
enum TBHTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
}
