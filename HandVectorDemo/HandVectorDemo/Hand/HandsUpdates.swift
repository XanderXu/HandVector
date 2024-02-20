//
//  HandsUpdates.swift
//  FingerDance
//
//  Created by 许同学 on 2023/12/24.
//

import RealityKit
import ARKit

//手部关节模型
class HandsUpdates {
    var left: Entity?
    var right: Entity?
    
    var leftHandVector: HandVectorMatcher?
    var rightHandVector: HandVectorMatcher?
    
    init(left: Entity? = nil, right: Entity? = nil, leftHandVector: HandVectorMatcher? = nil, rightHandVector: HandVectorMatcher? = nil) {
        self.left = left
        self.right = right
        self.leftHandVector = leftHandVector
        self.rightHandVector = rightHandVector
    }
    
    var isSkeletonVisible: Bool = false {
        didSet {
            for name in HandSkeleton.JointName.allCases {
                let modelEntityLeft = left?.findEntity(named: name.codableName.rawValue + "-model")
                modelEntityLeft?.isEnabled = isSkeletonVisible
                
                let modelEntityRight = right?.findEntity(named: name.codableName.rawValue + "-model")
                modelEntityRight?.isEnabled = isSkeletonVisible
            }
        }
    }
    @MainActor
    func updateHand(from handAnchor: HandAnchor) async {
        if handAnchor.chirality == .left {
            leftHandVector = HandVectorMatcher(handAnchor: handAnchor)
            if left == nil {
                left = generateHandEntity(from: handAnchor)
            } else {
                updateHandEntity(from: handAnchor, to: left!)
            }
        } else if handAnchor.chirality == .right { // Update right hand info.
            rightHandVector = HandVectorMatcher(handAnchor: handAnchor)
            if right == nil {
                right = generateHandEntity(from: handAnchor)
            } else {
                updateHandEntity(from: handAnchor, to: right!)
            }
        }
    }
    func removeHand(from handAnchor: HandAnchor) {
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
    
    private func generateHandEntity(from handAnchor: HandAnchor) -> Entity {
        let hand = Entity()
        hand.name = handAnchor.chirality == .left ? "leftHand" : "rightHand"
        hand.transform.matrix = handAnchor.originFromAnchorTransform
        if let skeleton = handAnchor.handSkeleton {
            let wm = SimpleMaterial(color: .white, isMetallic: false)
            let rm = SimpleMaterial(color: .red, isMetallic: false)
            for joint in skeleton.allJoints {
                let m = (joint.name == .wrist || joint.name == .forearmWrist) ? rm : wm
                let modelEntity = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [m])
                modelEntity.transform.matrix = joint.anchorFromJointTransform
                modelEntity.name = joint.name.codableName.rawValue + "-model"
                modelEntity.isEnabled = isSkeletonVisible
                hand.addChild(modelEntity)
                
                let collisionEntity = Entity()
                collisionEntity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.01)], filter: .init(group: GameCollisionGroup.handCollisionGroup, mask: GameCollisionGroup.emojiCardCollisionGroup)))
                collisionEntity.transform.matrix = joint.anchorFromJointTransform
                collisionEntity.name = joint.name.codableName.rawValue + "-collision"
                hand.addChild(collisionEntity)
            }
        }
        return hand
    }
    private func updateHandEntity(from handAnchor: HandAnchor, to: Entity) {
        to.transform.matrix = handAnchor.originFromAnchorTransform
        if let skeleton = handAnchor.handSkeleton {
            for joint in skeleton.allJoints {
                let modelEntity = to.findEntity(named: joint.name.codableName.rawValue + "-model")
                modelEntity?.transform.matrix = joint.anchorFromJointTransform
                modelEntity?.isEnabled = isSkeletonVisible
                
                let collisionEntity = to.findEntity(named: joint.name.codableName.rawValue + "-collision")
                collisionEntity?.transform.matrix = joint.anchorFromJointTransform
            }
        }
    }
    
    @MainActor
    func updateHand(from simHand: SimHand) async {
        let handVectors = simHand.convertToHandVector(offset: .init(0, Self.simHandPositionY, -0.2))
        leftHandVector = handVectors.left
        if let leftHandVector {
            if left == nil {
                left = generateHandEntity(from: leftHandVector)
            } else {
                left?.isEnabled = true
                updateHandEntity(from: leftHandVector, to: left!)
//                debugPrint(leftHandVector.transform.columns.3.xyz)
            }
        } else {
            left?.isEnabled = false
        }
        
        rightHandVector = handVectors.right
        if let rightHandVector {
            if right == nil {
                right = generateHandEntity(from: rightHandVector)
            } else {
                right?.isEnabled = true
                updateHandEntity(from: rightHandVector, to: right!)
            }
        } else {
            right?.isEnabled = false
        }
    }
    
    private func generateHandEntity(from handVector: HandVectorMatcher) -> Entity {
        let hand = Entity()
        hand.name = handVector.chirality == .left ? "leftHand" : "rightHand"
        hand.transform.matrix = handVector.transform
        
        let wm = SimpleMaterial(color: .white, isMetallic: false)
        let rm = SimpleMaterial(color: .red, isMetallic: false)
        for positionInfo in handVector.allPositions.values {
            let m = (positionInfo.name == .wrist || positionInfo.name == .forearmWrist) ? rm : wm
            let modelEntity = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [m])
            modelEntity.position = positionInfo.position
            modelEntity.name = positionInfo.name.rawValue + "-model"
            modelEntity.isEnabled = isSkeletonVisible
            hand.addChild(modelEntity)
            
            let collisionEntity = Entity()
            collisionEntity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.01)], filter: .init(group: GameCollisionGroup.handCollisionGroup, mask: GameCollisionGroup.emojiCardCollisionGroup)))
            collisionEntity.position = positionInfo.position
            collisionEntity.name = positionInfo.name.rawValue + "-collision"
            hand.addChild(collisionEntity)
        }
        return hand
    }
    private func updateHandEntity(from handVector: HandVectorMatcher, to: Entity) {
        to.transform.matrix = handVector.transform
        for positionInfo in handVector.allPositions.values {
            let modelEntity = to.findEntity(named: positionInfo.name.rawValue + "-model")
            modelEntity?.position = positionInfo.position
            modelEntity?.isEnabled = isSkeletonVisible
            
            let collisionEntity = to.findEntity(named: positionInfo.name.rawValue + "-collision")
            collisionEntity?.position = positionInfo.position
        }
        
    }
}

extension HandsUpdates {
    static let simHandPositionY: Float = 1.4
    static func generateHandsUpdates(para:HandEmojiParameter, offset: simd_float3 = .init(0, simHandPositionY, -0.5)) -> HandsUpdates {
        let left = Entity()
        left.name = "leftHand"
        left.position = .init(x: -0.2, y: 0, z: 0) + offset
        
        let right = Entity()
        right.name = "rightHand"
        right.position = .init(x: 0.2, y: 0, z: 0) + offset
        
        let wm = SimpleMaterial(color: .white, isMetallic: false)
        let rm = SimpleMaterial(color: .red, isMetallic: false)
        
        var leftPositions: [HandSkeleton.JointName.NameCodingKey : HandVectorMatcher.PositionInfo] = [:]
        para.left?.forEach({ joint in
            let m = (joint.name == .wrist || joint.name == .forearmWrist) ? rm : wm
            let modelEntity = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [m])
            modelEntity.transform = joint.transform
            modelEntity.name = joint.name.rawValue + "-model"
            modelEntity.isEnabled = true
            left.addChild(modelEntity)
            
            let collisionEntity = Entity()
            collisionEntity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.01)], filter: .init(group: GameCollisionGroup.handCollisionGroup, mask: GameCollisionGroup.emojiCardCollisionGroup)))
            collisionEntity.transform = joint.transform
            collisionEntity.name = joint.name.rawValue + "-collision"
            left.addChild(collisionEntity)
            
            leftPositions[joint.name] = HandVectorMatcher.PositionInfo(name: joint.name, isTracked: true, position: joint.position)
        })
        
        var rightPositions: [HandSkeleton.JointName.NameCodingKey : HandVectorMatcher.PositionInfo] = [:]
        para.right?.forEach({ joint in
            let m = (joint.name == .wrist || joint.name == .forearmWrist) ? rm : wm
            let modelEntity = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [m])
            modelEntity.transform = joint.transform
            modelEntity.name = joint.name.rawValue + "-model"
            modelEntity.isEnabled = true
            right.addChild(modelEntity)
            
            let collisionEntity = Entity()
            collisionEntity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.01)], filter: .init(group: GameCollisionGroup.handCollisionGroup, mask: GameCollisionGroup.emojiCardCollisionGroup)))
            collisionEntity.transform = joint.transform
            collisionEntity.name = joint.name.rawValue + "-collision"
            right.addChild(collisionEntity)
            
            rightPositions[joint.name] = HandVectorMatcher.PositionInfo(name: joint.name, isTracked: true, position: joint.position)
        })
        
        let leftVector = HandVectorMatcher(chirality: .left, allPositions: leftPositions, transform: .init(1))
        let rightVector = HandVectorMatcher(chirality: .right, allPositions: rightPositions, transform: .init(1))
        
        return HandsUpdates(left: left,right: right, leftHandVector: leftVector, rightHandVector: rightVector)
    }
    
    func updateFakeHandUpDown() {
        guard let left = left, let right = right else { return  }
        let moveRange = 0.03
        let time = Date().timeIntervalSince1970
        let offset = sin(time*3) * moveRange
        let offset2 = sin(time*4) * moveRange
        
        left.position = .init(left.position.x, HandsUpdates.simHandPositionY + Float(offset), left.position.z)
        right.position = .init(right.position.x, HandsUpdates.simHandPositionY + Float(offset2), right.position.z)
    }
}
