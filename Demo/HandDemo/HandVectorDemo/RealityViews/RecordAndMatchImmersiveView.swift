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
    var body: some View {
        RealityView { content in
            
            let entity = Entity()
            entity.name = "GameRoot"
            model.rootEntity = entity
            content.add(entity)
            
            subscriptions.append(content.subscribe(to: SceneEvents.Update.self, on: nil, { event in
                guard let targetVector = model.recordHand else { return }
                
                let leftScore = model.latestHandTracking.leftHandVector?.similarity(of: .fiveFingers, to: targetVector) ?? 0
                model.leftScore = Int(leftScore * 100)
                let rightScore = model.latestHandTracking.rightHandVector?.similarity(of: .fiveFingers, to: targetVector) ?? 0
                model.rightScore = Int(rightScore * 100)
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
