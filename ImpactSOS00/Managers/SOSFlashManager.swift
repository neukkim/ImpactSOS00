import AVFoundation

class SOSFlashManager {
    static let shared = SOSFlashManager()
    private init() {}

    private let device = AVCaptureDevice.default(for: .video)
    private var isRunning = false

    private let morsePattern: [(on: Bool, duration: Double)] = [
        // S (· · ·)
        (true, 0.3), (false, 0.3),
        (true, 0.3), (false, 0.3),
        (true, 0.3), (false, 0.7),
        // O (– – –)
        (true, 0.9), (false, 0.3),
        (true, 0.9), (false, 0.3),
        (true, 0.9), (false, 0.7),
        // S (· · ·)
        (true, 0.3), (false, 0.3),
        (true, 0.3), (false, 0.3),
        (true, 0.3), (false, 1.0) // 끝나고 1초 쉬기
    ]

    func startSOS() {
        guard let device = device, device.hasTorch else {
            print("플래시 없음")
            return
        }

        isRunning = true

        DispatchQueue.global().async {
            while self.isRunning {
                for signal in self.morsePattern {
                    do {
                        try device.lockForConfiguration()
                        if signal.on {
                            try device.setTorchModeOn(level: 1.0)
                        } else {
                            device.torchMode = .off
                        }
                        device.unlockForConfiguration()
                    } catch {
                        print("플래시 오류: \(error)")
                    }
                    Thread.sleep(forTimeInterval: signal.duration)
                }
            }

            // 종료 시 플래시 꺼짐
            do {
                try device.lockForConfiguration()
                device.torchMode = .off
                device.unlockForConfiguration()
            } catch {}
        }
    }

    func stopSOS() {
        isRunning = false
    }
}
