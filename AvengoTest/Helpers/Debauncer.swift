//
//  Debauncer.swift
//  AvengoTest
//
//  Created by Rostyslav Bodnar on 07.06.2021.
//

import Foundation

/// public class
public class Debouncer {
    
    private let timeInterval: TimeInterval
    private var timer: Timer?
    var handler: Handler?

    typealias Handler = () -> Void
    
    init(timeInterval: TimeInterval) {
        self.timeInterval = timeInterval
    }
    
    /// restart timer
    public func renewInterval() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval,
                                     repeats: false,
                                     block: { [weak self] (timer) in
            self?.timeIntervalDidFinish(for: timer)
        })
    }
    
    @objc func timeIntervalDidFinish(for timer: Timer) {
        guard timer.isValid else {
            return
        }
        
        handler?()
        handler = nil
    }
}
