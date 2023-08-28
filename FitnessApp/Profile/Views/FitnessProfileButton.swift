//
//  FitnessProfileButton.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/28/23.
//

import SwiftUI

struct FitnessProfileButton: View {
    @State var title: String
    @State var image: String
    var action: (() -> Void)
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: image)
                
                Text(title)
            }
            .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FitnessProfileButton_Previews: PreviewProvider {
    static var previews: some View {
        FitnessProfileButton(title: "Edit image", image: "square.and.pencil") {}
    }
}
