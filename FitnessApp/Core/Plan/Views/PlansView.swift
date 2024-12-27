//
//  PlansView.swift
//  FitnessApp
//
//  Created by Unicorn Semi on 27/12/2024.
//


import SwiftUI

struct PlansView: View {
    var body: some View {
        VStack {
            Text("Welcome to the Plans Page!")
                .font(.largeTitle)
                .padding()
            Spacer()
        }
    }
}

struct PlansView_Previews: PreviewProvider {
    static var previews: some View {
        PlansView()
    }
}

@StateObject private var viewModel = PlansViewModel()
