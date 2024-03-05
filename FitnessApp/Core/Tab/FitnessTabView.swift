//
//  FitnessTabView.swift
//  FitnessApp
//
//  Created by Jason Dubon on 7/29/23.
//

import SwiftUI

struct FitnessTabView: View {
    @State var tabState = FitnessTabState()
    
    var body: some View {
        TabView(selection: $tabState.selectedTab) {
            HomeView()
                .environment(tabState)
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
            
            LeaderboardView()
                .environment(tabState)
                .tag(FitnessTabs.leaderboard)
                .tabItem {
                    Image(systemName: "list.bullet")
                    
                    Text(FitnessTabs.leaderboard.rawValue)
                }
            
            ProfileView()
                .tag(FitnessTabs.profile.rawValue)
                .tabItem {
                    Image(systemName: "person")
                    
                    Text(FitnessTabs.profile.rawValue)
                }
        }
        .tint(.green)
    }
}

struct FitnessTabView_Previews: PreviewProvider {
    static var previews: some View {
        FitnessTabView()
    }
}
