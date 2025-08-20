//
//  APIService.swift
//  NoTempt
//
//  Created by byeongho park on 8/20/25.
//

import Foundation

class APIService {
    static let shared = APIService()
    private init() {}

    enum APIError: Error {
        case invalidURL
        case noData
        case decodingError
        case authError
        case unknownError
    }

    func request<T: Decodable>(url: URL, method: String, completion: @escaping (Result<T, APIError>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        // JWT 토큰이 있으면 헤더에 추가
        if let token = JWTManager.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 401 {
                DispatchQueue.main.async { completion(.failure(.authError)) }
                return
            }

            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async { completion(.success(decodedData)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.decodingError)) }
            }
        }.resume()
    }
}
