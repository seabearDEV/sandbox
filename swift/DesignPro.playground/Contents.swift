//
//  Untitled.swift
//  MyProject
//
//  Designed in DetailsPro
//  Copyright © (My Organization). All rights reserved.
//

import SwiftUI

struct Untitled: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.orange, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
            Rectangle()
                .frame(height: 300)
                .clipped()
                .mask { RoundedRectangle(cornerRadius: 16, style: .continuous) }
        }
    }
}

struct Untitled_Previews: PreviewProvider {
    static var previews: some View {
        Untitled()
    }
}
