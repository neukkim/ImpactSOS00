import SwiftUI

struct PhoneNumberRegisterView: View {
    @Binding var phoneNumbers: [String]
    @State private var phoneNumber: String = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("전화번호 등록").font(.largeTitle).bold()
            
            HStack {
                TextField("010", text: $phoneNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                Button("등록") {
                    if !phoneNumber.isEmpty && phoneNumber.count >= 10 {
                        phoneNumbers.append(phoneNumber)
                        phoneNumber = ""
                    }
                }.padding(.horizontal)
            }.padding(.horizontal)
            
            List {
                ForEach(phoneNumbers, id: \.self) { number in
                    Text(number)
                }.onDelete(perform: deleteNumber)
            }
            Spacer()
        }.padding()
    }
    
    func deleteNumber(at offsets: IndexSet) {
        phoneNumbers.remove(atOffsets: offsets)
    }
}
