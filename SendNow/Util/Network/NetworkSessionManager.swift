//
//  NetworkSessionManager.swift
//  SendNow
//
//  Created by 한소희 on 4/1/24.
//

import Foundation
import Alamofire

final class NetworkSessionManager {
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
                switch response.response?.statusCode {
                case 200:
                    completion(.success(value))
                case 400:
                    let error = NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Bad request"])
                    completion(.failure(error))
                case 500:
                    let error = NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "Internal server error"])
                    completion(.failure(error))
                default:
                    let error = NSError(domain: "", code: response.response?.statusCode ?? 0, userInfo: [NSLocalizedDescriptionKey: "Unknown error"])
                    completion(.failure(error))
                }
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
        ).validate(statusCode: 200..<500).responseString { response in
            switch response.response?.statusCode {
            case 200:
                completion(true)
            case 400:
                completion(false)  // 요청 문제
            case 500:
                completion(false)  // 서버 문제
            default:
                completion(false)
            }
        }
    }
    
    func urlDeleteMethod<T: Codable>(path: String, encodeValue: T, completion: @escaping(Bool)->Void) {
        guard let BaseURL = BaseURL,
              let url = URL(string: BaseURL+path) else { return }
        AF.request(url,
                   method: .delete,
                   parameters: encodeValue,
                   encoder: JSONParameterEncoder.default,
                   headers: ["Content-Type": "application/json"]
        ).validate(statusCode: 200..<500).responseString { response in
            switch response.response?.statusCode {
            case 200:
                completion(true)
            case 400:
                completion(false)  // 요청 문제
            case 500:
                completion(false)  // 서버 문제
            default:
                completion(false)
            }
        }
    }
}
