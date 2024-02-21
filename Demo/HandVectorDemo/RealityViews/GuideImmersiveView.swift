//
//  GuideImmersiveView.swift
//  FingerDance
//
//  Created by 许同学 on 2024/1/8.
//

import SwiftUI
import RealityKit
import HandVector

struct GuideImmersiveView: View {
    @Environment(ViewModel.self) private var model
    @State private var subscriptions = [EventSubscription]()
    var body: some View {
        RealityView { content in
            
            let entity = Entity()
            entity.name = "GameRoot"
            model.rootEntity = entity
            
            model.handEmojiDict = HandEmojiParameter.generateParametersDict(fileName: "HandEmojiTotalJson", bundle:handAssetsBundle)!
            guard let okVector = model.handEmojiDict["👌"]?.convertToHandVector(), let leftOKVector = okVector.left else { return }
            
            subscriptions.append(content.subscribe(to: SceneEvents.Update.self, on: nil, { event in
                let leftScore = model.latestHandTracking.leftHandVector?.similarity(to: leftOKVector) ?? 0
                model.leftScore = Int(abs(leftScore) * 100)
                let rightScore = model.latestHandTracking.rightHandVector?.similarity(to: leftOKVector) ?? 0
                model.rightScore = Int(abs(rightScore) * 100)
            }))
#if targetEnvironment(simulator)
            model.isHandSkeletonVisible = true
            model.latestHandTracking.isSkeletonVisible = true
#endif
        } update: { content in
            
            
        }
        .onChange(of: model.isHandSkeletonVisible, { oldValue, newValue in
            model.latestHandTracking.isSkeletonVisible = newValue
        })
        
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
    GuideImmersiveView()
}
