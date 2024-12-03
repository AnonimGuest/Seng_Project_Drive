import SwiftUI
import ActivityKit
import WidgetKit

func elapsedMinutes(from startTime: Date) -> Int {
    let elapsed = Date().timeIntervalSince(startTime)
    return Int(elapsed / 60) // Dakikaya çevir
}

struct Timer_Widget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimeTrackingAttributes.self) { context in
            TimeTrackingWidgetView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Tracking")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Active")
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("Elapsed Time: \(elapsedMinutes(from: context.state.startTime)) min")
                        .font(.headline)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Tap to stop")
                }
            } compactLeading: {
                Text("\(elapsedMinutes(from: context.state.startTime)) min")
                    .font(.caption)
            }
            compactTrailing: {
                Text("Active")
                    .font(.caption)
                    .foregroundColor(.green)
            }
            minimal: {
                Image(systemName: "clock")
            }
        }
    }
}

struct TimeTrackingWidgetView: View {
    let context: ActivityViewContext<TimeTrackingAttributes>

    var body: some View {
        ZStack {
            // Pastel mavi arka plan
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("PastelBlue")) // Özelleştirilmiş pastel mavi renk
                .shadow(radius: 5) // Hafif gölge

            VStack(spacing: 8) {
                Text("Tracking Active")
                    .font(.headline)
                    .foregroundColor(.primary) // Dinamik renk uyumu
                
                Text("Elapsed Time: \(context.state.startTime, style: .relative)")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            .padding(12) // İçerik için iç boşluk
        }
        .frame(maxWidth: .infinity, maxHeight: 60) // Widget boyutlandırması
        .padding() // Genel kenar boşluğu
    }
}
