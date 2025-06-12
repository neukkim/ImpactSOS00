import AVFoundation
import Foundation
import SwiftUI

class ActiveViewModel: ObservableObject {
    @Published var isAlert = false
    @Published var currentColorIndex = 0
    @Published var isRainbowMode = false
    @Published var emergencyText = "충격 감지 대기 중"
    @Published var isEmergency = false
    @Published var registeredPhoneNumbers: [String] = []

    let rainbowColors: [Color] = [.orange, .yellow, .green, .blue, .purple]
    private var buzzerTimer: Timer?
    private var rainbowTimer: Timer?
    private var rainbowIndex = 0

    // 한 번 재생용 부저 사운드
    func playBuzzer() {
        AudioServicesPlaySystemSound(SystemSoundID(1012))
    }

    // 부저 및 상태 애니메이션 시작
    //    func startAlert() {
    //        isAlert = true
    //        isEmergency = true
    ////        emergencyText = "충격 감지 중 🚨"
    //        emergencyText = "응급 상황이 발생했습니다"
    //
    //        buzzerTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
    //            self.playBuzzer()
    //        }
    //    }

    func startAlert() {

        //        guard !isEmergency else { return }

        isRainbowMode = true
        isAlert = true
        isEmergency = true
        emergencyText = "응급 상황이 발생했습니다"

        // 무지개 애니메이션 효과
        for i in 0..<rainbowColors.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
                self.currentColorIndex = i
            }
        }

        // 반복 부저
        buzzerTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true)
        { _ in
            self.playBuzzer()
        }

        //        // 일정 시간 후 상태 초기화 (예: 2초 후)
        //        DispatchQueue.main.asyncAfter(deadline: .now() + Double(rainbowColors.count) * 0.2 + 0.5) {
        ////            self.stopAlert()
        ///

        rainbowIndex = 0
        rainbowTimer = Timer.scheduledTimer(
            withTimeInterval: 0.2,
            repeats: true
        ) { _ in
            self.currentColorIndex = self.rainbowIndex
            self.rainbowIndex =
                (self.rainbowIndex + 1) % self.rainbowColors.count
        }

    }

    // 중지 및 초기화
    func stopAlert() {
        //        isRainbowMode = false
        //        isAlert = false
        //        isEmergency = false
        //        emergencyText = "충격 감지 대기 중"
        //        buzzerTimer?.invalidate()
        //        buzzerTimer = nil
        isRainbowMode = false
        isAlert = false
        isEmergency = false
        emergencyText = "충격 감지 대기 중"

        buzzerTimer?.invalidate()
        buzzerTimer = nil

        rainbowTimer?.invalidate()
        rainbowTimer = nil
        rainbowIndex = 0
        currentColorIndex = 0
    }
}

//class ActiveViewModel: ObservableObject {
//    @Published var isAlert = false
//    @Published var currentColorIndex = 0
//    @Published var isRainbowMode = false
//    @Published var emergencyText = "충격 감지 대기 중"
//    @Published var isEmergency = false
////    @Published var registeredPhoneNumbers: [String] = []
//
//    let rainbowColors: [Color] = [.orange, .yellow, .green, .blue, .purple]
//
//    func playBuzzer() {
//        AudioServicesPlaySystemSound(SystemSoundID(1012))
//    }
//
//    func startRainbowAnimation() {
//        isRainbowMode = true
//        isAlert = true
//        currentColorIndex = 0
//
//        for i in 0..<rainbowColors.count {
//            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 0.2) {
//                self.currentColorIndex = i
//            }
//        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + Double(rainbowColors.count) * 0.2 + 0.3) {
//            self.isRainbowMode = false
//            self.isAlert = false
//            self.emergencyText = "충격 감지 대기 중"
//            self.isEmergency = false
//        }
//    }
//}
