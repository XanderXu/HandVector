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
    var body: some View {
        RealityView { content in
            
            let entity = Entity()
            entity.name = "GameRoot"
            model.rootEntity = entity
            content.add(entity)
            
            
            guard let okVector = model.handEmojiDict["👌"]?.convertToHandVectorMatcher(), let leftOKVector = okVector.left else { return }
            
            subscriptions.append(content.subscribe(to: SceneEvents.Update.self, on: nil, { event in
                let leftScore = model.latestHandTracking.leftHandVector?.similarity(of: HandVectorMatcher.allFingers, to: leftOKVector) ?? 0
                model.leftScore = Int(abs(leftScore) * 100)
                let rightScore = model.latestHandTracking.rightHandVector?.similarity(of: HandVectorMatcher.allFingers, to: leftOKVector) ?? 0
                model.rightScore = Int(abs(rightScore) * 100)
            }))

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
    MatchBuildinImmersiveView()
}
