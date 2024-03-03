//
//  LeaderboardView.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/16/23.
//

import SwiftUI

struct LeaderboardView: View {
    @Environment(FitnessTabState.self) var tabState
    @State var viewModel = LeaderboardViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Text("Name")
                            .bold()
                        
                        Spacer()
                        
                        Text("Steps")
                            .bold()
                    }
                    .padding()
                    
                    LazyVStack(spacing: 24) {
                        ForEach(Array(viewModel.leaderResult.top10.enumerated()), id: \.element.id) { (idx, person) in
                            HStack {
                                Text("\(idx + 1).")
                                
                                Text(person.username)
                                
                                if viewModel.username == person.username {
                                    Image(systemName: "crown.fill")
                                        .foregroundColor(.yellow)
                                }
                                
                                Spacer()
                                
                                Text("\(person.count)")
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    if let user = viewModel.leaderResult.user {
                        Image(systemName: "ellipsis")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                            .foregroundColor(.gray.opacity(0.5))
                        
                        HStack {
                            Text(user.username)
                            
                            Spacer()
                            
                            Text("\(user.count)")
                        }
                        .padding(.horizontal)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                
                if tabState.showTerms {
                    Color.white
                    
                    TermsView()
                        .environment(viewModel)
                        .environment(tabState)
                }
            }
            .navigationTitle("Leaderboard")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.didCompleteAccepting {
                        Button {
                            viewModel.setupLeaderboardData()
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(Color(uiColor: .label))
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .alert("Oops", isPresented: $viewModel.showAlert, actions: {
                Button(role: .cancel) {
                    viewModel.showAlert = false
                } label: {
                    Text("Ok")
                }
            }, message: {
                Text("There was an issue loading the leaderboard data. Please try again.")
            })
            .onChange(of: tabState.showTerms) { _,_ in
                if !tabState.showTerms && viewModel.username != nil {
                    viewModel.setupLeaderboardData()
                }
            }
        }
        
    }
        
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
    }
}
