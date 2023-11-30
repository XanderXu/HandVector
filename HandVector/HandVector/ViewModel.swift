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
    var recordedLeftHand: HandVector?
    var recordedRightHand: HandVector?
    var matchRateLeft: Float = 0
    var matchRateRight: Float = 0
    
    var isContinuousMatching = false
    
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
                    if isContinuousMatching {
                        let vector = HandVector(chirality: .left, handSkeleton: anchor.handSkeleton!)
                        matchRateLeft = recordedLeftHand?.similarity(to: vector) ?? 0
                    }
                } else if anchor.chirality == .right { // Update right hand info.
                    latestHandTracking.right = anchor
                    if isContinuousMatching {
                        let vector = HandVector(chirality: .right, handSkeleton: anchor.handSkeleton!)
                        matchRateRight = recordedRightHand?.similarity(to: vector) ?? 0
                    }
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
        if let left = latestHandTracking.left?.handSkeleton {
            recordedLeftHand = HandVector(chirality: .left, handSkeleton: left)
        }
        if let right = latestHandTracking.right?.handSkeleton {
            recordedRightHand = HandVector(chirality: .right, handSkeleton: right)
        }
        saveRecordJson()
    }
    
    func saveRecordJson() {
        if let left = recordedLeftHand {
            debugPrint(left.toJson()!)
//            let newLeft: HandVector? = left.toJson()?.toModel()
//            debugPrint(newLeft)
        }
        if let right = recordedRightHand {
            debugPrint(right.toJson()!)
//            let newRight: HandVector? = right.toJson()?.toModel()
//            debugPrint(newRight)
        }
    }
    
    
    func matchOnce() {
        if let left = latestHandTracking.left?.handSkeleton {
            let vector = HandVector(chirality: .left, handSkeleton: left)
            matchRateLeft = recordedLeftHand?.similarity(to: vector) ?? 0
        }
        if let right = latestHandTracking.right?.handSkeleton {
            let vector = HandVector(chirality: .right, handSkeleton: right)
            matchRateRight = recordedRightHand?.similarity(to: vector) ?? 0
        }
    }
}
