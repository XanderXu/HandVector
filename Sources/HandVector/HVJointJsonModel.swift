//
//  HVJointJsonModel.swift
//
//
//  Created by xu on 2024/8/16.
//

import ARKit

public struct HVJointJsonModel: Sendable, Equatable {
    public let name: HandSkeleton.JointName.NameCodingKey
    public let isTracked: Bool
    public let transform: simd_float4x4
    
}

extension HVJointJsonModel: CustomStringConvertible, Codable {
    enum CodingKeys: CodingKey {
        case name
        case isTracked
        case transform
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<HVJointInfo.CodingKeys> = try decoder.container(keyedBy: HVJointInfo.CodingKeys.self)
        
        self.name = try container.decode(HandSkeleton.JointName.NameCodingKey.self, forKey: HVJointInfo.CodingKeys.name)
        self.isTracked = try container.decode(Bool.self, forKey: HVJointInfo.CodingKeys.isTracked)
        self.transform = try simd_float4x4(container.decode([SIMD4<Float>].self, forKey: HVJointInfo.CodingKeys.transform))
    }
    
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<HVJointInfo.CodingKeys> = encoder.container(keyedBy: HVJointInfo.CodingKeys.self)
        
        try container.encode(self.name, forKey: HVJointInfo.CodingKeys.name)
        try container.encode(self.isTracked, forKey: HVJointInfo.CodingKeys.isTracked)
        try container.encode(self.transform.float4Array, forKey: HVJointInfo.CodingKeys.transform)
    }
}
