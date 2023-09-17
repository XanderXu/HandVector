//
//  HandVectorApp.swift
//  HandVector
//
//  Created by 许同学 on 2023/9/17.
//

import SwiftUI

@main
struct HandVectorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView(gestureModel: HeartGestureModelContainer.heartGestureModel)
        }
        .immersionStyle(selection: .constant(.mixed), in: .mixed)
    }
}
@MainActor
enum HeartGestureModelContainer {
    private(set) static var heartGestureModel = HeartGestureModel()
}
