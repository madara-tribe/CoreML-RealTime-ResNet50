import SwiftUI

struct ContentView: View {
    @State private var isStart = false
    @State private var isText = true
    var body: some View {
        VStack {
            Image("waiting")
            Button(action:{
                isStart.toggle()
                isText.toggle()
            }, label:{
                Text(isText ? "Start PX1" : "ReStart PX1")
                    .padding()
            })
            .sheet(isPresented:$isStart){
                CameraViewController()
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

