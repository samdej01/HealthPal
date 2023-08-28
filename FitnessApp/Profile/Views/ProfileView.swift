//
//  ProfileView.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/28/23.
//

import SwiftUI

struct ProfileView: View {
    @AppStorage("profileName") var profileName: String?
    @AppStorage("profileImage") var profileImage: String?
    
    @State private var isEditingName = true
    @State private var currentName = ""
    
    @State private var isEditingImage = false
    @State private var selectedImage: String?
    
    @State private var images = [
        "avatar 1", "avatar 2", "avatar 3", "avatar 4", "avatar 5", "avatar 6", "avatar 7", "avatar 8", "avatar 9", "avatar 10"
    ]
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(profileImage ?? "avatar 1")
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
                            isEditingName = false
                            isEditingImage = true
                        }
                    }
                
                VStack(alignment: .leading) {
                    Text("Good morning,")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.5)
                    
                    Text(profileName ?? "Name")
                        .font(.title)
                }
            }
            
            if isEditingName {
                TextField("Name ...", text: $currentName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
                HStack {
                    FitnessProfileEditButton(title: "Cancel", backgroundColor: .gray.opacity(0.1)) {
                        withAnimation {
                            isEditingName = false
                        }
                    }
                    .foregroundColor(.red)
                    
                    FitnessProfileEditButton(title: "Done", backgroundColor: .primary) {
                        if !currentName.isEmpty {
                            withAnimation {
                                profileName = currentName
                                isEditingName = false
                            }
                        }
                    }
                    .foregroundColor(Color(uiColor: .systemBackground))
                }
            }
            
            if isEditingImage {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(images, id: \.self) { image in
                            Button {
                                withAnimation {
                                    selectedImage = image
                                }
                            } label: {
                                VStack {
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                    
                                    if selectedImage == image {
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
                        profileImage = selectedImage
                        isEditingImage = false
                    }
                }
                .foregroundColor(Color(uiColor: .systemBackground))
                .padding(.bottom)
            }
            
            VStack {
                FitnessProfileItemButton(title: "Edit Name", image: "square.and.pencil") {
                    withAnimation {
                        isEditingName = true
                        isEditingImage = false
                    }
                }
                
                FitnessProfileItemButton(title: "Edit Image", image: "square.and.pencil") {
                    withAnimation {
                        isEditingName = false
                        isEditingImage = true
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
            
            VStack {
                FitnessProfileItemButton(title: "Contact Us", image: "envelope") {
                    print("contact")
                }
                
                FitnessProfileItemButton(title: "Privacy Policy", image: "doc") {
                    print("privacy")
                }
                
                FitnessProfileItemButton(title: "Terms of Service", image: "doc") {
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
        .onAppear {
            selectedImage = profileImage
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
