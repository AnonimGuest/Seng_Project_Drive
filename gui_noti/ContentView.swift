/*import SwiftUI
import ActivityKit

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var isTrackingTime: Bool = false
    @State private var startTime: Date? = nil
    @State private var activity: Activity<TimeTrackingAttributes>? = nil

    var body: some View {
        NavigationView {
            ZStack {
                // Arka plan rengini uyguluyoruz
                Color(UIColor.systemGroupedBackground) // GoalsView arka planıyla aynı renk
                    .ignoresSafeArea()

                VStack {
                    // TabView
                    TabView(selection: $selectedTab) {
                        HomeView(isTrackingTime: $isTrackingTime, startTime: $startTime, activity: $activity)
                            .tabItem {
                                Image(systemName: "house")
                                Text("Home")
                            }
                            .tag(0)

                        ScoreView()
                            .tabItem {
                                Image(systemName: "star.circle")
                                Text("Score")
                            }
                            .tag(1)

                        GoalsView()
                            .tabItem {
                                Image(systemName: "flag.circle")
                                Text("Goals")
                            }
                            .tag(2)

                        SettingsView()
                            .tabItem {
                                Image(systemName: "gear")
                                Text("Settings")
                            }
                            .tag(3)
                    }
                    .background(Color(UIColor.systemGroupedBackground)) // TabView için arka plan
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // iPad ve iPhone uyumu için
    }
}

struct HomeView: View {
    @Binding var isTrackingTime: Bool
    @Binding var startTime: Date?
    @Binding var activity: Activity<TimeTrackingAttributes>?

    @State private var showAlert = false
    @State private var trips: [Trip] = [
        Trip(date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), duration: 45, avgSpeed: 35, distance: 15.5),
        Trip(date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), duration: 30, avgSpeed: 25, distance: 10.3),
        Trip(date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), duration: 50, avgSpeed: 40, distance: 20.7),
        Trip(date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(), duration: 60, avgSpeed: 30, distance: 18.4),
        Trip(date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), duration: 25, avgSpeed: 20, distance: 8.9)
    ]
    @State private var elapsedTime: Double = 0

    var body: some View {
        VStack {
            // Header Section
            HStack {
                VStack(alignment: .leading) {
                    Text("Driving Mode")
                        .font(.largeTitle)
                        .bold()
                    Text("Safe Driving, Driver!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer().frame(height: 8)
                }
                Spacer()
            }
            .padding([.horizontal, .top])
            .background(Color(UIColor.systemGroupedBackground))
            .padding(.bottom, 10)

            Spacer()

            // Circle Button
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .foregroundColor(.blue.opacity(0.3))
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(elapsedTime.truncatingRemainder(dividingBy: 60) / 60))
                    .stroke(
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .foregroundColor(isTrackingTime ? Color.red : Color.green)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: elapsedTime)

                Circle()
                    .fill(isTrackingTime ? Color.red : Color.green)
                    .frame(width: 200, height: 200)

                VStack {
                    Button {
                        isTrackingTime.toggle()

                        if isTrackingTime {
                            startTime = .now
                            elapsedTime = 0

                            let attributes = TimeTrackingAttributes()
                            let content = ActivityContent(
                                state: TimeTrackingAttributes.ContentState(startTime: .now),
                                staleDate: Calendar.current.date(byAdding: .hour, value: 1, to: .now)
                            )

                            do {
                                activity = try Activity<TimeTrackingAttributes>.request(
                                    attributes: attributes,
                                    content: content
                                )
                            } catch {
                                print("Failed to start activity: \(error.localizedDescription)")
                            }
                        } else {
                            guard let activity = activity, let startTime = startTime else { return }
                            let avgSpeed = Int.random(in: 20...40)
                            let distance = Double.random(in: 5...25).rounded(toPlaces: 1)
                            let duration = Int(elapsedTime / 60)

                            let newTrip = Trip(date: Date(), duration: duration, avgSpeed: avgSpeed, distance: distance)
                            trips.insert(newTrip, at: 0)

                            Task {
                                await activity.end(
                                    .init(
                                        state: TimeTrackingAttributes.ContentState(startTime: startTime),
                                        staleDate: nil
                                    ),
                                    dismissalPolicy: .immediate
                                )
                            }

                            self.startTime = nil
                            self.elapsedTime = 0
                            showAlert = true
                        }
                    } label: {
                        Text(isTrackingTime ? "STOP TRACKING" : "START TRACKING")
                            .font(.headline)
                            .foregroundColor(.white)
                    }

                    // Süre Gösterimi
                    Text(formatElapsedTime(elapsedTime))
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                }
            }
            .frame(width: 220, height: 220)
            .onReceive(timerPublisher().autoconnect()) { _ in
                if isTrackingTime {
                    if let startTime = startTime {
                        elapsedTime = Date().timeIntervalSince(startTime)

                        // Dynamic Island Güncellemesi
                        updateActivity()
                    }
                }
            }

            Spacer()

            // Recent Trips Section
            VStack(alignment: .leading) {
                Text("Recent Trips")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.bottom, 8) // Başlık ile kayıtlar arasında boşluk

                List(trips) { trip in
                    VStack(alignment: .leading) {
                        Text(trip.formattedDate)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack {
                            Text("Duration: \(trip.duration)m")
                            Spacer()
                            Text("Avg Speed: \(trip.avgSpeed) mph")
                        }
                        .font(.footnote)
                        HStack {
                            Spacer()
                            Text("\(String(format: "%.1f", trip.distance)) miles")
                                .font(.footnote)
                                .padding(5)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.vertical, 5)
                }
                .frame(height: 300)
                .padding(.top, -8) // Beyaz arka planı yukarı taşı
            }
        }
        .navigationTitle("Home")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Trip Saved"),
                message: Text("You can view your trip score in the score menu."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func timerPublisher() -> Timer.TimerPublisher {
        Timer.publish(every: 1, on: .main, in: .common)
    }

    private func formatElapsedTime(_ elapsedTime: Double) -> String {
        let totalSeconds = Int(elapsedTime)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func updateActivity() {
        guard let activity = activity, let startTime = startTime else { return }

        let content = ActivityContent(
            state: TimeTrackingAttributes.ContentState(startTime: startTime),
            staleDate: Calendar.current.date(byAdding: .minute, value: 1, to: .now)
        )

        Task {
            await activity.update(content)
        }
    }
}

// Örnek "Trip" Modeli
struct Trip: Identifiable {
    let id = UUID()
    let date: Date
    let duration: Int // Dakika
    let avgSpeed: Int // mph
    let distance: Double // mile
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ScoreView: View {
    var body: some View {
        VStack {
            ScoreSection() // ScoreSection'ı burada çağırıyoruz
        }
        .navigationTitle("Score")
    }
}

// Helper Fonksiyonu
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
*/

import SwiftUI
import ActivityKit

struct ContentView: View {
    @State private var selectedTab: Int = 0
    @State private var isTrackingTime: Bool = false
    @State private var startTime: Date? = nil
    @State private var activity: Activity<TimeTrackingAttributes>? = nil
    @StateObject private var motionManager = MotionManager() // Motion Manager
    let notify = NotificationHandler() // Notification Manager
    @State private var showCrashAlert = false // Crash Alert State

    var body: some View {
        NavigationView {
            ZStack {
                // Arka plan rengini uyguluyoruz
                Color(UIColor.systemGroupedBackground) // GoalsView arka planıyla aynı renk
                    .ignoresSafeArea()

                VStack {
                    // TabView
                    TabView(selection: $selectedTab) {
                        HomeView(isTrackingTime: $isTrackingTime, startTime: $startTime, activity: $activity)
                            .tabItem {
                                Image(systemName: "house")
                                Text("Home")
                            }
                            .tag(0)

                        ScoreView()
                            .tabItem {
                                Image(systemName: "star.circle")
                                Text("Score")
                            }
                            .tag(1)

                        GoalsView()
                            .tabItem {
                                Image(systemName: "flag.circle")
                                Text("Goals")
                            }
                            .tag(2)

                        SettingsView()
                            .tabItem {
                                Image(systemName: "gear")
                                Text("Settings")
                            }
                            .tag(3)
                    }
                    .background(Color(UIColor.systemGroupedBackground)) // TabView için arka plan
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
                .onAppear {
                    // Crash Detection Başlatma
                    motionManager.startDetectingCrash { isCrashDetected in
                        if isCrashDetected {
                            notify.sendNotification(
                                title: "Crash Detected",
                                body: "A potential crash has been detected. Please check your surroundings!"
                            )
                            showCrashAlert = true
                        }
                    }
                }
                .alert("Crash Detected", isPresented: $showCrashAlert) {
                    // Call 911 button
                    Button("Call 911", role: .destructive) {
                        makeEmergencyCall()
                    }
                    // Cancel button
                    Button("Cancel", role: .cancel) {
                        showCrashAlert = false
                    }
                } message: {
                    Text("It looks like you've been in a crash. Would you like to call emergency services?")
                }
            }

            private func makeEmergencyCall() {
                if let url = URL(string: "tel://911"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
                } else {
                    print("Cannot make a call on this device.")
                }
            }
        }

struct HomeView: View {
    @Binding var isTrackingTime: Bool
    @Binding var startTime: Date?
    @Binding var activity: Activity<TimeTrackingAttributes>?

    @State private var showAlert = false
    @State private var trips: [Trip] = [
        Trip(date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), duration: 45, avgSpeed: 35, distance: 15.5),
        Trip(date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), duration: 30, avgSpeed: 25, distance: 10.3),
        Trip(date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), duration: 50, avgSpeed: 40, distance: 20.7),
        Trip(date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(), duration: 60, avgSpeed: 30, distance: 18.4),
        Trip(date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), duration: 25, avgSpeed: 20, distance: 8.9)
    ]
    @State private var elapsedTime: Double = 0

    var body: some View {
        VStack {
            // Header Section
            HStack {
                VStack(alignment: .leading) {
                    Text("Driving Mode")
                        .font(.largeTitle)
                        .bold()
                    Text("Safe Driving, Driver!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Spacer().frame(height: 8)
                }
                Spacer()
            }
            .padding([.horizontal, .top])
            .background(Color(UIColor.systemGroupedBackground))
            .padding(.bottom, 10)

            Spacer()

            // Circle Button
            ZStack {
                Circle()
                    .stroke(lineWidth: 10)
                    .foregroundColor(.blue.opacity(0.3))
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(elapsedTime.truncatingRemainder(dividingBy: 60) / 60))
                    .stroke(
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .foregroundColor(isTrackingTime ? Color.red : Color.green)
                    .rotationEffect(Angle(degrees: -90))
                    .animation(.linear, value: elapsedTime)

                Circle()
                    .fill(isTrackingTime ? Color.red : Color.green)
                    .frame(width: 200, height: 200)

                VStack {
                    Button {
                        isTrackingTime.toggle()

                        if isTrackingTime {
                            startTime = .now
                            elapsedTime = 0

                            let attributes = TimeTrackingAttributes()
                            let content = ActivityContent(
                                state: TimeTrackingAttributes.ContentState(startTime: .now),
                                staleDate: Calendar.current.date(byAdding: .hour, value: 1, to: .now)
                            )

                            do {
                                activity = try Activity<TimeTrackingAttributes>.request(
                                    attributes: attributes,
                                    content: content
                                )
                            } catch {
                                print("Failed to start activity: \(error.localizedDescription)")
                            }
                        } else {
                            guard let activity = activity, let startTime = startTime else { return }
                            let avgSpeed = Int.random(in: 20...40)
                            let distance = Double.random(in: 5...25).rounded(toPlaces: 1)
                            let duration = Int(elapsedTime / 60)

                            let newTrip = Trip(date: Date(), duration: duration, avgSpeed: avgSpeed, distance: distance)
                            trips.insert(newTrip, at: 0)

                            Task {
                                await activity.end(
                                    .init(
                                        state: TimeTrackingAttributes.ContentState(startTime: startTime),
                                        staleDate: nil
                                    ),
                                    dismissalPolicy: .immediate
                                )
                            }

                            self.startTime = nil
                            self.elapsedTime = 0
                            showAlert = true
                        }
                    } label: {
                        Text(isTrackingTime ? "STOP TRACKING" : "START TRACKING")
                            .font(.headline)
                            .foregroundColor(.white)
                    }

                    // Süre Gösterimi
                    Text(formatElapsedTime(elapsedTime))
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                }
            }
            .frame(width: 220, height: 220)
            .onReceive(timerPublisher().autoconnect()) { _ in
                if isTrackingTime {
                    if let startTime = startTime {
                        elapsedTime = Date().timeIntervalSince(startTime)

                        // Dynamic Island Güncellemesi
                        updateActivity()
                    }
                }
            }

            Spacer()

            // Recent Trips Section
            VStack(alignment: .leading) {
                Text("Recent Trips")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.bottom, 8) // Başlık ile kayıtlar arasında boşluk

                List(trips) { trip in
                    VStack(alignment: .leading) {
                        Text(trip.formattedDate)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        HStack {
                            Text("Duration: \(trip.duration)m")
                            Spacer()
                            Text("Avg Speed: \(trip.avgSpeed) mph")
                        }
                        .font(.footnote)
                        HStack {
                            Spacer()
                            Text("\(String(format: "%.1f", trip.distance)) miles")
                                .font(.footnote)
                                .padding(5)
                                .background(Color.blue.opacity(0.2))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.vertical, 5)
                }
                .frame(height: 300)
                .padding(.top, -8) // Beyaz arka planı yukarı taşı
            }
        }
        .navigationTitle("Home")
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Trip Saved"),
                message: Text("You can view your trip score in the score menu."),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private func timerPublisher() -> Timer.TimerPublisher {
        Timer.publish(every: 1, on: .main, in: .common)
    }

    private func formatElapsedTime(_ elapsedTime: Double) -> String {
        let totalSeconds = Int(elapsedTime)
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    private func updateActivity() {
        guard let activity = activity, let startTime = startTime else { return }

        let content = ActivityContent(
            state: TimeTrackingAttributes.ContentState(startTime: startTime),
            staleDate: Calendar.current.date(byAdding: .minute, value: 1, to: .now)
        )

        Task {
            await activity.update(content)
        }
    }
}

// Örnek "Trip" Modeli
struct Trip: Identifiable {
    let id = UUID()
    let date: Date
    let duration: Int // Dakika
    let avgSpeed: Int // mph
    let distance: Double // mile
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ScoreView: View {
    var body: some View {
        VStack {
            ScoreSection() // ScoreSection'ı burada çağırıyoruz
        }
        .navigationTitle("Score")
    }
}

// Helper Fonksiyonu
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
