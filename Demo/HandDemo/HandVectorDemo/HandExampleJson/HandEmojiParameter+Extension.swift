//
//  HandEmojiParameter+Extension.swift
//  HandVectorDemo
//
//  Created by 许同学 on 2024/2/22.
//

import Foundation
import RealityKit
import ARKit
import HandVector

extension HandEmojiParameter {
    static func generateParameters(name: String, leftHandVector: HandVectorMatcher?, rightHandVector: HandVectorMatcher?) -> HandEmojiParameter? {
        if leftHandVector == nil, rightHandVector == nil {
            return nil
        }
        var left: [JointInfo]? = nil
        var right: [JointInfo]? = nil
        if let leftHandVector {
            left = HandSkeleton.JointName.allCases.map { jointName in
                JointInfo(position: leftHandVector.allPositions[jointName.codableName]!.position, name: jointName.codableName)
            }
        }
        if let rightHandVector {
            right = HandSkeleton.JointName.allCases.map { jointName in
                JointInfo(position: rightHandVector.allPositions[jointName.codableName]!.position, name: jointName.codableName)
            }
        }

        return HandEmojiParameter(name: name, left: left, right: right)
    }
    
    func convertToHandVectorMatcher() -> (left: HandVectorMatcher?, right: HandVectorMatcher?) {
        var leftVector: HandVectorMatcher?
        if let left {
            var allPositions: [HandSkeleton.JointName.NameCodingKey : HandVectorMatcher.PositionInfo] = [:]
            left.forEach { joint in
                allPositions[joint.name] = HandVectorMatcher.PositionInfo(name: joint.name, isTracked: true, position: joint.position)
            }
            leftVector = HandVectorMatcher(chirality: .left, allPositions: allPositions, transform: .init(diagonal: .one))
        }
        var rightVector: HandVectorMatcher?
        if let right {
            var allPositions: [HandSkeleton.JointName.NameCodingKey : HandVectorMatcher.PositionInfo] = [:]
            right.forEach { joint in
                allPositions[joint.name] = HandVectorMatcher.PositionInfo(name: joint.name, isTracked: true, position: joint.position)
            }
            rightVector = HandVectorMatcher(chirality: .right, allPositions: allPositions, transform: .init(diagonal: .one))
        }
        return (left: leftVector, right: rightVector)
    }
    
    func convertToHandsVectorTool(offset: simd_float3 = .init(0, HandVectorTool.simHandPositionY, -0.5)) -> HandVectorTool {
        let leftEntity = Entity()
        leftEntity.name = "leftHand"
        leftEntity.position = .init(x: -0.2, y: 0, z: 0) + offset
        
        let rightEntity = Entity()
        rightEntity.name = "rightHand"
        rightEntity.position = .init(x: 0.2, y: 0, z: 0) + offset
        
        let wm = SimpleMaterial(color: .white, isMetallic: false)
        let rm = SimpleMaterial(color: .red, isMetallic: false)
        
        var leftPositions: [HandSkeleton.JointName.NameCodingKey : HandVectorMatcher.PositionInfo] = [:]
        left?.forEach({ joint in
            let m = (joint.name == .wrist || joint.name == .forearmWrist) ? rm : wm
            let modelEntity = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [m])
            modelEntity.transform = joint.transform
            modelEntity.name = joint.name.rawValue + "-model"
            modelEntity.isEnabled = true
            leftEntity.addChild(modelEntity)
            
            let collisionEntity = Entity()
            collisionEntity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.01)]))
            collisionEntity.transform = joint.transform
            collisionEntity.name = joint.name.rawValue + "-collision"
            leftEntity.addChild(collisionEntity)
            
            leftPositions[joint.name] = HandVectorMatcher.PositionInfo(name: joint.name, isTracked: true, position: joint.position)
        })
        
        var rightPositions: [HandSkeleton.JointName.NameCodingKey : HandVectorMatcher.PositionInfo] = [:]
        right?.forEach({ joint in
            let m = (joint.name == .wrist || joint.name == .forearmWrist) ? rm : wm
            let modelEntity = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [m])
            modelEntity.transform = joint.transform
            modelEntity.name = joint.name.rawValue + "-model"
            modelEntity.isEnabled = true
            rightEntity.addChild(modelEntity)
            
            let collisionEntity = Entity()
            collisionEntity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.01)]))
            collisionEntity.transform = joint.transform
            collisionEntity.name = joint.name.rawValue + "-collision"
            rightEntity.addChild(collisionEntity)
            
            rightPositions[joint.name] = HandVectorMatcher.PositionInfo(name: joint.name, isTracked: true, position: joint.position)
        })
        
        let leftVector = HandVectorMatcher(chirality: .left, allPositions: leftPositions, transform: .init(diagonal: .one))
        let rightVector = HandVectorMatcher(chirality: .right, allPositions: rightPositions, transform: .init(diagonal: .one))
        
        return HandVectorTool(left: leftEntity,right: rightEntity, leftHandVector: leftVector, rightHandVector: rightVector)
    }
    
}
