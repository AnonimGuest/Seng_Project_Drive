import SwiftUI

struct SettingsView: View {
    @State private var isDarkMode = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Arka plan rengi: Dark Mode'da bile açık bir gri ton
                Color(UIColor.systemGray6)
                    .edgesIgnoringSafeArea(.all)
                
                Form {
                    Section(header: Text("ACCOUNT").foregroundColor(.secondary)) {
                        NavigationLink(destination: AccountView()) {
                            Text("Account")
                        }
                    }
                    
                    Section(header: Text("EMERGENCY").foregroundColor(.secondary)) {
                        NavigationLink(destination: EmergencyPhoneView()) {
                            Text("Emergency Phone")
                        }
                    }
                    
                    Section {
                        Toggle(isOn: $isDarkMode) {
                            Text("Dark Mode")
                        }
                        .onChange(of: isDarkMode) { value in
                            updateInterfaceStyle(isDarkMode: value)
                        }
                    }
                }
                .scrollContentBackground(.hidden) // Form'un varsayılan arka planını gizler
                .background(Color(UIColor.systemGray6)) // Form arka planını manuel ayarladık
            }
            .navigationTitle("Settings")
        }
    }
    
    // Dark Mode ayarını değiştir
    private func updateInterfaceStyle(isDarkMode: Bool) {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            windowScene.keyWindow?.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
        }
    }
}


struct EmergencyPhoneView: View {
    @AppStorage("emergencyPhoneName") private var savedName: String = ""
    @AppStorage("emergencyPhoneNumber") private var savedPhoneNumber: String = ""
    
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    @State private var showSavedMessage = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Emergency Contact")
                .font(.largeTitle)
                .padding()

            TextField("Enter Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            TextField("Enter Phone Number", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .keyboardType(.phonePad)

            Button(action: {
                savedName = name
                savedPhoneNumber = phoneNumber
                showSavedMessage = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showSavedMessage = false
                }
            }) {
                Text("Save")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .alert(isPresented: $showSavedMessage) {
                Alert(
                    title: Text("Saved"),
                    message: Text("Emergency contact has been saved."),
                    dismissButton: .default(Text("OK"))
                )
            }

            Spacer()
        }
        .onAppear {
            // Kaydedilen bilgileri yükle
            name = savedName
            phoneNumber = savedPhoneNumber
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
