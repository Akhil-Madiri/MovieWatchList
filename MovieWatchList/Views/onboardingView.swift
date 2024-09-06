import SwiftUI

struct OnboardingView: View {
    @Binding var isOnboardingActive: Bool
    @StateObject private var viewModel: OnboardingViewModel
    
    init(isOnboardingActive: Binding<Bool>) {
        self._isOnboardingActive = isOnboardingActive
        _viewModel = StateObject(wrappedValue: OnboardingViewModel(isOnboardingActive: isOnboardingActive))
    }
    
    var body: some View {
        TabView(selection: $viewModel.selection) {
            OnboardingPageView(
                imageName: "film",
                title: "Welcome",
                description: "Discover new movies and manage your watchlist easily.",
                viewModel: viewModel,
                tag: 0
            )
            .tag(0)
            
            OnboardingPageView(
                imageName: "magnifyingglass",
                title: "Search",
                description: "Search for movies from a vast database and add them to your watchlist.",
                viewModel: viewModel,
                tag: 1
            )
            .tag(1)
            
            OnboardingPageView(
                imageName: "star",
                title: "Track",
                description: "Keep track of what you've watched and what's still on your list.",
                viewModel: viewModel,
                tag: 2
            )
            .tag(2)
            
            OnboardingFinalPageView(viewModel: viewModel)
                .tag(3)
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct OnboardingPageView: View {
    var imageName: String
    var title: String
    var description: String
    @ObservedObject var viewModel: OnboardingViewModel
    var tag: Int
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding(.top, 50)
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(description)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    viewModel.nextPage()
                }
            }) {
                Text("Next")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 50)
        }
        .padding()
    }
}

struct OnboardingFinalPageView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .foregroundColor(.green)
                .padding(.top, 50)
            
            Text("You're All Set!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Start managing your movie watchlist now.")
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Spacer()
            
            Button(action: {
                viewModel.completeOnboarding()
            }) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 50)
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(isOnboardingActive: .constant(true))
    }
}
