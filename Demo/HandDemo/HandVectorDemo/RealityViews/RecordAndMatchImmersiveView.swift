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
                guard let targetVector = model.recordHand?.convertToHandVectorMatcher(), targetVector.left != nil || targetVector.right != nil else { return }
                
                let targetLeft = targetVector.left ?? targetVector.right
                let targetRight = targetVector.right ?? targetVector.left
                
                let leftScore = model.latestHandTracking.leftHandVector?.similarity(of: HandVectorMatcher.allFingers, to: targetLeft!) ?? 0
                model.leftScore = Int(abs(leftScore) * 100)
                let rightScore = model.latestHandTracking.rightHandVector?.similarity(of: HandVectorMatcher.allFingers, to: targetRight!) ?? 0
                model.rightScore = Int(abs(rightScore) * 100)
            }))
#if targetEnvironment(simulator)
            model.latestHandTracking.isSkeletonVisible = true
#endif
        } update: { content in
            
            
        }
        
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
