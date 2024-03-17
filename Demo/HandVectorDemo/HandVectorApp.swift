//
//  HandVectorApp.swift
//  HandVector
//
//  Created by 许同学 on 2023/9/17.
//

import SwiftUI

@main
struct HandVectorApp: App {
    @State private var model = ViewModel()
    var body: some Scene {
        WindowGroup {
            Guide()
                .environment(model)
//                .environment(\.locale, .init(identifier: "en"))
        }
        .windowStyle(.automatic)

        ImmersiveSpace(id: "ImmersiveSpace") {
            GuideImmersiveView()
                .environment(model)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
