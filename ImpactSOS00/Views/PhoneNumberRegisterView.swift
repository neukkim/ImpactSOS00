import SwiftUI

struct PhoneNumberRegisterView: View {
    @Binding var phoneNumbers: [String]
    @State private var phoneNumber: String = ""
    
    var body: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("전화번호 등록")
                .font(.largeTitle)
                .bold()
                .padding(.horizontal)
            
            HStack {
                TextField("전화번호 입력", text: $phoneNumber)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .keyboardType(.numberPad)
                    .keyboardType(.phonePad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                
                Button("저장") {
                    if !phoneNumber.isEmpty && phoneNumber.count >= 10 {
                        phoneNumbers.append(phoneNumber)
                        phoneNumber = ""
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.trailing)
            
            Divider()
                .padding(.horizontal)
            if phoneNumbers.isEmpty {
                Text("등록된 전화번호가 없습니다.")
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(phoneNumbers.indices, id: \.self) { index in
                        HStack {
                            Text("📞 \(phoneNumbers[index])")
                                .foregroundColor(.primary)
                            Spacer()
                            Button(action: {
                                phoneNumbers.remove(at: index)
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            Spacer()
        }
        .padding(.top, 40)
    }
    
    func deleteNumber(at offsets: IndexSet) {
        phoneNumbers.remove(atOffsets: offsets)
    }
}

#Preview {
    PhoneNumberRegisterView(phoneNumbers: .constant([]))
}
