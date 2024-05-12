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
        return "chirality: \(chirality)\nallPositions: \(allPositions)"
    }
    
    enum CodingKeys: CodingKey {
        case chirality
        case allPositions
        case transform
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<HandVectorMatcher.CodingKeys> = try decoder.container(keyedBy: HandVectorMatcher.CodingKeys.self)
        
        self.chirality = try container.decode(HandAnchor.Chirality.NameCodingKey.self, forKey: HandVectorMatcher.CodingKeys.chirality)
        self.allPositions = try container.decode([HandSkeleton.JointName.NameCodingKey : HandVectorMatcher.PositionInfo].self, forKey: HandVectorMatcher.CodingKeys.allPositions)
        self.transform = try simd_float4x4(container.decodeIfPresent([SIMD4<Float>].self, forKey: HandVectorMatcher.CodingKeys.transform) ?? [.init(x: 1, y: 0, z: 0, w: 0), .init(x: 0, y: 1, z: 0, w: 0), .init(x: 0, y: 0, z: 1, w: 0), .init(x: 0, y: 0, z: 0, w: 1)])
        self.internalVectors = Self.genetateVectors(from: allPositions)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<HandVectorMatcher.CodingKeys> = encoder.container(keyedBy: HandVectorMatcher.CodingKeys.self)
        
        try container.encode(self.chirality, forKey: HandVectorMatcher.CodingKeys.chirality)
        try container.encode(self.allPositions, forKey: HandVectorMatcher.CodingKeys.allPositions)
        try container.encode([self.transform.columns.0, self.transform.columns.1, self.transform.columns.2, self.transform.columns.3], forKey: HandVectorMatcher.CodingKeys.transform)
    }
}

extension HandVectorMatcher.PositionInfo: CustomStringConvertible, Codable {
    public var description: String {
        return "name: \(name), isTracked: \(isTracked), position: \(position)"
    }
    
    enum CodingKeys: CodingKey {
        case name
        case isTracked
        case position
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<HandVectorMatcher.PositionInfo.CodingKeys> = try decoder.container(keyedBy: HandVectorMatcher.PositionInfo.CodingKeys.self)
        
        self.name = try container.decode(HandSkeleton.JointName.NameCodingKey.self, forKey: HandVectorMatcher.PositionInfo.CodingKeys.name)
        self.isTracked = try container.decodeIfPresent(Bool.self, forKey: HandVectorMatcher.PositionInfo.CodingKeys.isTracked) ?? true
        self.position = try container.decode(simd_float3.self, forKey: HandVectorMatcher.PositionInfo.CodingKeys.position)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<HandVectorMatcher.PositionInfo.CodingKeys> = encoder.container(keyedBy: HandVectorMatcher.PositionInfo.CodingKeys.self)
        
        try container.encode(self.name, forKey: HandVectorMatcher.PositionInfo.CodingKeys.name)
        try container.encode(self.isTracked, forKey: HandVectorMatcher.PositionInfo.CodingKeys.isTracked)
        try container.encode(self.position, forKey: HandVectorMatcher.PositionInfo.CodingKeys.position)
    }
}

extension HandVectorMatcher.VectorInfo: CustomStringConvertible {
    
    public var description: String {
        return "from: \(from),\nto: \(to),\nvector: \(vector), normalizedVector:\(normalizedVector)"
    }
}
