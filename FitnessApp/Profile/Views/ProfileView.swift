//
//  ProfileView.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/28/23.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(viewModel.profileImage ?? "avatar 1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.all, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.25))
                    )
                    .onTapGesture {
                        withAnimation {
                            viewModel.presentEditImage()
                        }
                    }
                
                VStack(alignment: .leading) {
                    Text("Good morning,")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.5)
                    
                    Text(viewModel.profileName ?? "Name")
                        .font(.title)
                }
            }
            
            if viewModel.isEditingName {
                TextField("Name ...", text: $viewModel.currentName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
                HStack {
                    FitnessProfileEditButton(title: "Cancel", backgroundColor: .gray.opacity(0.1)) {
                        withAnimation {
                            viewModel.dismissEdit()
                        }
                    }
                    .foregroundColor(.red)
                    
                    FitnessProfileEditButton(title: "Done", backgroundColor: .primary) {
                        if !viewModel.currentName.isEmpty {
                            viewModel.setNewName()
                        }
                    }
                    .foregroundColor(Color(uiColor: .systemBackground))
                }
            }
            
            if viewModel.isEditingImage {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.images, id: \.self) { image in
                            Button {
                                withAnimation {
                                    viewModel.didSelectNewImage(name: image)
                                }
                            } label: {
                                VStack {
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                    
                                    if viewModel.selectedImage == image {
                                        Circle()
                                            .frame(width: 16, height: 16)
                                            .foregroundColor(.primary)
                                    }
                                }
                                .padding()
                            }

                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.15))
                )
                
                FitnessProfileEditButton(title: "Done", backgroundColor: .primary) {
                    withAnimation {
                        viewModel.setNewImage()
                    }
                }
                .foregroundColor(Color(uiColor: .systemBackground))
                .padding(.bottom)
            }
            
            VStack {
                FitnessProfileItemButton(title: "Edit Name", image: "square.and.pencil") {
                    withAnimation {
                        viewModel.presentEditName()
                    }
                }
                
                FitnessProfileItemButton(title: "Edit Image", image: "square.and.pencil") {
                    withAnimation {
                        viewModel.presentEditImage()
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
            
            VStack {
                FitnessProfileItemButton(title: "Contact Us", image: "envelope") {
                    viewModel.presentEmailApp()
                }
                
                Link(destination: URL(string: "https://github.com/MexJason/SwiftUI-Course/blob/main/policy.md")!) {
                    HStack {
                        Image(systemName: "doc")
                        
                        Text("Privacy Policy")
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Link(destination: URL(string: "https://github.com/MexJason/SwiftUI-Course/blob/main/terms.md")!) {
                    HStack {
                        Image(systemName: "doc")
                        
                        Text("Terms of Service")
                    }
                    .foregroundColor(.primary)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .alert("Oops", isPresented: $viewModel.showAlert) {
            Text("Ok")
        } message: {
            Text("We were unable to open your mail application. Please make sure you have one installed.")
        }

    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
