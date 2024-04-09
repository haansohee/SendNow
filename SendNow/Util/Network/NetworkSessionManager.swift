//
//  NetworkSessionManager.swift
//  SendNow
//
//  Created by 한소희 on 4/1/24.
//

import Foundation
import Alamofire

final class NetworkSessionManager {
    private let postMethod: HTTPMethod = .POST
    private let getMethod: HTTPMethod = .GET
    private let deleteMethod: HTTPMethod = .DELETE
    private let BaseURL = Bundle.main.infoDictionary?["Server_URL"] as? String
    
    func urlGetMethod<T: Codable>(path: String, requestDTO: T.Type, completion: @escaping(Result<T, Error>)->Void) {
        guard let BaseURL = BaseURL,
              let url = URL(string: BaseURL+path) else { return }
        AF.request(url,
                   method: .get,
                   headers: ["Content-Type": "application/json"]
        ).validate(statusCode: 200..<500).responseDecodable(of: requestDTO) { response in
            switch response.result {
            case .success(let value):
                completion(.success(value))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func urlPostMethod<T: Codable>(path: String, encodeValue: T, completion: @escaping(Bool)->Void) {
        guard let BaseURL = BaseURL,
              let url = URL(string: BaseURL+path) else { return }
        AF.request(url,
                   method: .post,
                   parameters: encodeValue,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Content-Type": "application/json"]
        ).validate(statusCode: 200..<500).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    func urlDeleteMethod<T: Codable>(path: String, encodeValue: T, completion: @escaping(Bool)->Void) {
        guard let BaseURL = BaseURL,
              let url = URL(string: BaseURL+path) else { return }
        AF.request(url,
                   method: .post,
                   parameters: encodeValue,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Content-Type": "application/json"]
        ).validate(statusCode: 200..<500).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
}
