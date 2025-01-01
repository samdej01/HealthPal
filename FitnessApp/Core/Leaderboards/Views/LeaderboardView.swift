import SwiftUI

struct LeaderboardView: View {
    @EnvironmentObject var tabState: FitnessTabState // Use EnvironmentObject
    @StateObject var viewModel = LeaderboardViewModel()

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
                        .environmentObject(viewModel)
                        .environmentObject(tabState)
                }
            }
            .navigationTitle(FitnessTabs.leaderboard.rawValue)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.didCompleteAccepting || viewModel.username != nil {
                        Button {
                            Task {
                                do {
                                    try await viewModel.setupLeaderboardData()
                                } catch {
                                    viewModel.showAlert = true
                                }
                            }
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
            .onChange(of: tabState.showTerms) { _, _ in
                if !tabState.showTerms && viewModel.username != nil {
                    Task {
                        do {
                            try await viewModel.setupLeaderboardData()
                        } catch {
                            viewModel.showAlert = true
                        }
                    }
                }
            }
        }
    }
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView()
            .environmentObject(FitnessTabState()) // Inject preview environment
    }
}
