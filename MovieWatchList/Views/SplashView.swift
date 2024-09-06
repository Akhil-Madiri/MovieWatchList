import SwiftUI

struct SplashView: View {
    @StateObject private var viewModel = SplashViewModel()
    
    var body: some View {
        if viewModel.isActive {
            if UserDefaults.standard.bool(forKey: "hasCompletedOnboarding") {
                HomeView() // Replace this with your actual home view
            } else {
                OnboardingView(isOnboardingActive: $viewModel.isOnboardingActive)
                    .onChange(of: viewModel.isOnboardingActive) { newValue in
                        if !newValue {
                            viewModel.completeOnboarding()
                        }
                    }
            }
        } else {
            VStack {
                Image(systemName: "film")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .scaleEffect(viewModel.animationSize)
                    .onAppear {
                        viewModel.startAnimation()
                    }

                Text("Movie Tracker")
                    .font(.largeTitle)
                    .bold()
                    .padding(.top, 20)
            }
            .onAppear {
                viewModel.startSplashTimer()
            }
        }
    }
}
