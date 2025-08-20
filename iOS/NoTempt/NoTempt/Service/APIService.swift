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
        case invalidCredentials
        case tokenExpired
        case unknownError
    }
    
    // 로그인 API 호출
    func testPost() {
        let url1 = URL(string: "http://jsonplaceholder.typicode.com/posts")!
        let url2 = URL(string: "https://jsonplaceholder.typicode.com/posts")!
              
        var urlRequest1 = URLRequest(url: url1)
        urlRequest1.httpMethod = "POST"
        urlRequest1.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest1.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var urlRequest2 = URLRequest(url: url2)
        urlRequest2.httpMethod = "POST"
        urlRequest2.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest2.setValue("application/json", forHTTPHeaderField: "Accept")
        
        URLSession.shared.dataTask(with: urlRequest1) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 401 {
                    
                    return
                } else if !(200...299).contains(httpResponse.statusCode) {
                    
                    return
                }
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TestPostResponse.self, from: data)
                print("decodedResponse1: \(decodedResponse.id)")
            } catch {
                
            }
        }.resume()
        
        URLSession.shared.dataTask(with: urlRequest2) { data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 401 {
                    
                    return
                } else if !(200...299).contains(httpResponse.statusCode) {
                    
                    return
                }
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(TestPostResponse.self, from: data)
                print("decodedResponse2: \(decodedResponse.id)")
            } catch {
                
            }
        }.resume()
    }
    
    // 로그인 API 호출
    func login(request: LoginRequest, completion: @escaping (Result<LoginResponse, APIError>) -> Void) {
        guard let url = URL(string: "\(serverAddress)\(loginSubPath)") else {
            completion(.failure(.invalidURL))
            return
        }
        print("login url: \(url)")
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        do {
            let jsonData = "email=\(request.email)&password=\(request.password)".data(using: .utf8)
            urlRequest.httpBody = jsonData
        } catch {
            completion(.failure(.decodingError))
            return
        }
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 401 {
                    DispatchQueue.main.async { completion(.failure(.invalidCredentials)) }
                    return
                } else if !(200...299).contains(httpResponse.statusCode) {
                    DispatchQueue.main.async { completion(.failure(.unknownError)) }
                    return
                }
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                DispatchQueue.main.async { completion(.success(decodedResponse)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.decodingError)) }
            }
        }.resume()
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
    
    // 토큰 재발급 요청
    func refreshToken(completion: @escaping (Result<LoginResponse, APIError>) -> Void) {
        guard let url = URL(string: "\(serverAddress)\(refreshTokenSubPath)") else {
            completion(.failure(.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        if let token = JWTManager.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            completion(.failure(.authError))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(.failure(.noData)) }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async { completion(.failure(.tokenExpired)) } // 401 오류 시 토큰 만료로 간주
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                DispatchQueue.main.async { completion(.success(decodedResponse)) }
            } catch {
                DispatchQueue.main.async { completion(.failure(.decodingError)) }
            }
        }.resume()
    }
}
