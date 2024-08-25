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
//                .environment(\.locale, .init(identifier: "zh-Hans"))
        }
        .windowResizability(.contentSize)
        .defaultSize(width: 1, height: 0.6, depth: 0.1, in: .meters)

        ImmersiveSpace(id: Module.matchAllBuiltin.immersiveId) {
            MatchBuildinImmersiveView()
                .environment(model)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
        
        ImmersiveSpace(id: Module.recordAndMatch.immersiveId) {
            RecordAndMatchImmersiveView()
                .environment(model)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
        
        
    }
}
