import SwiftUI

struct PlansView: View {
    var body: some View {
        VStack {
            Text("Welcome to the Plans Page!")
                .font(.largeTitle)
                .padding()
            
            Text("Here you can manage your fitness plans.")
                .font(.body)
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
