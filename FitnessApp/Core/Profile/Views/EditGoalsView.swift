
import SwiftUI

struct EditGoalsView: View {
    @Environment(ProfileViewModel.self) var viewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Form {
                    HStack {
                        Stepper {
                            Text("Step Count: \(viewModel.stepGoal)")
                        } onIncrement: {
                            viewModel.stepGoal += 100
                        } onDecrement: {
                            viewModel.stepGoal -= 100
                        }
                    }
                    
                    HStack {
                        Stepper {
                            Text("Calories: \(viewModel.caloriesGoal)")
                        } onIncrement: {
                            viewModel.caloriesGoal += 50
                        } onDecrement: {
                            viewModel.caloriesGoal -= 50
                        }
                    }
                    
                    HStack {
                        Stepper {
                            Text("Active Time: \(viewModel.activeGoal)")
                        } onIncrement: {
                            viewModel.activeGoal += 5
                        } onDecrement: {
                            viewModel.activeGoal -= 5
                        }
                    }
                    
                    HStack {
                        Stepper {
                            Text("Stand Hours: \(viewModel.standGoal)")
                        } onIncrement: {
                            viewModel.standGoal += 1
                        } onDecrement: {
                            viewModel.standGoal -= 1
                        }
                    }
                    
                    Button {
                        viewModel.saveUserGoals()
                    } label: {
                        Text("Done")
                    }
                }
            }
            .navigationTitle("Goals")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    EditGoalsView()
}
