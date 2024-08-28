//
//  RecordAndMatchImmersiveView.swift
//  HandVectorDemo
//
//  Created by 许同学 on 2024/4/14.
//

import SwiftUI
import RealityKit
import HandVector

struct RecordAndMatchImmersiveView: View {
    @Environment(HandViewModel.self) private var model
    @State private var subscriptions = [EventSubscription]()
    @State private var updateCount: Int = 0
    var body: some View {
        RealityView { content in
            
            let entity = Entity()
            entity.name = "GameRoot"
            model.rootEntity = entity
            content.add(entity)
            
            subscriptions.append(content.subscribe(to: SceneEvents.Update.self, on: nil, { event in
                updateCount += 1
                // low down the update rate
                if updateCount % 15 == 0 {
                    updateCount = 0
                    model.matchRecordHandAndFingers()
                }
            }))

        } update: { content in
            
            
        }
        .upperLimbVisibility(model.latestHandTracking.isSkeletonVisible ? .hidden : .automatic)
        .task {
            await model.startHandTracking()
        }
        .task {
            await model.publishHandTrackingUpdates()
        }
        .task {
            await model.monitorSessionEvents()
        }
#if targetEnvironment(simulator)
        .task {
            await model.publishSimHandTrackingUpdates()
        }
#endif
    }
}

#Preview {
    RecordAndMatchImmersiveView()
}
