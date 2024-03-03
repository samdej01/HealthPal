//
//  TermsView.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/16/23.
//

import SwiftUI

struct TermsView: View {
    @Environment(FitnessTabState.self) var tabState
    @Environment(LeaderboardViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        NavigationStack {
            VStack {
                Spacer()
                
                TextField("Username", text: $viewModel.termsViewUsername)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
                
                HStack(alignment: .top) {
                    Button {
                        withAnimation {
                            viewModel.acceptedTerms.toggle()
                        }
                    } label: {
                        if viewModel.acceptedTerms {
                            Image(systemName: "square.inset.filled")
                        } else {
                            Image(systemName: "square")
                        }
                    }

                    
                    Text("By checking you agree to the terms and enter into the leaderboard competition.")
                }
                    
                Spacer()
                
                Button {
                    withAnimation {
                        viewModel.acceptedTermsAndSignedUp()
                    }
                } label: {
                    Text("Continue")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                        )
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            .navigationTitle("Leaderboard")
            .onChange(of: viewModel.didCompleteAccepting) { _, newValue in
                if newValue {
                    tabState.showTerms = false
                }
            }
        }
    }
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView()
    }
}
