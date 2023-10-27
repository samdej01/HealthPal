//
//  TermsView.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/16/23.
//

import SwiftUI

struct TermsView: View {
    @AppStorage("username") var username: String?
    
    @Binding var showTerms: Bool
    
    @State var name = ""
    @State var acceptedTerms = false
    
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            TextField("Username", text: $name)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                )
            
            HStack(alignment: .top) {
                Button {
                    withAnimation {
                        acceptedTerms.toggle()
                    }
                } label: {
                    if acceptedTerms {
                        Image(systemName: "square.inset.filled")
                    } else {
                        Image(systemName: "square")
                    }
                }

                
                Text("By checking you agree to the terms and enter into the leaderboard competition.")
            }
                
            Spacer()
            
            Button {
                if acceptedTerms && name.count > 2 {
                    username = name
                    showTerms = false
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
    }
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView(showTerms: .constant(true))
    }
}
