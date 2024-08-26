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
            
            let builtinHands = HVHandInfo.builtinHandInfo
            subscriptions.append(content.subscribe(to: SceneEvents.Update.self, on: nil, { event in
                updateCount += 1
                // low down the update rate
                if updateCount % 15 == 0 {
                    updateCount = 0
                    builtinHands.forEach { (key, value) in
                        model.leftScores[key] = model.latestHandTracking.leftHandVector?.similarity(of: .fiveFingers, to: value)
                        model.rightScores[key] = model.latestHandTracking.rightHandVector?.similarity(of: .fiveFingers, to: value)
                    }
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
