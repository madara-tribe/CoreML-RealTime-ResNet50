import SwiftUI

struct ContentView: View {
    var body: some View {
        CameraViewController()
            .edgesIgnoringSafeArea(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

