//
//  PaywallView.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/11/23.
//

import SwiftUI

struct FitnessPaywallView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel = PaywallViewModel()
    @Binding var isPremium: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Premium Membership")
                .font(.largeTitle)
                .bold()
            
            Text("Get fit, get active, today")
            
            Spacer()
            
            // Features
            VStack(spacing: 36) {
                HStack {
                    Image(systemName: "figure.run")
                    
                    Text("Exercise boosts energy levels and promotes vitality.")
                        .lineLimit(1)
                        .font(.system(size: 14))
                        .minimumScaleFactor(0.6)
                }
                
                HStack {
                    Image(systemName: "chart.xyaxis.line")
                    
                    Text("Track your monthly workouts and activity.")
                        .lineLimit(1)
                        .font(.system(size: 14))
                        .minimumScaleFactor(0.6)
                }
                
                HStack {
                    Image(systemName: "person.3.fill")
                    
                    Text("Join the commmunity of people changing their lives.")
                        .lineLimit(1)
                        .font(.system(size: 14))
                        .minimumScaleFactor(0.6)
                }
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                if let offering = viewModel.currentOffering {
                    ForEach(offering.availablePackages) { package in
                        Button {
                            Task {
                                do {
                                    try await viewModel.purchase(package: package)
                                    isPremium = true
                                    dismiss()
                                } catch {
                                    print(error.localizedDescription)
                                }
                            }
                        } label: {
                            VStack(spacing: 8) {
                                Text(package.storeProduct.subscriptionPeriod?.durationTitle ?? "Subscription")
                                    .font(.title3)
                                    .bold()
                                
                                Text(package.storeProduct.localizedPriceString)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.vertical)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .foregroundColor(.green)
                                .shadow(radius: 3)
                        )
                    }
                }
            }
            .padding(.horizontal)
            
            
            Button {
                Task {
                    do {
                        try await viewModel.restorePurchases()
                        isPremium = true
                        dismiss()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } label: {
                Text("Restore Purchases")
                    .foregroundColor(.green)
                    .underline()
            }
            .padding()

            Spacer()
            
            HStack(spacing: 16) {
                Link("Terms of Service", destination: URL(string: "https://github.com/MexJason")!)
                
                Circle()
                    .frame(maxWidth: 8)
                
                Link("Privacy Policy", destination: URL(string: "https://github.com/MexJason")!)
            }
            .foregroundColor(.green)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.top)
    }
}

struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        FitnessPaywallView(isPremium: .constant(false))
    }
}
