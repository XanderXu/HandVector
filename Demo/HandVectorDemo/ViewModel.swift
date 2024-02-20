//
//  ViewModel.swift
//  Demo
//
//  Created by 许同学 on 2023/12/5.
//


import ARKit
import SwiftUI
import RealityKit
//import HandVector

/// A model that contains up-to-date hand coordinate information.
@Observable
class ViewModel: @unchecked Sendable {
    var showGuideImmersiveSpace = false
    
    var isHandSkeletonVisible = false
    var rootEntity: Entity?
    
    var latestHandTracking: HandVector = .init(left: nil, right: nil)
    var handEmojiDict: [String: HandEmojiParameter] = [:]
    var simHandProvider = SimulatorHandTrackingProvider()
    
    var leftScore: Int = 0
    var rightScore: Int = 0
    private let session = ARKitSession()
    private var handTracking = HandTrackingProvider()
    
    
    

    
    var score = 0
    
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
        score = 0
        
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
            case .added:
                let anchor = update.anchor
                await latestHandTracking.updateHand(from: anchor)
                if let left = latestHandTracking.left {
                    await rootEntity?.addChild(left)
                }
                if let right = latestHandTracking.right {
                    await rootEntity?.addChild(right)
                }
            case .updated:
                let anchor = update.anchor
                // Publish updates only if the hand and the relevant joints are tracked.
                guard anchor.isTracked else { continue }
                await latestHandTracking.updateHand(from: anchor)
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
