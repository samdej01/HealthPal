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
                .tag("Home")
                .tabItem {
                    Image(systemName: "house")
                    
                    Text("Home")
                }
            
            ChartsView()
                .tag("Charts")
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    
                    Text("Charts")
                }
            
            LeaderboardView()
                .environment(tabState)
                .tag("Leaderboard")
                .tabItem {
                    Image(systemName: "list.bullet")
                    
                    Text("Leaderboard")
                }
            
            ProfileView()
                .tag("Profile")
                .tabItem {
                    Image(systemName: "person")
                    
                    Text("Profile")
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
