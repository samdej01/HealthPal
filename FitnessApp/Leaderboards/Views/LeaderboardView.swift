//
//  LeaderboardView.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/16/23.
//

import SwiftUI

struct LeaderboardView: View {
    @AppStorage("username") var username: String?
    @StateObject var viewModel = LeaderboardViewModel()
    
    @Binding var showTerms: Bool
    
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .trailing) {
                    Text("Leaderboard")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity)
                    
                    Button {
                        viewModel.setupLeaderboardData()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .scaledToFit()
                            .bold()
                            .foregroundColor(Color(uiColor: .label))
                            .frame(width: 28, height: 28)
                            .padding(.trailing)
                    }
                }
                
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
                            
                            if username == person.username {
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
            
            if showTerms {
                Color.white
                
                TermsView(showTerms: $showTerms)
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
        .onChange(of: showTerms) { _ in
            if !showTerms && username != nil {
                viewModel.setupLeaderboardData()
            }
        }
    }
        
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView(showTerms: .constant(false))
    }
}
