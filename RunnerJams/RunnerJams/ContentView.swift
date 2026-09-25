//
//  ContentView.swift
//  RunnerJams
//
//  Created by Jorge Villeda on 9/24/26.
//

import RunnerJamsCore
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "figure.run")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Runner Jams")
            Text("Core \(RunnerJamsCore.version)")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
