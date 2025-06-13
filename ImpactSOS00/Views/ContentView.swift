import SwiftUI
import CoreMotion
import CoreLocation

struct ContentView: View {
    @State private var isMessagePresented = false
    @StateObject private var motionManager = MotionManager()
    @StateObject private var viewModel = ImpactAlertViewModel()
    @StateObject private var activeViewModel = ActiveViewModel()
    
    @State private var locationStatusText = "⏳ 위치 정보를 불러오는 중입니다..."
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Color.clear.frame(height: 100)
                
                Image(systemName: "light.beacon.max")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .foregroundColor(activeViewModel.isAlert ? .red : .gray)
                
                Text(activeViewModel.emergencyText)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(activeViewModel.isEmergency ? .red : .black)
                
                NavigationLink(destination: PhoneNumberRegisterView(phoneNumbers: $viewModel.phoneNumberList)) {
                    Text("전화번호 등록")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                        .font(.system(size: 25))
                }
                
                Button(action: {
                    viewModel.sendMessages(message: "SOS!!!! 상황 해제 입니다. 걱정 마세요!!! ")
                    activeViewModel.stopAlert()
                    viewModel.isImpactHandled = false
                    viewModel.messageSent = false
                }) {
                    Text("S O S  해 제")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                        .font(.system(size: 25))
                }
                /* 번호등록 버튼은  Button() + 모달 형태가 아닌,,, NavigationLink + 화면 전환.  인 개념
                 */
                

//                Button("충격감지 테스트") {
//                    activeViewModel.startAlert()
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(12)
//
//                Button("테스트 중지") {
//                    activeViewModel.stopAlert()
//                }
//                .padding()
//                .background(Color.gray)
//                .foregroundColor(.white)
//                .cornerRadius(12)
                
                if !viewModel.phoneNumberList.isEmpty {
                    Text("📞 등록된 전화번호: \(viewModel.phoneNumberList)")
                        .font(.caption)
                        .foregroundColor(.gray)
                } else {
                    Text("📞 등록된 전화번호가 없습니다.")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(locationStatusText)
                    .font(.headline)
                    .foregroundColor(viewModel.locationLoaded ? .green : .gray)
                
//                if let coordinate = viewModel.lastCoordinate {
//                    Text("📍 위치 정보가 확인되었습니다")
//                        .font(.headline)
//                        .foregroundColor(.green)
//                    
//                    Text("위도: \(coordinate.latitude)")
//                    Text("경도: \(coordinate.longitude)")
//                } else {
//                    Text("⏳ 위치 정보를 불러오는 중입니다...")
//                        .foregroundColor(.gray)
//                }
            } // End VStack
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.top, 10)
            .background(activeViewModel.isRainbowMode ?
                        activeViewModel.rainbowColors[activeViewModel.currentColorIndex % activeViewModel.rainbowColors.count] :
                    .white)
            .ignoresSafeArea()
            .preferredColorScheme(.light)
            .navigationTitle("충격 감지. SOS 전송")
            .navigationBarTitleDisplayMode(.inline)
            
//            if viewModel.impactDetected {
//                VStack(spacing: 10) {
//                    Text("충격 감지됨! 문자 발송 중...")
//                        .foregroundColor(.red)
//                    
//                    if viewModel.messageSent {
//                        Text("✅ 문자 발송 완료")
//                            .foregroundColor(.green)
//                    }
//                    
//                    if let coordinate = viewModel.lastCoordinate {
//                        let urlString = "https://www.google.com/maps?q=\(coordinate.latitude),\(coordinate.longitude)"
//                        Button(action: {
//                            if let url = URL(string: urlString) {
//                                UIApplication.shared.open(url)
//                            }
//                        }) {
//                            Text(urlString)
//                                .font(.footnote)
//                                .multilineTextAlignment(.center)
//                                .foregroundColor(.blue)
//                                .padding(.horizontal)
//                        }
//                    } else {
//                        Text("위치 정보를 가져올 수 없습니다.")
//                            .foregroundColor(.gray)
//                    }
//                }
//            } // end if
            

        }
        .onReceive(motionManager.$lastImpact) { date in
            guard date != nil else { return }
            viewModel.handleImpact()
            
        }
        
        .onReceive(viewModel.$locationLoaded) { loaded in
            if loaded {
                locationStatusText = "📍 위치 정보가 확인되었습니다"
            }
        }
        
        .onAppear {
            motionManager.start()
            viewModel.activeViewModel = activeViewModel
        }
        
    }
} // View


#Preview {
    ContentView()
}
