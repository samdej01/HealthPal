//
//  FitnessProfileEditButton.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/28/23.
//

import SwiftUI

struct FitnessProfileEditButton: View {
    @State var title: String
    @State var backgroundColor: Color
    var action: (() -> Void)
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .padding()
                .frame(maxWidth: 200)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundColor)
                )
        }
    }
}

struct FitnessProfileEditButton_Previews: PreviewProvider {
    static var previews: some View {
        FitnessProfileEditButton(title: "", backgroundColor: .red) {}
    }
}
