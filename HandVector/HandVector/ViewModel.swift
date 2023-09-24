/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Hand tracking updates.
*/

#if targetEnvironment(simulator)
import ARKit
#else
@preconcurrency import ARKit
#endif
import SwiftUI

/// A model that contains up-to-date hand coordinate information.
@Observable
class ViewModel: @unchecked Sendable {
    let session = ARKitSession()
    var handTracking = HandTrackingProvider()
    var latestHandTracking: HandsUpdates = .init(left: nil, right: nil)
    var recordedHand: HandVector?
    
    struct HandsUpdates {
        var left: HandAnchor?
        var right: HandAnchor?
    }
    
    func start() async {
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
            case .updated:
                let anchor = update.anchor
                
                // Publish updates only if the hand and the relevant joints are tracked.
                guard anchor.isTracked else { continue }
                
                // Update left hand info.
                if anchor.chirality == .left {
                    latestHandTracking.left = anchor
                } else if anchor.chirality == .right { // Update right hand info.
                    latestHandTracking.right = anchor
                }
            default:
                break
            }
        }
    }
    
    func monitorSessionEvents() async {
        for await event in session.events {
            switch event {
            case .authorizationChanged(let type, let status):
                if type == .handTracking && status != .allowed {
                    // Stop the game, ask the user to grant hand tracking authorization again in Settings.
                }
            default:
                print("Session event \(event)")
            }
        }
    }
  
    func record() {
        let pose = HandSkeleton.neutralPose
        recordedHand = HandVector(chirality: .left, handSkeleton: pose)
    }
    
    func match() {
        let pose = HandSkeleton.neutralPose
        let vector = HandVector(chirality: .left, handSkeleton: pose)
        let similary = recordedHand?.compare(vector) ?? 0
    }
    
}
