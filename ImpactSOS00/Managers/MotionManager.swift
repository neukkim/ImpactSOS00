import Foundation
import CoreMotion

class MotionManager: ObservableObject {
    private let motion = CMMotionManager()
    private let queue = OperationQueue()
    
    @Published var lastImpact: Date?
    
    var thresholdG: Double = 1.5
    
    init() {
        motion.deviceMotionUpdateInterval = 0.02
    }
    
    func start() {
        guard motion.isDeviceMotionAvailable else { return }
        motion.startDeviceMotionUpdates(to: queue) { [weak self] data, _ in
            guard let self, let d = data else { return }
            let ax = d.userAcceleration.x
            let ay = d.userAcceleration.y
            let az = d.userAcceleration.z
            
            let gForce = sqrt(ax * ax + ay * ay + az * az)
            if gForce > self.thresholdG {
                DispatchQueue.main.async {
                    self.lastImpact = Date()
                }
            }
        }
    }
}
