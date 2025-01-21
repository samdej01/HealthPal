import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()

    @State private var email = ""
    @State private var password = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    HStack(spacing: 16) {
                        Button {
                            withAnimation {
                                viewModel.presentEditImage()
                            }
                        } label: {
                            Image(viewModel.profileImage ?? "avatar 1")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(.gray.opacity(0.25))
                                )
                        }

                        VStack(alignment: .leading) {
                            Text(Date.now.timeOfDayGreeting())
                                .font(.title)
                                .foregroundColor(.gray)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)

                            Text(viewModel.profileName ?? "Name")
                                .font(.title2)
                                .lineLimit(1)
                                .minimumScaleFactor(0.4)
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
                                viewModel.setNewName()
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
                        .frame(maxWidth: .infinity, alignment: .center)
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

                        FitnessProfileItemButton(title: "Edit Goals", image: "gearshape") {
                            withAnimation {
                                viewModel.presentGoal = true
                            }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.15))
                    )

                    // Notification toggle
                    Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray.opacity(0.15))
                        )

                    // Login/Register Section
                    if viewModel.isUserLoggedIn {
                        Text("Logged in as: \(viewModel.profileName ?? "User")")
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(.green.opacity(0.15))
                            )

                        Button("Logout") {
                            viewModel.logoutUser()
                        }
                        .padding()
                        .foregroundColor(.red)
                    } else {
                        VStack {
                            TextField("Email", text: $email)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            SecureField("Password", text: $password)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            Button("Login") {
                                viewModel.loginUser(email: email, password: password)
                            }
                            .padding()
                            Button("Register") {
                                viewModel.registerUser(email: email, password: password)
                            }
                            .padding()
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.gray.opacity(0.15))
                        )
                    }

                    VStack {
                        FitnessProfileItemButton(title: "Contact Us", image: "envelope") {
                            viewModel.presentEmailApp()
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.15))
                    )
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .sheet(isPresented: $viewModel.presentGoal) {
                    EditGoalsView()
                        .presentationDetents([.fraction(0.55)])
                        .environment(viewModel)
                }
                .alert("Oops", isPresented: $viewModel.showAlert) {
                    Button(role: .cancel) {
                        viewModel.showAlert = false
                    } label: {
                        Text("Ok")
                    }
                } message: {
                    Text("We were unable to open your mail application. Please make sure you have one installed.")
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
