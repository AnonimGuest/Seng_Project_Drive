import SwiftUI

struct GoalsView: View {
    @State private var totalDistance: Double = 120.5 // Örnek veri
    @State private var totalTime: Int = 380 // Örnek veri (dakika cinsinden)

    @State private var goals: [Goal] = [
        Goal(type: .ecoDriver, requiredQuantity: 100.0, quantity: 80.0, completed: false),
        Goal(type: .speedControlMaster, requiredQuantity: 120.0, quantity: 120.0, completed: true),
        Goal(type: .smoothAccelerator, requiredQuantity: 500.0, quantity: 400.0, completed: false),
        Goal(type: .safeCornering, requiredQuantity: 10000.0, quantity: 8500.0, completed: false),
        Goal(type: .nightRider, requiredQuantity: 50.0, quantity: 50.0, completed: true),
        Goal(type: .brakeExpert, requiredQuantity: 60.0, quantity: 30.0, completed: false),
        Goal(type: .highwayHero, requiredQuantity: 200.0, quantity: 150.0, completed: false),
        Goal(type: .fuelSaver, requiredQuantity: 70.0, quantity: 65.0, completed: false),
        Goal(type: .safeDriver, requiredQuantity: 300.0, quantity: 250.0, completed: true)
    ]

    // Grid Yapısı
    let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]

    var body: some View {
        VStack(spacing: 20) {
            // Üst Bölüm: "This Month" ve İstatistikler
            VStack {
                ZStack {
                    // Daire
                    Circle()
                        .stroke(lineWidth: 15)
                        .foregroundColor(Color.gray.opacity(0.3))

                    Circle()
                        .trim(from: 0.0, to: 0.8) // Örnek olarak %80 dolu
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [.red, .pink]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 15, lineCap: .round)
                        )
                        .rotationEffect(Angle(degrees: -90))

                    // Ortadaki Metin
                    VStack {
                        Text("This Month")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("\(String(format: "%.1f", totalDistance)) km")
                            .font(.title2)
                            .foregroundColor(.red)
                        Text("\(totalTime / 60)h \(totalTime % 60)m")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 150, height: 150)
            }
            .padding()

            Divider() // Bölücü Çizgi

            // Goals Listesi (Grid Yapısı)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(goals) { goal in
                        NavigationLink(destination: GoalDetailView(goal: goal)) {
                            GoalProgressView(goal: goal)
                                .padding(8) // Kutuların çevresindeki boşluk artırıldı
                        }
                    }
                }
                .padding(.horizontal) // Grid'in genel kenar boşluğu
            }
        }
        .background(Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)) // Gri arka plan
        .navigationTitle("Goals")
    }
}

// Tek bir goal için detay sayfası
struct GoalDetailView: View {
    let goal: Goal

    var body: some View {
        VStack(spacing: 20) {
            Text(goal.type.rawValue)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Required Quantity: \(String(format: "%.1f", goal.requiredQuantity))")
                .font(.title2)
                .foregroundColor(.gray)

            Text("Current Quantity: \(String(format: "%.1f", goal.quantity))")
                .font(.title2)
                .foregroundColor(goal.completed ? .green : .red)

            Text("Goal Status: \(goal.completed ? "Completed" : "In Progress")")
                .font(.title2)
                .foregroundColor(goal.completed ? .green : .red)

            Spacer()
        }
        .padding()
        .navigationTitle("Goal Details")
    }
}

// Tek bir hedef için progress view
struct GoalProgressView: View {
    let goal: Goal

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white) // Beyaz kutular
                .shadow(color: Color.gray.opacity(0.3), radius: 4, x: 0, y: 4)

            VStack(spacing: 10) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: 8)
                        .foregroundColor(Color.gray.opacity(0.3))

                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(goal.quantity / goal.requiredQuantity, 1.0)))
                        .stroke(
                            AngularGradient(
                                gradient: Gradient(colors: [.green, .blue]),
                                center: .center
                            ),
                            style: StrokeStyle(lineWidth: 8, lineCap: .round)
                        )
                        .rotationEffect(Angle(degrees: -90))

                    Text("\(Int((goal.quantity / goal.requiredQuantity) * 100))%")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .frame(width: 60, height: 60)

                // Goal Bilgileri
                VStack(alignment: .leading, spacing: 5) {
                    Text(goal.type.rawValue)
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Text("Required: \(String(format: "%.1f", goal.requiredQuantity))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Current: \(String(format: "%.1f", goal.quantity))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Text("Completed: \(goal.completed ? "Yes" : "No")")
                        .font(.subheadline)
                        .foregroundColor(goal.completed ? .green : .red)
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .frame(height: 170) // Daha uzun dikdörtgen yapı
    }
}

// Goal Modeli
struct Goal: Identifiable {
    let id = UUID()
    let type: GoalType
    let requiredQuantity: Double
    let quantity: Double
    let completed: Bool
}

// Goal Türleri
enum GoalType: String {
    case ecoDriver = "Eco Driver"
    case speedControlMaster = "Speed Control Master"
    case smoothAccelerator = "Smooth Accelerator"
    case safeCornering = "Safe Cornering"
    case nightRider = "Night Rider"
    case brakeExpert = "Brake Expert"
    case highwayHero = "Highway Hero"
    case fuelSaver = "Fuel Saver"
    case safeDriver = "Safe Driver"
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GoalsView()
        }
    }
}
