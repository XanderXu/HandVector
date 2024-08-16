//
//  HVJointJsonModel.swift
//
//
//  Created by xu on 2024/8/16.
//

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
