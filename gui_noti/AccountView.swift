import SwiftUI

struct AccountView: View {
    @State private var name: String = "Raymond Clark" // Örnek isim
    @State private var drivingScore: Double = 85.0 // Örnek sürüş puanı
    @State private var goals: [Goal] = [
        Goal(type: .ecoDriver, requiredQuantity: 100.0, quantity: 80.0, completed: false),
        Goal(type: .speedControlMaster, requiredQuantity: 120.0, quantity: 120.0, completed: true),
        Goal(type: .safeDriver, requiredQuantity: 50.0, quantity: 50.0, completed: true)
    ]

    let columns = [
        GridItem(.flexible(), spacing: 30), // Kutucuklar arasındaki yatay boşluk artırıldı
        GridItem(.flexible(), spacing: 30)
    ]

    var body: some View {
        VStack(spacing: 20) {
            // Kullanıcı Bilgileri
            VStack(spacing: 10) {
                Text("Name: \(name)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                Text("Driving Score: \(String(format: "%.1f", drivingScore))")
                    .font(.headline)
                    .foregroundColor(drivingScore > 75 ? .green : .red)
            }

            Divider()

            // Kullanıcının Goals (Başarımları)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 30) { // Kutucuklar arasındaki dikey boşluk artırıldı
                    ForEach(goals) { goal in
                        GoalProgressView(goal: goal)
                            .padding(10) // Kutucukların çevresine ek boşluk
                    }
                }
                .padding(.horizontal)
            }
        }
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all))
        .navigationTitle("Account")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AccountView()
        }
    }
}
