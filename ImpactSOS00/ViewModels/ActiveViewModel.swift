import Foundation
import AVFoundation
import SwiftUI

class ActiveViewModel: ObservableObject {
    @Published var isAlert = false
    @Published var currentColorIndex = 0
    @Published var isRainbowMode = false
    @Published var emergencyText = "충격 감지 대기 중"
    @Published var isEmergency = false
    @Published var registeredPhoneNumbers: [String] = []

    let rainbowColors: [Color] = [.orange, .yellow, .green, .blue, .purple]

    func playBuzzer() {
        AudioServicesPlaySystemSound(SystemSoundID(1012))
    }

    func startRainbowAnimation() {
        isRainbowMode = true
        isAlert = true
        currentColorIndex = 0

        for i in 0..<rainbowColors.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                self.currentColorIndex = i
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + Double(rainbowColors.count) * 0.2 + 0.3) {
            self.isRainbowMode = false
            self.isAlert = false
            self.emergencyText = "충격 감지 대기 중"
            self.isEmergency = false
        }
    }
}
