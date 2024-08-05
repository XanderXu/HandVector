//
//  File.swift
//  
//
//  Created by 许同学 on 2024/5/12.
//

import Foundation
import simd
import ARKit

extension HandVectorMatcher: CustomStringConvertible, Codable {
    public var description: String {
        return "chirality: \(chirality)\nallPositions: \(allJoints)"
    }
    
    enum CodingKeys: CodingKey {
        case chirality
        case allPositions
        case transform
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<HandVectorMatcher.CodingKeys> = try decoder.container(keyedBy: HandVectorMatcher.CodingKeys.self)
        
        self.chirality = try container.decode(HandAnchor.Chirality.NameCodingKey.self, forKey: HandVectorMatcher.CodingKeys.chirality)
        self.allJoints = try container.decode([HandSkeleton.JointName.NameCodingKey : HVJointInfo].self, forKey: HandVectorMatcher.CodingKeys.allPositions)
        self.transform = try simd_float4x4(container.decodeIfPresent([SIMD4<Float>].self, forKey: HandVectorMatcher.CodingKeys.transform) ?? [.init(x: 1, y: 0, z: 0, w: 0), .init(x: 0, y: 1, z: 0, w: 0), .init(x: 0, y: 0, z: 1, w: 0), .init(x: 0, y: 0, z: 0, w: 1)])
        self.internalVectors = Self.genetateVectors(from: allJoints)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<HandVectorMatcher.CodingKeys> = encoder.container(keyedBy: HandVectorMatcher.CodingKeys.self)
        
        try container.encode(self.chirality, forKey: HandVectorMatcher.CodingKeys.chirality)
        try container.encode(self.allJoints, forKey: HandVectorMatcher.CodingKeys.allPositions)
        try container.encode([self.transform.columns.0, self.transform.columns.1, self.transform.columns.2, self.transform.columns.3], forKey: HandVectorMatcher.CodingKeys.transform)
    }
}


