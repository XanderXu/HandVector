//
//  File.swift
//  HandVector
//
//  Created by 许同学 on 2024/8/5.
//

import RealityFoundation
import ARKit

public struct BuiltinHandGesture: Codable {
    public let name: String
    public let left: [HVJointInfo]?
    public let right: [HVJointInfo]?
    
    public static func loadBulitin(fileName: String?) -> BuiltinHandGesture? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel(BuiltinHandGesture.self)
        } catch {
            print(error)
        }
        return nil
    }
    public static func loadBuiltinDict(fileName: String?) -> [String: BuiltinHandGesture]? {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel([String: BuiltinHandGesture].self)
        } catch {
            print(error)
        }
        return nil
    }
}

public extension BuiltinHandGesture {
    static func generateParameters(name: String, leftHandVector: HandVectorMatcher?, rightHandVector: HandVectorMatcher?) -> BuiltinHandGesture? {
        if leftHandVector == nil, rightHandVector == nil {
            return nil
        }
        var left: [HVJointInfo]? = nil
        var right: [HVJointInfo]? = nil
        if let leftHandVector {
            left = HandSkeleton.JointName.allCases.map { jointName in
                leftHandVector.allJoints[jointName.codableName]!
            }
        }
        if let rightHandVector {
            right = HandSkeleton.JointName.allCases.map { jointName in
                rightHandVector.allJoints[jointName.codableName]!
            }
        }

        return BuiltinHandGesture(name: name, left: left, right: right)
    }
    
    func convertToHandVectorMatcher() -> (left: HandVectorMatcher?, right: HandVectorMatcher?) {
        var leftVector: HandVectorMatcher?
        if let left {
            let all = left.reduce(into: [HandSkeleton.JointName.NameCodingKey: HVJointInfo]()) {
                $0[$1.name] = $1
            }
            
            leftVector = HandVectorMatcher(chirality: .left, allJoints: all, transform: .init(diagonal: .one))
        }
        var rightVector: HandVectorMatcher?
        if let right {
            let all = right.reduce(into: [HandSkeleton.JointName.NameCodingKey: HVJointInfo]()) {
                $0[$1.name] = $1
            }
            rightVector = HandVectorMatcher(chirality: .right, allJoints: all, transform: .init(diagonal: .one))
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
        
        var leftPositions: [HandSkeleton.JointName.NameCodingKey : HVJointInfo] = [:]
        left?.forEach({ joint in
            let m = (joint.name == .wrist || joint.name == .forearmWrist) ? rm : wm
            let modelEntity = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [m])
            modelEntity.transform = Transform(matrix: joint.transfrom)
            modelEntity.name = joint.name.rawValue + "-model"
            modelEntity.isEnabled = true
            leftEntity.addChild(modelEntity)
            
            let collisionEntity = Entity()
            collisionEntity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.01)]))
            collisionEntity.transform = Transform(matrix: joint.transfrom)
            collisionEntity.name = joint.name.rawValue + "-collision"
            leftEntity.addChild(collisionEntity)
            
            leftPositions[joint.name] = joint
        })
        
        var rightPositions: [HandSkeleton.JointName.NameCodingKey : HVJointInfo] = [:]
        right?.forEach({ joint in
            let m = (joint.name == .wrist || joint.name == .forearmWrist) ? rm : wm
            let modelEntity = ModelEntity(mesh: .generateSphere(radius: 0.01), materials: [m])
            modelEntity.transform = Transform(matrix: joint.transfrom)
            modelEntity.name = joint.name.rawValue + "-model"
            modelEntity.isEnabled = true
            rightEntity.addChild(modelEntity)
            
            let collisionEntity = Entity()
            collisionEntity.components.set(CollisionComponent(shapes: [.generateSphere(radius: 0.01)]))
            collisionEntity.transform = Transform(matrix: joint.transfrom)
            collisionEntity.name = joint.name.rawValue + "-collision"
            rightEntity.addChild(collisionEntity)
            
            rightPositions[joint.name] = joint
        })
        
        let leftVector = HandVectorMatcher(chirality: .left, allJoints: leftPositions, transform: .init(diagonal: .one))
        let rightVector = HandVectorMatcher(chirality: .right, allJoints: rightPositions, transform: .init(diagonal: .one))
        
        return HandVectorTool(left: leftEntity,right: rightEntity, leftHandVector: leftVector, rightHandVector: rightVector)
    }
    
}
