//
//  File.swift
//  HandVector
//
//  Created by 许同学 on 2024/8/5.
//

import RealityFoundation
import ARKit

public struct HVJointJsonModel: Sendable, Equatable, HVJoint {
    public let name: HandSkeleton.JointName.NameCodingKey
    public let isTracked: Bool
    public let transform: simd_float4x4
    
}

extension HVJointJsonModel: Codable {
    enum CodingKeys: CodingKey {
        case name
        case isTracked
        case transform
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<HVJointJsonModel.CodingKeys> = try decoder.container(keyedBy: HVJointJsonModel.CodingKeys.self)
        
        self.name = try container.decode(HandSkeleton.JointName.NameCodingKey.self, forKey: HVJointJsonModel.CodingKeys.name)
        self.isTracked = try container.decode(Bool.self, forKey: HVJointJsonModel.CodingKeys.isTracked)
        self.transform = try simd_float4x4(container.decode([SIMD4<Float>].self, forKey: HVJointJsonModel.CodingKeys.transform))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<HVJointJsonModel.CodingKeys> = encoder.container(keyedBy: HVJointJsonModel.CodingKeys.self)
        
        try container.encode(self.name, forKey: HVJointJsonModel.CodingKeys.name)
        try container.encode(self.isTracked, forKey: HVJointJsonModel.CodingKeys.isTracked)
        try container.encode(self.transform.float4Array, forKey: HVJointJsonModel.CodingKeys.transform)
    }
}

public struct HVHandJsonModel {
    public let name: String
    public let chirality: HandAnchor.Chirality.NameCodingKey
    public let transform: simd_float4x4
    public let joints: [HVJointJsonModel]

    public static func loadBulitin() -> HandVectorMatcher? {
        guard let path = handAssetsBundle.path(forResource: "BuiltinHand", ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel(HVHandJsonModel.self)?.convertToHandVectorMatcher()
        } catch {
            print(error)
        }
        return nil
    }
    public static func loadBuiltinDict() -> [String: HandVectorMatcher]? {
        guard let path = handAssetsBundle.path(forResource: "BuiltinHand", ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel([String: HVHandJsonModel].self)?.reduce(into: [String: HandVectorMatcher](), {
                $0[$1.key] = $1.value.convertToHandVectorMatcher()
            })
        } catch {
            print(error)
        }
        return nil
    }
    
    public func convertToHandVectorMatcher() -> HandVectorMatcher? {
        let jsonDict = joints.reduce(into: [HandSkeleton.JointName.NameCodingKey: HVJointJsonModel]()) {
            $0[$1.name] = $1
        }
        let identity = simd_float4x4.init(diagonal: .one)
        let allJoints = HandSkeleton.JointName.allCases.reduce(into: [HandSkeleton.JointName.NameCodingKey: HVJointInfo]()) {
            if let jsonJoint = jsonDict[$1.codableName] {
                if let parentName = $1.codableName.parentName, let parentTransform = jsonDict[parentName]?.transform {
                    let parentIT = parentTransform.inverse * jsonJoint.transform
                    let joint = HVJointInfo(name: jsonJoint.name, isTracked: jsonJoint.isTracked, anchorFromJointTransform: jsonJoint.transform, parentFromJointTransform: parentIT)
                    $0[$1.codableName] = joint
                } else {
                    let joint = HVJointInfo(name: jsonJoint.name, isTracked: jsonJoint.isTracked, anchorFromJointTransform: jsonJoint.transform, parentFromJointTransform: identity)
                    $0[$1.codableName] = joint
                }
            }
        }
        
        let ch: HandAnchor.Chirality = (chirality == .left) ? .left : .right
        let vector = HandVectorMatcher(chirality: ch, allJoints: allJoints, transform: .init(diagonal: .one))
        return vector
    }
    
    public static func generateJsonModel(name: String, handVector: HandVectorMatcher) -> HVHandJsonModel {
        let joints = HandSkeleton.JointName.allCases.map { jointName in
            let joint = handVector.allJoints[jointName.codableName]!
            return HVJointJsonModel(name: joint.name, isTracked: joint.isTracked, transform: joint.transform)
        }
        return HVHandJsonModel(name: name, chirality: handVector.chirality, transform: handVector.transform, joints: joints)
    }
    
}

extension HVHandJsonModel: Codable {
    enum CodingKeys: CodingKey {
        case name
        case chirality
        case joints
        case transform
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<HVHandJsonModel.CodingKeys> = try decoder.container(keyedBy: HVHandJsonModel.CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: HVHandJsonModel.CodingKeys.name)
        self.chirality = try container.decode(HandAnchor.Chirality.NameCodingKey.self, forKey: HVHandJsonModel.CodingKeys.chirality)
        self.joints = try container.decode([HVJointJsonModel].self, forKey: HVHandJsonModel.CodingKeys.joints)
        self.transform = try simd_float4x4(container.decode([SIMD4<Float>].self, forKey: HVHandJsonModel.CodingKeys.transform))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<HVHandJsonModel.CodingKeys> = encoder.container(keyedBy: HVHandJsonModel.CodingKeys.self)
        
        try container.encode(self.name, forKey: HVHandJsonModel.CodingKeys.name)
        try container.encode(self.chirality, forKey: HVHandJsonModel.CodingKeys.chirality)
        try container.encode(self.joints, forKey: HVHandJsonModel.CodingKeys.joints)
        try container.encode(self.transform.float4Array, forKey: HVHandJsonModel.CodingKeys.transform)
    }
}

