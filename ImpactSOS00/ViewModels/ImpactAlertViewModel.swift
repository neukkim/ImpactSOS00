//
//  ImpactAlertViewModel.swift
//  ImpactSOS00
//
//  Created by SunMin Hong on 5/15/25.
//

import Foundation
import CoreLocation

class ImpactAlertViewModel: ObservableObject {
    
    var activeViewModel: ActiveViewModel?
    
    @Published var isImpactHandled = false
    @Published var phoneNumberList: [String] = []
    @Published var impactDetected = false
    @Published var messageSent = false
    @Published var locationURL: String = ""
    
    private let locationManager = LocationManager()
    
    init() {
        locationManager.requestLocation()
    }
    
    var lastCoordinate: CLLocationCoordinate2D? {
        locationManager.lastLocation?.coordinate
    }

    func handleImpact() {
        
        guard !isImpactHandled else {
            print("이미 처리됨")
            return
        }

        isImpactHandled = true
        print("충격 처리됨")
        
        activeViewModel?.startAlert()
        
        impactDetected = true
        let coordinate = lastCoordinate
        locationURL = coordinate.map { "https://www.google.com/maps?q=\($0.latitude),\($0.longitude)" }
            ?? "위치 정보를 가져올 수 없습니다."

        let message = """
        🚨 SOS!!!!  즉시 확인이 필요합니다.
        현재 위치 확인: "\(locationURL)"
        ※ 빠른 조치를 부탁드립니다.
        """
        
        sendMessages(message: message)
        print("message:\(message)")
        messageSent = true
    }

    func sendMessages(message: String) {
        for number in phoneNumberList {
            sendSMS(to: number, from: number, text: message)
            print("phoneNumberList:\(phoneNumberList)")
        }
    }

    private func sendSMS(to: String, from: String, text: String) {
        guard let url = URL(string: "https://sendsms-5xil5zipjq-uc.a.run.app") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload: [String: String] = ["to": to, "from": from, "text": text]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
        
        URLSession.shared.dataTask(with: request).resume()
    }
}


