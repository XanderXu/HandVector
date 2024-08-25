//
//  MatchBuildinImmersiveView.swift
//  FingerDance
//
//  Created by 许同学 on 2024/1/8.
//

import SwiftUI
import RealityKit
import HandVector

struct MatchBuildinImmersiveView: View {
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
                if updateCount % 10 == 0 {
                    updateCount = 0
                    model.matchAllBuiltinHands()
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
    MatchBuildinImmersiveView()
}
