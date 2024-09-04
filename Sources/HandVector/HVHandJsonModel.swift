//
//  File.swift
//  HandVector
//
//  Created by 许同学 on 2024/8/5.
//

import RealityFoundation
import ARKit

public struct HVJointJsonModel: Sendable, Equatable {
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

public struct HVHandJsonModel:Sendable, Equatable {
    public let name: String
    public let chirality: HandAnchor.Chirality.NameCodingKey
    public let transform: simd_float4x4
    public let joints: [HVJointJsonModel]
    public var description: String?

    public static func loadHandJsonModel(fileName: String, bundle: Bundle = Bundle.main) -> HVHandJsonModel? {
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel(HVHandJsonModel.self)
        } catch {
            print(error)
        }
        return nil
    }
    public static func loadHandJsonModelDict(fileName: String, bundle: Bundle = Bundle.main) -> [String: HVHandJsonModel]? {
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel([String: HVHandJsonModel].self)
        } catch {
            print(error)
        }
        return nil
    }
    
    public func convertToHVHandInfo() -> HVHandInfo? {
        let jsonDict = joints.reduce(into: [HandSkeleton.JointName: HVJointJsonModel]()) {
            $0[$1.name.jointName!] = $1
        }
        let identity = simd_float4x4.init(diagonal: .one)
        let allJoints = HandSkeleton.JointName.allCases.reduce(into: [HandSkeleton.JointName: HVJointInfo]()) {
            if let jsonJoint = jsonDict[$1] {
                if let parentName = $1.parentName, let parentTransform = jsonDict[parentName]?.transform {
                    let parentIT = parentTransform.inverse * jsonJoint.transform
                    let joint = HVJointInfo(name: jsonJoint.name.jointName!, isTracked: jsonJoint.isTracked, anchorFromJointTransform: jsonJoint.transform, parentFromJointTransform: parentIT)
                    $0[$1] = joint
                } else {
                    let joint = HVJointInfo(name: jsonJoint.name.jointName!, isTracked: jsonJoint.isTracked, anchorFromJointTransform: jsonJoint.transform, parentFromJointTransform: identity)
                    $0[$1] = joint
                }
            }
        }
        
        let vector = HVHandInfo(chirality: chirality.chirality, allJoints: allJoints, transform: transform)
        return vector
    }
    
    public static func generateJsonModel(name: String, handVector: HVHandInfo) -> HVHandJsonModel {
        let joints = HandSkeleton.JointName.allCases.map { jointName in
            let joint = handVector.allJoints[jointName]!
            return HVJointJsonModel(name: joint.name.codableName, isTracked: joint.isTracked, transform: joint.transform)
        }
        return HVHandJsonModel(name: name, chirality: handVector.chirality.codableName, transform: handVector.transform, joints: joints)
    }
    
}

extension HVHandJsonModel: Codable {
    enum CodingKeys: CodingKey {
        case name
        case chirality
        case joints
        case transform
        case description
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<HVHandJsonModel.CodingKeys> = try decoder.container(keyedBy: HVHandJsonModel.CodingKeys.self)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.chirality = try container.decode(HandAnchor.Chirality.NameCodingKey.self, forKey: .chirality)
        self.joints = try container.decode([HVJointJsonModel].self, forKey: .joints)
        self.transform = try simd_float4x4(container.decode([SIMD4<Float>].self, forKey: .transform))
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<HVHandJsonModel.CodingKeys> = encoder.container(keyedBy: HVHandJsonModel.CodingKeys.self)
        
        try container.encode(self.name, forKey: .name)
        try container.encode(self.chirality, forKey: .chirality)
        try container.encode(self.joints, forKey: .joints)
        try container.encode(self.transform.float4Array, forKey: .transform)
        try container.encodeIfPresent(self.description, forKey: .description)
    }
}

