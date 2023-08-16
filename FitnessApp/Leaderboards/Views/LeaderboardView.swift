//
//  LeaderboardView.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/16/23.
//

import SwiftUI

struct LeaderboardUser: Codable, Identifiable {
    let id: Int
    let createdAt: String
    let username: String
    let count: Int
}

class LeaderboardViewModel: ObservableObject {
    
    var mockData = [
        LeaderboardUser(id: 0, createdAt: "", username: "jason", count: 4124),
        LeaderboardUser(id: 1, createdAt: "", username: "you", count: 1124),
        LeaderboardUser(id: 2, createdAt: "", username: "seanallen", count: 41204),
        LeaderboardUser(id: 3, createdAt: "", username: "paul hudson", count: 4124),
        LeaderboardUser(id: 4, createdAt: "", username: "catalin", count: 11124),
        LeaderboardUser(id: 5, createdAt: "", username: "logan", count: 124),
        LeaderboardUser(id: 6, createdAt: "", username: "jason", count: 4124),
        LeaderboardUser(id: 7, createdAt: "", username: "you", count: 1124),
        LeaderboardUser(id: 8, createdAt: "", username: "seanallen", count: 41204),
        LeaderboardUser(id: 9, createdAt: "", username: "paul hudson", count: 4124),
        LeaderboardUser(id: 10, createdAt: "", username: "catalin", count: 11124),
        LeaderboardUser(id: 11, createdAt: "", username: "logan", count: 124),
    ]
    
}

struct LeaderboardView: View {
    @StateObject var viewModel = LeaderboardViewModel()
    
    @Binding var showTerms: Bool
    
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .bold()
            
            HStack {
                Text("Name")
                    .bold()
                
                Spacer()
                
                Text("Steps")
                    .bold()
            }
            .padding()
            
            LazyVStack(spacing: 24) {
                ForEach(viewModel.mockData) { person in
                    HStack {
                        Text("\(person.id).")
                        
                        Text(person.username)
                        
                        Spacer()
                        
                        Text("\(person.count)")
                    }
                    .padding(.horizontal)
                    
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .fullScreenCover(isPresented: $showTerms) {
            TermsView()
        }
    }
        
}

struct LeaderboardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderboardView(showTerms: .constant(false))
    }
}
