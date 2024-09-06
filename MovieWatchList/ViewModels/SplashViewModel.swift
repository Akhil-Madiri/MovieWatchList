import Foundation
import SwiftUI

class SplashViewModel: ObservableObject {
    @Published var isActive: Bool = false
    @Published var animationSize: CGFloat = 0.8
    @Published var isOnboardingActive: Bool = true

    func checkOnboardingStatus() {
        if UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
            // Skip onboarding and go to HomeView
            self.isOnboardingActive = false
            self.isActive = true
        }
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        self.isOnboardingActive = false
        self.isActive = true
    }

    func startAnimation() {
        withAnimation(.easeIn(duration: 1.5)) {
            self.animationSize = 1.0
        }
    }

    func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                self.isActive = true
            }
        }
    }
}
