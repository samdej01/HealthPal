import SwiftUI

struct FitnessTabView: View {
    @StateObject private var tabState = FitnessTabState() // Correctly use @StateObject

    var body: some View {
        TabView(selection: $tabState.selectedTab) { // Bind to selectedTab of type FitnessTabs
            HomeView()
                .tag(FitnessTabs.home)
                .tabItem {
                    Image(systemName: "house")
                    Text(FitnessTabs.home.rawValue)
                }
            
            ChartsView()
                .tag(FitnessTabs.charts)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text(FitnessTabs.charts.rawValue)
                }
            
            PlansView()
                .tag(FitnessTabs.plans)
                .tabItem {
                    Image(systemName: "calendar")
                    Text(FitnessTabs.plans.rawValue)
                }
            
            LeaderboardView()
                .tag(FitnessTabs.leaderboard)
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text(FitnessTabs.leaderboard.rawValue)
                }
            
            ProfileView()
                .tag(FitnessTabs.profile)
                .tabItem {
                    Image(systemName: "person")
                    Text(FitnessTabs.profile.rawValue)
                }
        }
        .environmentObject(tabState) // Inject tabState as an EnvironmentObject
        .task {
            do {
                try await HealthManager.shared.requestHealthKitAccess()
            } catch {
                DispatchQueue.main.async {
                    presentAlert(title: "Oops", message: "We were unable to access health data. Please allow access to enjoy the app.")
                }
            }
        }
    }
}

struct FitnessTabView_Previews: PreviewProvider {
    static var previews: some View {
        FitnessTabView()
    }
}
