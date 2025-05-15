import SwiftUI
import CoreMotion
import CoreLocation

struct ContentView: View {
    @State private var isMessagePresented = false
//    @State private var phoneNumberList: [String] = []
//    @State private var impactDetected = false
//    @State private var messageSent = false
    @StateObject private var motionManager = MotionManager()
//    @StateObject private var locationManager = LocationManager()
    
    @StateObject private var viewModel = ImpactAlertViewModel()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Spacer()
                
                Button(action: {
                    viewModel.sendMessages(message: "SOS!!!! 상황 해제 입니다. 걱정 마세요!!! ")
                }) {
                    Text("취 소")
                        .font(.largeTitle)
                        .frame(width: 300, height: 200)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 2))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                }
                
                NavigationLink(destination: PhoneNumberRegisterView(phoneNumbers: $viewModel.phoneNumberList)) {
                    Text("번호등록")
                        .font(.title2)
                        .frame(width: 300, height: 100)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color.black, lineWidth: 2))
                        .cornerRadius(15)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                if viewModel.impactDetected {
                    VStack(spacing: 10) {
                        Text("충격 감지됨! 문자 발송 중...")
                            .foregroundColor(.red)
                        
                        if viewModel.messageSent {
                            Text("✅ 문자 발송 완료")
                                .foregroundColor(.green)
                        }
                        
                        if let coordinate = viewModel.lastCoordinate {
                            let urlString = "https://www.google.com/maps?q=\(coordinate.latitude),\(coordinate.longitude)"
                            Button(action: {
                                if let url = URL(string: urlString) {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                Text(urlString)
                                    .font(.footnote)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.blue)
                                    .padding(.horizontal)
                            }
                        } else {
                            Text("위치 정보를 가져올 수 없습니다.")
                                .foregroundColor(.gray)
                        }
                    }
                }
            }
        }
        
        
        .onReceive(motionManager.$lastImpact) { date in
            guard date != nil else { return }
            viewModel.handleImpact()
        }
        .onAppear {
            motionManager.start()
//            locationManager.requestLocation()
        }
    }
}

//func sendMessages(to numbers: [String], message: String) {
//    for number in numbers {
//        sendSMS(to: number, from: number, text: message)
//    }
//}
//
//func sendSMS(to: String, from: String, text: String) {
//    guard let url = URL(string: "https://sendsms-5xil5zipjq-uc.a.run.app") else { return }
//    
//    var request = URLRequest(url: url)
//    request.httpMethod = "POST"
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//    
//    let payload: [String: String] = ["to": to, "from": from, "text": text]
//    request.httpBody = try? JSONSerialization.data(withJSONObject: payload)
//    
//    URLSession.shared.dataTask(with: request).resume()
//}


//struct PhoneNumberRegisterView: View {
//    @Binding var phoneNumbers: [String]
//    @State private var phoneNumber: String = ""
//    
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("전화번호 등록").font(.largeTitle).bold()
//            
//            HStack {
//                TextField("010", text: $phoneNumber)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .keyboardType(.numberPad)
//                
//                Button("등록") {
//                    if !phoneNumber.isEmpty && phoneNumber.count >= 10 {
//                        phoneNumbers.append(phoneNumber)
//                        phoneNumber = ""
//                    }
//                }.padding(.horizontal)
//            }.padding(.horizontal)
//            
//            List {
//                ForEach(phoneNumbers, id: \.self) { number in
//                    Text(number)
//                }.onDelete(perform: deleteNumber)
//            }
//            Spacer()
//        }.padding()
//    }
//    
//    func deleteNumber(at offsets: IndexSet) {
//        phoneNumbers.remove(atOffsets: offsets)
//    }
//}

//class MotionManager: ObservableObject {
//    private let motion = CMMotionManager()
//    private let queue = OperationQueue()
//    
//    @Published var lastImpact: Date?
//    
//    var thresholdG: Double = 1.0
//    
//    init() {
//        motion.deviceMotionUpdateInterval = 0.02 // 50Hz
//    }
//    
//    func start() {
//        guard motion.isDeviceMotionAvailable else { return }
//        motion.startDeviceMotionUpdates(to: queue) { [weak self] data, _ in
//            guard let self, let d = data else { return }
//            let ax = d.userAcceleration.x
//            let ay = d.userAcceleration.y
//            let az = d.userAcceleration.z
//            
//            let gForce = sqrt(ax * ax + ay * ay + az * az)
//            
//            if gForce > self.thresholdG {
//                DispatchQueue.main.async {
//                    self.lastImpact = Date()
//                }
//            }
//        }
//    }
//}

//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let manager = CLLocationManager()
//    @Published var lastLocation: CLLocation?
//    
//    override init() {
//        super.init()
//        manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//    
//    func requestLocation() {
//        manager.requestWhenInUseAuthorization()
//        manager.requestLocation()
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        lastLocation = locations.first
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("위치 오류: \(error.localizedDescription)")
//    }
//}

#Preview {
    ContentView()
}
