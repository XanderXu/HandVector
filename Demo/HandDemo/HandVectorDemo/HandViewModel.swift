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
    
    var latestHandTracking: HandVectorManager = .init(left: nil, right: nil)
    var recordHand: HVHandInfo?
    var averageAndEachLeftScores: (average: Float, eachFinger: [HVJointOfFinger: Float])?
    var averageAndEachRightScores: (average: Float, eachFinger: [HVJointOfFinger: Float])?
    
    var leftScores: [String: Float] = [:]
    var rightScores: [String: Float] = [:]
    
    var leftFingerShapes: [HVJointOfFinger: HVFingerShape] = [:]
    var rightFingerShapes: [HVJointOfFinger: HVFingerShape] = [:]
    
    private let session = ARKitSession()
    private let worldTracking = WorldTrackingProvider()
    private let handTracking = HandTrackingProvider()
    private let simHandProvider = SimulatorHandTrackingProvider()

    init() {
        latestHandTracking.isCollisionEnable = true
    }
    func clear() {
        rootEntity?.children.removeAll()
        latestHandTracking.left?.removeFromParent()
        latestHandTracking.right?.removeFromParent()
    }
    
    /// Resets game state information.
    func reset() {
        debugPrint(#function)
        
        leftScores = [:]
        rightScores = [:]
        
        averageAndEachLeftScores = nil
        averageAndEachRightScores = nil
        
        leftFingerShapes = [:]
        rightFingerShapes = [:]
        
        clear()
    }
    func matchAllBuiltinHands() {
        let builtinHands = HVHandInfo.builtinHandInfo
        builtinHands.forEach { (key, value) in
            leftScores[key] = latestHandTracking.leftHandVector?.similarity(of: .fiveFingers, to: value)
            rightScores[key] = latestHandTracking.rightHandVector?.similarity(of: .fiveFingers, to: value)
        }
    }
    func matchRecordHandAndFingers() {
        if let recordHand {
            averageAndEachLeftScores = latestHandTracking.leftHandVector?.averageAndEachSimilarities(of: .fiveFingers, to: recordHand)
            averageAndEachRightScores = latestHandTracking.rightHandVector?.averageAndEachSimilarities(of: .fiveFingers, to: recordHand)
        }
    }
    func calculateFingerShapes() {
        leftFingerShapes[.thumb] = latestHandTracking.leftHandVector?.calculateFingerShape(finger: .thumb)
        leftFingerShapes[.indexFinger] = latestHandTracking.leftHandVector?.calculateFingerShape(finger: .indexFinger)
        leftFingerShapes[.middleFinger] = latestHandTracking.leftHandVector?.calculateFingerShape(finger: .middleFinger)
        leftFingerShapes[.ringFinger] = latestHandTracking.leftHandVector?.calculateFingerShape(finger: .ringFinger)
        leftFingerShapes[.littleFinger] = latestHandTracking.leftHandVector?.calculateFingerShape(finger: .littleFinger)
        
        rightFingerShapes[.thumb] = latestHandTracking.rightHandVector?.calculateFingerShape(finger: .thumb)
        rightFingerShapes[.indexFinger] = latestHandTracking.rightHandVector?.calculateFingerShape(finger: .indexFinger)
        rightFingerShapes[.middleFinger] = latestHandTracking.rightHandVector?.calculateFingerShape(finger: .middleFinger)
        rightFingerShapes[.ringFinger] = latestHandTracking.rightHandVector?.calculateFingerShape(finger: .ringFinger)
        rightFingerShapes[.littleFinger] = latestHandTracking.rightHandVector?.calculateFingerShape(finger: .littleFinger)
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
                guard anchor.isTracked else {
                    continue
                }
                let handInfo = latestHandTracking.generateHandInfo(from: anchor)
                if let handInfo {
                    await latestHandTracking.updateHandSkeletonEntity(from: handInfo)
                    if let left = latestHandTracking.left {
                        await rootEntity?.addChild(left)
                    }
                    if let right = latestHandTracking.right {
                        await rootEntity?.addChild(right)
                    }
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
