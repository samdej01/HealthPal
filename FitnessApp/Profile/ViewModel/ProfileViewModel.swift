//
//  ProfileViewModel.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/28/23.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var isEditingName = true
    @Published var currentName = ""
    @Published var profileName: String? = UserDefaults.standard.string(forKey: "profileName")
    
    @Published var isEditingImage = false
    @Published var profileImage: String? = UserDefaults.standard.string(forKey: "profileImage")
    @Published var selectedImage: String? = UserDefaults.standard.string(forKey: "profileImage")
    
    var images = [
        "avatar 1", "avatar 2", "avatar 3", "avatar 4", "avatar 5", "avatar 6", "avatar 7", "avatar 8", "avatar 9", "avatar 10"
    ]
    
    func presentEditName() {
        isEditingName = true
        isEditingImage = false
    }
    
    func presentEditImage() {
        isEditingName = false
        isEditingImage = true
    }
    
    func dismissEdit() {
        isEditingName = false
        isEditingImage = false
    }
    
    func setNewName() {
        profileName = currentName
        UserDefaults.standard.setValue(currentName, forKey: "profileName")
        self.dismissEdit()
    }
    
    func didSelectNewImage(name: String) {
        selectedImage = name
    }
    
    func setNewImage() {
        profileImage = selectedImage
        UserDefaults.standard.setValue(selectedImage, forKey: "profileImage")
        self.dismissEdit()
    }
    
}
