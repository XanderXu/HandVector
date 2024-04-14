//
//  HandVectorApp.swift
//  HandVector
//
//  Created by 许同学 on 2023/9/17.
//

import SwiftUI

@main
struct HandVectorApp: App {
    @State private var model = HandViewModel()
    var body: some Scene {
        WindowGroup {
            HandVectorView()
                .environment(model)
//                .environment(\.locale, .init(identifier: "en"))
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 0.75, height: 0.5, depth: 0.5, in: .meters)

        ImmersiveSpace(id: Module.matchBuildin.immersiveId) {
            MatchBuildinImmersiveView()
                .environment(model)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
