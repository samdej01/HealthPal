import SwiftUI

struct TermsView: View {
    @EnvironmentObject var tabState: FitnessTabState
    @EnvironmentObject var viewModel: LeaderboardViewModel
    
    var body: some View {
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
                        Image(systemName: viewModel.acceptedTerms ? "checkmark.square.fill" : "square")
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
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue))
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
            .environmentObject(FitnessTabState())
            .environmentObject(LeaderboardViewModel())
    }
}
