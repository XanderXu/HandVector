//
//  HandViewModel.swift
//  Demo
//
//  Created by 许同学 on 2023/12/5.
//


import ARKit
import SwiftUI
import RealityKit
import HandVector

/// A model that contains up-to-date hand coordinate information.
@Observable
class HandViewModel: @unchecked Sendable {
    var turnOnImmersiveSpace = false
    
    var rootEntity: Entity?
    
    var latestHandTracking: HandVectorTool = .init(left: nil, right: nil)
    var handEmojiDict: [String: HandEmojiParameter] = [:]
    var recordHand: HandEmojiParameter?
    
    var leftScore: Int = 0
    var rightScore: Int = 0
    
    private let session = ARKitSession()
    private var handTracking = HandTrackingProvider()
    private var simHandProvider = SimulatorHandTrackingProvider()

    init() {
        self.handEmojiDict = HandEmojiParameter.generateParametersDict(fileName: "HandEmojiTotalJson")!
    }
    func clear() {
        rootEntity?.children.removeAll()
        latestHandTracking.left?.removeFromParent()
        latestHandTracking.right?.removeFromParent()
    }
    
    /// Resets game state information.
    func reset() {
        debugPrint(#function)
        
        leftScore = 0
        rightScore = 0
        
        clear()
    }
    
    func startHandTracking() async {
        do {
            if HandTrackingProvider.isSupported {
                print("ARKitSession starting.")
                try await session.run([handTracking])
            }
        } catch {
            print("ARKitSession error:", error)
        }
        
    }
    
    func publishHandTrackingUpdates() async {
        for await update in handTracking.anchorUpdates {
            switch update.event {
            case .added, .updated:
                let anchor = update.anchor
                guard anchor.isTracked else { continue }
                await latestHandTracking.updateHand(from: anchor)
                if let left = latestHandTracking.left {
                    await rootEntity?.addChild(left)
                }
                if let right = latestHandTracking.right {
                    await rootEntity?.addChild(right)
                }
            case .removed:
                let anchor = update.anchor
                latestHandTracking.removeHand(from: anchor)
            }
        }
    }
    
    func monitorSessionEvents() async {
        for await event in session.events {
            switch event {
            case .authorizationChanged(let type, let status):
                if type == .handTracking && status != .allowed {
                    // Stop the game, ask the user to grant hand tracking authorization again in Settings.
                    print("handTracking authorizationChanged \(status)")
                }
            default:
                print("Session event \(event)")
            }
        }
    }
  
    func publishSimHandTrackingUpdates() async {
        for await simHand in simHandProvider.simHands {
            if simHand.landmarks.isEmpty { continue }
            await latestHandTracking.updateHand(from: simHand)
            if let left = latestHandTracking.left {
                await rootEntity?.addChild(left)
            }
            if let right = latestHandTracking.right {
                await rootEntity?.addChild(right)
            }
        }
    }
    
}
