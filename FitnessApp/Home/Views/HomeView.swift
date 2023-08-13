//
//  HomeView.swift
//  FitnessApp
//
//  Created by Jason Dubon on 7/29/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()
    @Binding var isPremium: Bool
    @State private var showPaywall = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .padding()
                    
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Calories")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.red)
                                
                                Text("\(viewModel.calories)")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Active")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.green)
                                
                                Text("\(viewModel.exercise)")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Stand")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.blue)
                                
                                Text("\(viewModel.stand)")
                                    .bold()
                            }
                        }
                        
                        Spacer()
                        
                        ZStack {
                            ProgressCircleView(progress: $viewModel.calories, goal: 600, color: .red)
                            
                            ProgressCircleView(progress: $viewModel.exercise, goal: 60, color: .green)
                                .padding(.all, 20)
                            
                            ProgressCircleView(progress: $viewModel.stand, goal: 12, color: .blue)
                                .padding(.all, 40)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding()
                    
                    HStack {
                        Text("Fitness Activity")
                            .font(.title2)
                        
                        Spacer()
                        
                        Button {
                            if !isPremium {
                                showPaywall = true
                            }
                        } label: {
                            Text("Show more")
                                .padding(.all, 10)
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    
                    if !viewModel.activities.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                            ForEach(viewModel.activities, id: \.title) { activity in
                                ActivityCard(activity: activity)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    HStack {
                        Text("Recent Workouts")
                            .font(.title2)
                        
                        Spacer()
                        
                        if !isPremium {
                            Button {
                                if !isPremium {
                                    showPaywall = true
                                }
                            } label: {
                                Text("Show more")
                                    .padding(.all, 10)
                                    .foregroundColor(.white)
                                    .background(.blue)
                                    .cornerRadius(20)
                            }
                        } else {
                            NavigationLink {
                                EmptyView()
                            } label: {
                                Text("Show more")
                                    .padding(.all, 10)
                                    .foregroundColor(.white)
                                    .background(.blue)
                                    .cornerRadius(20)
                            }
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    LazyVStack {
                        ForEach(viewModel.workouts, id: \.self) { workout in
                            WorkoutCard(workout: workout)
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(isPremium: .constant(false))
    }
}
