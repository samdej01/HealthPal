//
//  ProfileView.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/28/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image("avatar 1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.all, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.25))
                    )
                
                VStack(alignment: .leading) {
                    Text("Good morning,")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    
                    Text("Name")
                        .font(.title)
                }
            }
            
            VStack {
                FitnessProfileButton(title: "Edit name", image: "square.and.pencil") {
                    print("name")
                }
                
                FitnessProfileButton(title: "Edit image", image: "square.and.pencil") {
                    print("image")
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
            
            VStack {
                FitnessProfileButton(title: "Contact Us", image: "envelope") {
                    print("contact")
                }
                
                FitnessProfileButton(title: "Privacy Policy", image: "doc") {
                    print("privacy")
                }
                
                FitnessProfileButton(title: "Terms of Service", image: "doc") {
                    print("terms")
                }
                
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
