import Foundation
import SwiftUI

class OnboardingViewModel: ObservableObject {
    @Published var selection = 0
    @Binding var isOnboardingActive: Bool

    init(isOnboardingActive: Binding<Bool>) {
        self._isOnboardingActive = isOnboardingActive
    }

    func nextPage() {
        selection += 1
    }

    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        isOnboardingActive = false
    }
}
