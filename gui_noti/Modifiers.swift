import SwiftUI

struct AppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color(UIColor.systemGray6)) // GoalsView arka planıyla aynı renk
            .edgesIgnoringSafeArea(.all) // Arka planın tüm alanı kaplamasını sağlar
    }
}

extension View {
    func applyAppBackground() -> some View {
        self.modifier(AppBackgroundModifier())
    }
}
