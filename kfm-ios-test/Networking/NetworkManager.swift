//
//  NetworkManager.swift
//  kfm-ios-test
//
//  Created by Yudha on 23/12/21.
//

import Foundation
import Alamofire
import Combine
import Network

class NetworkManager {
    static let shared: NetworkManager = NetworkManager()
    let apiURL = URLs.baseURL
    
    private var monitor: NWPathMonitor
    private var queue = DispatchQueue.global()
    @Published var isInternetConnected = false
    
    lazy var checkInternetConnected: AnyPublisher<Bool, Never> = {
        $isInternetConnected
            .eraseToAnyPublisher()
    }()
    
    private init() {
        self.monitor = NWPathMonitor()
        self.queue = DispatchQueue.global(qos: .background)
        self.monitor.start(queue: queue)
    }
    
    func getForecast(parameters: [String: Any] = [:]) -> Future<Weather, Error> {
        return Future { promise in
            AF.request(self.apiURL + URLs.Request.forecast, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: nil, interceptor: nil, requestModifier: nil)
                .responseDecodable(of: Weather.self) { responseData in
                    switch responseData.result {
                    case .success(let value):
                        promise(.success(value))
                        
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
        }
    }
    
    func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Internet connected")
                self.isInternetConnected = true
            }
            else {
                print("No internet")
                self.isInternetConnected = false
            }
        }
    }
    
    func stopNetworkMonitoring() {
        monitor.cancel()
    }
}
