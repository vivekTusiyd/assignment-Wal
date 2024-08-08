//
//  Network.swift
//  Walmart_assignment
//
//  Created by Vivek Tusiyad on 08/08/24.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()
    private var monitor: NWPathMonitor?
    private let queue = DispatchQueue.global()
    
    var isConnected: Bool = false
    
    private init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
            print("Network status: \(path.status == .satisfied ? "Connected" : "Disconnected")")
        }
        monitor?.start(queue: queue)
    }
    
    
    func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
    }
}
