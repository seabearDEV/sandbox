import SwiftUI
import PlaygroundSupport

struct Split<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        HStack {
            content
        }
    }
}

struct ContentView: View {
    var body: some View {
        
        Split {
            Split {
                Color.red
                Split {
                    Color.blue
                    Color.yellow
                }
            }
        }
    }
}

// Use the method directly
PlaygroundPage.current.setLiveView(ContentView())
