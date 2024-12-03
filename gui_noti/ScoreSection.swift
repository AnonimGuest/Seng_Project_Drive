import SwiftUI

struct ScoreSection: View {
    @State private var drivingScore: Int = 85
    @State private var penaltyScore: Int = 45  // Yeni eklenen penalty score
    @State private var tripsCount: Int = 2
    @State private var totalTime: String = "1 Hour"
    @State private var totalDistance: String = "52 km"
    @State private var scores: [String: Double] = [
        "Acceleration": 80,
        "Braking": 90,
        "Cornering": 95,
        "Speeding": 50,
        "Distraction": 60,
        "Penalty": 45
    ]
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("Your Driving Score")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 30)
                .foregroundColor(.black)
            
            // Driving score and penalty score
            HStack(spacing: 10) {
                Text("\(drivingScore)")
                    .font(.system(size: 80, weight: .bold))
                    .foregroundColor(drivingScore > 75 ? .green : .red)
                
                Text("Penalty Score: \(penaltyScore)")
                    .font(.title2)
                    .foregroundColor(.red)  // Kırmızı renk
            }

            Text("Better than 40% of other drivers")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Driving Stats Section
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text("Trips")
                    Spacer()
                    Text("\(tripsCount) Trips")
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text("Time")
                    Spacer()
                    Text(totalTime)
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text("Distance")
                    Spacer()
                    Text(totalDistance)
                        .fontWeight(.bold)
                }
            }
            .padding()
            
            // Scores progress bars
            VStack(alignment: .leading, spacing: 20) {
                ForEach(scores.keys.sorted(), id: \.self) { key in
                    VStack {
                        HStack {
                            Text(key)
                                .fontWeight(.medium)
                            Spacer()
                            Text("\(Int(scores[key] ?? 0))")
                                .fontWeight(.bold)
                        }
                        
                        ProgressBar(value: scores[key] ?? 0)
                            .frame(height: 10)
                            .cornerRadius(5)
                    }
                }
            }
            .padding([.horizontal, .bottom])
        }
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(25) // Daha yumuşak kenar
        .shadow(radius: 5)
        .padding([.top, .horizontal]) // Üst kısmı biraz daha boş bırak
    }
}

struct ProgressBar: View {
    var value: Double
    
    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .frame(width: .infinity, height: 10)
                .foregroundColor(Color.gray.opacity(0.2))
            
            Rectangle()
                .frame(width: CGFloat(value), height: 10)
                .foregroundColor(value > 70 ? .green : (value > 50 ? .yellow : .red))
        }
        .cornerRadius(5)
    }
}

struct ScoreView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreSection()
    }
}
