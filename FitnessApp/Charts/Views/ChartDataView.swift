//
//  ChartDataView.swift
//  FitnessApp
//
//  Created by Jason Dubon on 8/9/23.
//

import SwiftUI

struct ChartDataView: View {
    @State var average: Int
    @State var total: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Average")
                    .font(.title2)
                
                Text("\(average)")
                    .font(.title3)
            }
            .frame(width: 90)
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
            }
            .frame(width: 90)
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
        ChartDataView(average: 1235, total: 8461)
    }
}
