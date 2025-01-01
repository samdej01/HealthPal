import SwiftUI
import RevenueCatUI

struct HomeView: View {
    @EnvironmentObject var tabState: FitnessTabState
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    // Main view content
                }
                .navigationTitle(FitnessTabs.home.rawValue)
            }
        }
        .alert("Oops", isPresented: $viewModel.showAlert, actions: {
            Button("Ok") {
                viewModel.showAlert = false
            }
        }, message: {
            Text("There was an issue fetching some of your data. Some health tracking requires an Apple Watch.")
        })
        .sheet(isPresented: $viewModel.showPaywall) {
            PaywallView()
        }
        .onAppear {
            viewModel.fetchGoalData()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(FitnessTabState())
    }
}
