//
//  PlansViewModel.swift
//  FitnessApp
//
//  Created by Unicorn Semi on 27/12/2024.
//


import Foundation

class PlansViewModel: ObservableObject {
    // Add properties and methods to handle Plans data
    @Published var plans: [String] = ["Plan 1", "Plan 2", "Plan 3"]
}

List(viewModel.plans, id: \.self) { plan in
    Text(plan)
}
