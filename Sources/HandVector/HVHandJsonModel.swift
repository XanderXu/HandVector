//
//  File.swift
//  HandVector
//
//  Created by 许同学 on 2024/8/5.
//

import RealityFoundation
import ARKit

public struct HVHandJsonModel {
    public let name: String
    public let chirality: HandAnchor.Chirality.NameCodingKey
    public let transform: simd_float4x4
    public let joints: [HVJointInfo]

    public static func loadBulitin() -> HVHandJsonModel? {
        guard let path = handAssetsBundle.path(forResource: "BuiltinHand", ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel(HVHandJsonModel.self)
        } catch {
            print(error)
        }
        return nil
    }
    public static func loadBuiltinDict() -> [String: HVHandJsonModel]? {
        guard let path = handAssetsBundle.path(forResource: "BuiltinHand", ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel([String: HVHandJsonModel].self)
        } catch {
            print(error)
        }
        return nil
    }
    
    public static func generateParameters(name: String, handVector: HandVectorMatcher) -> HVHandJsonModel {
        let joints = HandSkeleton.JointName.allCases.map { jointName in
            handVector.allJoints[jointName.codableName]!
        }
        return HVHandJsonModel(name: name, chirality: handVector.chirality, transform: handVector.transform, joints: joints)
    }
    
    public func convertToHandVectorMatcher() -> HandVectorMatcher? {
        let all = joints.reduce(into: [HandSkeleton.JointName.NameCodingKey: HVJointInfo]()) {
            $0[$1.name] = $1
        }
        let ch: HandAnchor.Chirality = (chirality == .left) ? .left : .right
        let vector = HandVectorMatcher(chirality: ch, allJoints: all, transform: .init(diagonal: .one))
        return vector
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
        self.joints = try container.decode([HVJointInfo].self, forKey: HVHandJsonModel.CodingKeys.joints)
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

