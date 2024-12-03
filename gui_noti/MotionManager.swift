//
//  MotionManager.swift
//  Sensor
//
//  Created by 𝐶. on 2024-11-26.
//

import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private var isCrashDetected = false

    // Crash Detection
    func startDetectingCrash(onCrashDetected: @escaping (Bool) -> Void) {
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = 0.1 // Data update frequency
            motionManager.startAccelerometerUpdates(to: .main) { data, error in
                guard let data = data, error == nil else { return }
                
                // Calculate acceleration
                let acceleration = sqrt(pow(data.acceleration.x, 2) +
                                        pow(data.acceleration.y, 2) +
                                        pow(data.acceleration.z, 2))
                
                // Threshold for detecting shake or crash
                if acceleration > 3.0 && !self.isCrashDetected {
                    self.isCrashDetected = true
                    onCrashDetected(true)
                    
                    // Reset the detection status after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.isCrashDetected = false
                    }
                }
            }
        }
    }
    
    func stopDetectingCrash() {
        motionManager.stopAccelerometerUpdates()
    }
}
