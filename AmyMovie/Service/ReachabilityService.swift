//
//  ReachabilityService.swift
//  AmyMovie
//
//  Created by Xiaofen Liu on 5/27/21.
//

import Network

protocol ReachabilityServiceType {

    // This property must be thread-safe
    var isNetworkAvailable: Bool { get }
}


class ReachabilityService: ReachabilityServiceType {
    private var _isInternetAvailable: Bool = true
    private let isolationQueue = DispatchQueue(label: "com.amyMovie.reachability", attributes: .concurrent)
    
    private(set) var isNetworkAvailable: Bool { //public getter, private setter
        get {
            return isolationQueue.sync {
                _isInternetAvailable
            }
        }
        set {
            isolationQueue.async(flags: .barrier) {[weak self] in
                self?._isInternetAvailable = newValue
            }
        }
    }
    
    private let monitor = NWPathMonitor()
    
    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            if path.status == .satisfied {
                self?.isNetworkAvailable = true
            } else {
                self?.isNetworkAvailable = false
            }
        }
        monitor.start(queue: DispatchQueue.global(qos: .background))
    }
}
