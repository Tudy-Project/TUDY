//
//  SubwayDataManager.swift
//  TUDY
//
//  Created by neuli on 2022/05/30.
//

import UIKit

class SubwayDataManager {
    
    // MARK: - Properties
    private let authenticationKey = "624f6470666f79613236517268426e"
    private lazy var subwayLineInfoURL: String = {
        return "http://openapi.seoul.go.kr:8088/\(authenticationKey)/json/SearchSTNBySubwayLineInfo/1/1000/"
    }()
    
    // MARK: - methods
    func fetchSubway(completion: @escaping (Result<[Subway], Error>) -> Void) {
        
        guard let url = URL(string: subwayLineInfoURL) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("DEBUG: 지하철 데이터 fetch 에러" + error.localizedDescription)
                completion(.failure(NetworkError.transportError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("http 통신 실패")
                completion(.failure(NetworkError.serverError))
                return
            }
            
            guard let data = data else {
                print("데이터 fetch 실패")
                completion(.failure(NetworkError.missinfDataError))
                return
            }
            
            if let subwayList = self.jsonDecoder(data: data) {
                completion(.success(subwayList))
            } else {
                completion(.failure(NetworkError.decodingError))
            }

        }.resume()
    }
    
    func jsonDecoder(data: Data) -> [Subway]? {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(SubwayResult.self, from: data)
            let subwayDataList = decodeData.SearchSTNBySubwayLineInfo.row
            
            return makeSubwayList(subwayDataList)
        } catch {
            print("DEBUG: 지하철 decode 실패")
            return nil
        }
    }
    
    func makeSubwayList(_ subwayDataList: [SubwayData]) -> [Subway] {
        var dict: [String: [String]] = [:]
        var subwayList: [Subway] = []
        
        for subway in subwayDataList {
            dict[subway.station, default: []].append(subway.line)
        }
        for subway in dict {
            subwayList.append(Subway(station: subway.key, lines: subway.value))
        }
        return subwayList
    }
}
