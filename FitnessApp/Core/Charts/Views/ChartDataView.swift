//
//  ChartDataView.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/9/23.
//

import SwiftUI

struct ChartDataView: View {
    @Binding var average: Int
    @Binding var total: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Average")
                    .font(.title2)
                
                Text("\(average)")
                    .font(.title3)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .frame(width: 100)
            .foregroundColor(.black)
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
            
            VStack(spacing: 16) {
                
                Text("Total")
                    .font(.title2)
                
                Text("\(total)")
                    .font(.title3)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .frame(width: 100)
            .foregroundColor(.black)
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(10)
            
            
            Spacer()
        }
    }
}

struct ChartDataView_Previews: PreviewProvider {
    static var previews: some View {
        ChartDataView(average: .constant(1235), total: .constant(8461))
    }
}
