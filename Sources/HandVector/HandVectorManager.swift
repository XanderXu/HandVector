//
//  HandVectorTool.swift
//  FingerDance
//
//  Created by 许同学 on 2023/12/24.
//

import RealityKit
import ARKit

public class HandVectorManager {
    public var left: Entity?
    public var right: Entity?
    
    public var leftHandVector: HVHandInfo?
    public var rightHandVector: HVHandInfo?
    
    public init(left: Entity? = nil, right: Entity? = nil, leftHandVector: HVHandInfo? = nil, rightHandVector: HVHandInfo? = nil) {
        self.left = left
        self.right = right
        self.leftHandVector = leftHandVector
        self.rightHandVector = rightHandVector
    }
    
    public var isSkeletonVisible: Bool = false {
        didSet {
            for name in HandSkeleton.JointName.allCases {
                let modelEntityLeft = left?.findEntity(named: name.codableName.rawValue + "-model")
                modelEntityLeft?.isEnabled = isSkeletonVisible
                
                let modelEntityRight = right?.findEntity(named: name.codableName.rawValue + "-model")
                modelEntityRight?.isEnabled = isSkeletonVisible
            }
        }
    }
    public var isCollisionEnable: Bool = false {
        didSet {
            for name in HandSkeleton.JointName.allCases {
                let modelEntityLeft = left?.findEntity(named: name.codableName.rawValue + "-collision")
                modelEntityLeft?.isEnabled = isCollisionEnable
                
                let modelEntityRight = right?.findEntity(named: name.codableName.rawValue + "-collision")
                modelEntityRight?.isEnabled = isCollisionEnable
            }
        }
    }
    
    @discardableResult
    public func generateHandInfo(from handAnchor: HandAnchor) -> HVHandInfo? {
        let handInfo = HVHandInfo(handAnchor: handAnchor)
        if handAnchor.chirality == .left {
            leftHandVector = handInfo
        } else {
            rightHandVector = handInfo
        }
        return handInfo
    }
    
    @MainActor
    @discardableResult
    public func generateHandSkeletonEntity(from handInfo: HVHandInfo, to: Entity?, filter: CollisionFilter = .default) async -> Entity {
        let entity = generateHandEntity(from: handInfo, filter: filter)
        to?.addChild(entity)
        if handInfo.chirality == .left {
            self.left = entity
        } else if handInfo.chirality == .right {
            self.right = entity
        }
        return entity
    }
    
    @MainActor
    public func updateHandSkeletonEntity(from handInfo: HVHandInfo) async {
        if handInfo.chirality == .left {
            updateHandEntity(from: handInfo, to: left!)
        } else if handInfo.chirality == .right {
            updateHandEntity(from: handInfo, to: right!)
        }
    }
    public func removeHand(from handAnchor: HandAnchor) {
        if handAnchor.chirality == .left {
            left?.removeFromParent()
            left = nil
            leftHandVector = nil
        } else if handAnchor.chirality == .right { // Update right hand info.
            right?.removeFromParent()
            right = nil
            rightHandVector = nil
        }
    }
    

    public static let simHandPositionY: Float = 1.4
    @MainActor
    public func updateHand(from simHand: SimHand, filter: CollisionFilter = .default) async {
        let handVectors = simHand.convertToHandVector(offset: .init(0, Self.simHandPositionY, -0.2))
        leftHandVector = handVectors.left
        if let leftHandVector {
            if left == nil {
                left = generateHandEntity(from: leftHandVector, filter: filter)
            } else {
                left?.isEnabled = true
                updateHandEntity(from: leftHandVector, to: left!)
            }
        } else {
            left?.isEnabled = false
        }
        
        rightHandVector = handVectors.right
        if let rightHandVector {
            if right == nil {
                right = generateHandEntity(from: rightHandVector, filter: filter)
            } else {
                right?.isEnabled = true
                updateHandEntity(from: rightHandVector, to: right!)
            }
        } else {
            right?.isEnabled = false
        }
    }
    
    @MainActor
    private func generateHandEntity(from handVector: HVHandInfo, filter: CollisionFilter = .default) -> Entity {
        let hand = Entity()
        hand.name = handVector.chirality == .left ? "leftHand" : "rightHand"
        hand.transform.matrix = handVector.transform
        
        let wm = SimpleMaterial(color: .white, isMetallic: false)
        let rm = SimpleMaterial(color: .red, isMetallic: false)
        let gm = SimpleMaterial(color: .green, isMetallic: false)
        let bm = SimpleMaterial(color: .blue, isMetallic: false)
        let rnm = SimpleMaterial(color: .init(red: 0.5, green: 0, blue: 0, alpha: 1), isMetallic: false)
        let gnm = SimpleMaterial(color: .init(red: 0, green: 0.5, blue: 0, alpha: 1), isMetallic: false)
        let bnm = SimpleMaterial(color: .init(red: 0, green: 0, blue: 0.5, alpha: 1), isMetallic: false)
        for positionInfo in handVector.allJoints.values {
            let modelEntity = ModelEntity(mesh: .generateBox(width: 0.015, height: 0.015, depth: 0.015, splitFaces: true), materials: [bm, gm, bnm, gnm, rm, rnm])//[+z, +y, -z, -y, +x, -x]
            modelEntity.transform.matrix = positionInfo.transform
            modelEntity.name = positionInfo.name.codableName.rawValue + "-model"
            modelEntity.isEnabled = isSkeletonVisible
            hand.addChild(modelEntity)
            
            let collisionEntity = Entity()
            collisionEntity.components.set(CollisionComponent(shapes: [.generateBox(width: 0.015, height: 0.015, depth: 0.015)], filter: filter))
            collisionEntity.transform.matrix = positionInfo.transform
            collisionEntity.name = positionInfo.name.codableName.rawValue + "-collision"
            collisionEntity.isEnabled = isCollisionEnable
            hand.addChild(collisionEntity)
        }
        return hand
    }
    private func updateHandEntity(from handVector: HVHandInfo, to: Entity) {
        to.transform.matrix = handVector.transform
        for positionInfo in handVector.allJoints.values {
            let modelEntity = to.findEntity(named: positionInfo.name.codableName.rawValue + "-model")
            modelEntity?.transform.matrix = positionInfo.transform
            modelEntity?.isEnabled = isSkeletonVisible
            
            let collisionEntity = to.findEntity(named: positionInfo.name.codableName.rawValue + "-collision")
            collisionEntity?.transform.matrix = positionInfo.transform
            collisionEntity?.isEnabled = isCollisionEnable
        }
    }
}



