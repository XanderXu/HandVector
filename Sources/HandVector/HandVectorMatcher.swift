//
//  HandVectorMatcher.swift
//  FingerDance
//
//  Created by 许同学 on 2024/1/2.
//

import Foundation
import simd
import ARKit

public struct HandVectorMatcher: CustomStringConvertible, Sendable, Equatable, Codable {
    public struct PositionInfo: CustomStringConvertible, Sendable, Hashable, Codable {
        public let name: HandSkeleton.JointName.NameCodingKey
        public let isTracked: Bool
        public let position: simd_float3
        
        public init(joint: HandSkeleton.Joint) {
            self.name = joint.name.codableName
            self.isTracked = joint.isTracked
            self.position = joint.localPosition
        }
        public init(name: HandSkeleton.JointName.NameCodingKey, isTracked: Bool, position: simd_float3) {
            self.name = name
            self.isTracked = isTracked
            self.position = position
        }
        public var description: String {
            return "name: \(name), isTracked: \(isTracked), position: \(position)"
        }
        
        public func reversedChirality() -> PositionInfo {
            return PositionInfo(name: name, isTracked: isTracked, position: -position)
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
    public struct VectorInfo: CustomStringConvertible, Hashable, Sendable, Codable {
        public let from: HandSkeleton.JointName.NameCodingKey
        public let to: HandSkeleton.JointName.NameCodingKey
        public let vector: simd_float3
        public let normalizedVector: simd_float3
        
        public var description: String {
            return "from: \(from),\nto: \(to),\nvector: \(vector), normalizedVector:\(normalizedVector)"
        }
        public init(from: PositionInfo, to: PositionInfo) {
            self.from = from.name
            self.to = to.name
            self.vector = to.position - from.position
            if vector == .zero {
                self.normalizedVector = .zero
            } else {
                self.normalizedVector = normalize(vector)
            }
        }
        public init(from: HandSkeleton.JointName.NameCodingKey, to: HandSkeleton.JointName.NameCodingKey, vector: simd_float3) {
            self.from = from
            self.to = to
            self.vector = vector
            if vector == .zero {
                self.normalizedVector = .zero
            } else {
                self.normalizedVector = normalize(vector)
            }
        }
        public func reversedChirality() -> VectorInfo {
            return VectorInfo(from: from, to: to, vector: -vector)
        }
    }
    
    
    public let chirality: HandAnchor.Chirality.NameCodingKey
    public let allPositions: [HandSkeleton.JointName.NameCodingKey: PositionInfo]
    public let transform: simd_float4x4
    
    private let internalVectors: [HandSkeleton.JointName.NameCodingKey: VectorInfo]
    private(set) lazy var allVectors: [VectorInfo] = {
        return Array(internalVectors.values)
    }()
    
    public var description: String {
        return "chirality: \(chirality)\nallVectors: \(allPositions)"
    }
    public func vectorEndTo(_ named: HandSkeleton.JointName) -> VectorInfo {
        return internalVectors[named.codableName]!
    }
    
    
    public static func genetatePositions(from handSkeleton: HandSkeleton) -> [HandSkeleton.JointName.NameCodingKey: PositionInfo] {
        var positions: [HandSkeleton.JointName.NameCodingKey: PositionInfo] = [:]
        HandSkeleton.JointName.allCases.forEach { jointName in
            positions[jointName.codableName] = PositionInfo(joint: handSkeleton.joint(jointName))
        }
        return positions
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
        self.internalVectors = Self.genetateVoctors(from: allPositions)
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<HandVectorMatcher.CodingKeys> = encoder.container(keyedBy: HandVectorMatcher.CodingKeys.self)
        
        try container.encode(self.chirality, forKey: HandVectorMatcher.CodingKeys.chirality)
        try container.encode(self.allPositions, forKey: HandVectorMatcher.CodingKeys.allPositions)
        try container.encode([self.transform.columns.0, self.transform.columns.1, self.transform.columns.2, self.transform.columns.3], forKey: HandVectorMatcher.CodingKeys.transform)
    }
    
}

public extension HandVectorMatcher {
    init?(chirality: HandAnchor.Chirality, allPositions: [HandSkeleton.JointName.NameCodingKey: PositionInfo], transform: simd_float4x4) {
        if allPositions.count >= HandSkeleton.JointName.allCases.count {
            self.chirality = chirality.codableName
            self.allPositions = allPositions
            self.transform = transform
            self.internalVectors = Self.genetateVoctors(from: allPositions)
        } else {
            return nil
        }
    }
    init?(handAnchor: HandAnchor) {
        guard let handSkeleton = handAnchor.handSkeleton else  {
            return nil
        }
        self.init(chirality: handAnchor.chirality, handSkeleton: handSkeleton, transform: handAnchor.originFromAnchorTransform)
    }
    init(chirality: HandAnchor.Chirality, handSkeleton: HandSkeleton, transform: simd_float4x4) {
        self.chirality = chirality.codableName
        self.allPositions = Self.genetatePositions(from: handSkeleton)
        self.transform = transform
        self.internalVectors = Self.genetateVoctors(from: allPositions)
    }
    private static func genetateVoctors(from positions: [HandSkeleton.JointName.NameCodingKey: PositionInfo]) -> [HandSkeleton.JointName.NameCodingKey: VectorInfo] {
        var vectors: [HandSkeleton.JointName.NameCodingKey: VectorInfo] = [:]
        
        let wrist = positions[.wrist]!
        let forearmWrist = positions[.forearmWrist]!
        let forearmArm = positions[.forearmArm]!
        vectors[.forearmWrist] = VectorInfo(from: forearmArm, to: forearmWrist)
        vectors[.forearmArm] = VectorInfo(from: forearmWrist, to: forearmArm)
        vectors[.wrist] = VectorInfo(from: forearmArm, to: wrist)
        
        let thumbKnuckle = positions[.thumbKnuckle]!
        let thumbIntermediateBase = positions[.thumbIntermediateBase]!
        let thumbIntermediateTip = positions[.thumbIntermediateTip]!
        let thumbTip = positions[.thumbTip]!
        vectors[.thumbKnuckle] = VectorInfo(from: wrist, to: thumbKnuckle)
        vectors[.thumbIntermediateBase] = VectorInfo(from: thumbKnuckle, to: thumbIntermediateBase)
        vectors[.thumbIntermediateTip] = VectorInfo(from: thumbIntermediateBase, to: thumbIntermediateTip)
        vectors[.thumbTip] = VectorInfo(from: thumbIntermediateTip, to: thumbTip)
        
        let indexFingerMetacarpal = positions[.indexFingerMetacarpal]!
        let indexFingerKnuckle = positions[.indexFingerKnuckle]!
        let indexFingerIntermediateBase = positions[.indexFingerIntermediateBase]!
        let indexFingerIntermediateTip = positions[.indexFingerIntermediateTip]!
        let indexFingerTip = positions[.indexFingerTip]!
        
        vectors[.indexFingerMetacarpal] = VectorInfo(from: wrist, to: indexFingerMetacarpal)
        vectors[.indexFingerKnuckle] = VectorInfo(from: indexFingerMetacarpal, to: indexFingerKnuckle)
        vectors[.indexFingerIntermediateBase] = VectorInfo(from: indexFingerKnuckle, to: indexFingerIntermediateBase)
        vectors[.indexFingerIntermediateTip] = VectorInfo(from: indexFingerIntermediateBase, to: indexFingerIntermediateTip)
        vectors[.indexFingerTip] = VectorInfo(from: indexFingerIntermediateTip, to: indexFingerTip)
                                              
        let middleFingerMetacarpal = positions[.middleFingerMetacarpal]!
        let middleFingerKnuckle = positions[.middleFingerKnuckle]!
        let middleFingerIntermediateBase = positions[.middleFingerIntermediateBase]!
        let middleFingerIntermediateTip = positions[.middleFingerIntermediateTip]!
        let middleFingerTip = positions[.middleFingerTip]!
        
        vectors[.middleFingerMetacarpal] = VectorInfo(from: wrist, to: middleFingerMetacarpal)
        vectors[.middleFingerKnuckle] = VectorInfo(from: middleFingerMetacarpal, to: middleFingerKnuckle)
        vectors[.middleFingerIntermediateBase] = VectorInfo(from: middleFingerKnuckle, to: middleFingerIntermediateBase)
        vectors[.middleFingerIntermediateTip] = VectorInfo(from: middleFingerIntermediateBase, to: middleFingerIntermediateTip)
        vectors[.middleFingerTip] = VectorInfo(from: middleFingerIntermediateTip, to: middleFingerTip)
        
        
        let ringFingerMetacarpal = positions[.ringFingerMetacarpal]!
        let ringFingerKnuckle = positions[.ringFingerKnuckle]!
        let ringFingerIntermediateBase = positions[.ringFingerIntermediateBase]!
        let ringFingerIntermediateTip = positions[.ringFingerIntermediateTip]!
        let ringFingerTip = positions[.ringFingerTip]!
        
        vectors[.ringFingerMetacarpal] = VectorInfo(from: wrist, to: ringFingerMetacarpal)
        vectors[.ringFingerKnuckle] = VectorInfo(from: ringFingerMetacarpal, to: ringFingerKnuckle)
        vectors[.ringFingerIntermediateBase] = VectorInfo(from: ringFingerKnuckle, to: ringFingerIntermediateBase)
        vectors[.ringFingerIntermediateTip] = VectorInfo(from: ringFingerIntermediateBase, to: ringFingerIntermediateTip)
        vectors[.ringFingerTip] = VectorInfo(from: ringFingerIntermediateTip, to: ringFingerTip)
        
        
        let littleFingerMetacarpal = positions[.littleFingerMetacarpal]!
        let littleFingerKnuckle = positions[.littleFingerKnuckle]!
        let littleFingerIntermediateBase = positions[.littleFingerIntermediateBase]!
        let littleFingerIntermediateTip = positions[.littleFingerIntermediateTip]!
        let littleFingerTip = positions[.littleFingerTip]!
        
        vectors[.littleFingerMetacarpal] = VectorInfo(from: wrist, to: littleFingerMetacarpal)
        vectors[.littleFingerKnuckle] = VectorInfo(from: littleFingerMetacarpal, to: littleFingerKnuckle)
        vectors[.littleFingerIntermediateBase] = VectorInfo(from: littleFingerKnuckle, to: littleFingerIntermediateBase)
        vectors[.littleFingerIntermediateTip] = VectorInfo(from: littleFingerIntermediateBase, to: littleFingerIntermediateTip)
        vectors[.littleFingerTip] = VectorInfo(from: littleFingerIntermediateTip, to: littleFingerTip)
        return vectors
    }
}

public extension HandVectorMatcher {
    enum JointOfFinger: CaseIterable {
        case thump
        case indexFinger
        case middleFinger
        case ringFinger
        case littleFinger
        case wrist
        
        var jointNames: [HandSkeleton.JointName] {
            switch self {
            case .thump:
                return [.thumbKnuckle, .thumbIntermediateBase, .thumbIntermediateTip, .thumbTip]
            case .indexFinger:
                return [.indexFingerMetacarpal, .indexFingerKnuckle, .indexFingerIntermediateBase, .indexFingerIntermediateTip, .indexFingerTip]
            case .middleFinger:
                return [.middleFingerMetacarpal, .middleFingerKnuckle, .middleFingerIntermediateBase, .middleFingerIntermediateTip, .middleFingerTip]
            case .ringFinger:
                return [.ringFingerMetacarpal, .ringFingerKnuckle, .ringFingerIntermediateBase, .ringFingerIntermediateTip, .ringFingerTip]
            case .littleFinger:
                return [.littleFingerMetacarpal, .littleFingerKnuckle, .littleFingerIntermediateBase, .littleFingerIntermediateTip, .littleFingerTip]
            case .wrist:
                return [.wrist, .forearmWrist, .forearmArm]
            }
        }
        static let keyWeight: Float = 1.0
        static let regularWeight: Float = 0.8
        static let insensitiveWeight: Float = 0.5
    }
    
    func similarity(to vector: HandVectorMatcher) -> Float {
        var similarity: Float = 0
        similarity = HandSkeleton.JointName.allCases.map { name in
            let dv = dot(vector.vectorEndTo(name).normalizedVector, self.vectorEndTo(name).normalizedVector)
            return dv
        }.reduce(similarity) { $0 + $1 }
        
        similarity /= Float(HandSkeleton.JointName.allCases.count)
        return similarity
    }
    func similarity(of keyFingers: Set<JointOfFinger>, regularFingers: Set<JointOfFinger> = [], insensitiveFingers: Set<JointOfFinger> = [], to vector: HandVectorMatcher) -> Float {
        if !keyFingers.intersection(regularFingers).intersection(insensitiveFingers).isEmpty {
            print("fingers repeat!")
        }
        var similarity: Float = 0
        
        let keyJoints = keyFingers.flatMap { $0.jointNames }
        similarity = keyJoints.map { name in
            let dv = dot(vector.vectorEndTo(name).normalizedVector, self.vectorEndTo(name).normalizedVector)
            return dv * JointOfFinger.keyWeight
        }.reduce(similarity) { $0 + $1 }
        
        let regularJoints = regularFingers.flatMap { $0.jointNames }
        similarity = regularJoints.map { name in
            let dv = dot(vector.vectorEndTo(name).normalizedVector, self.vectorEndTo(name).normalizedVector)
            return dv * JointOfFinger.regularWeight
        }.reduce(similarity) { $0 + $1 }
        
        let insensitiveJoints = insensitiveFingers.flatMap { $0.jointNames }
        similarity = insensitiveJoints.map { name in
            let dv = dot(vector.vectorEndTo(name).normalizedVector, self.vectorEndTo(name).normalizedVector)
            return dv * JointOfFinger.insensitiveWeight
        }.reduce(similarity) { $0 + $1 }
        
        let weights = Float(keyJoints.count) * JointOfFinger.keyWeight + Float(regularJoints.count) * JointOfFinger.regularWeight + Float(insensitiveJoints.count) * JointOfFinger.insensitiveWeight
        similarity /= weights
        
        return similarity
    }
    func similarity(of finger: JointOfFinger, to vector: HandVectorMatcher) -> Float {
        var similarity: Float = 0
        similarity = finger.jointNames.map { name in
            let dv = dot(vector.vectorEndTo(name).normalizedVector, self.vectorEndTo(name).normalizedVector)
            return dv
        }.reduce(0) { $0 + $1 }
        
        similarity /= Float(finger.jointNames.count)
        return similarity
    }
    
    func reversedChirality() -> HandVectorMatcher {
        var infoNew: [HandSkeleton.JointName.NameCodingKey: PositionInfo] = [:]
        for (name, info) in allPositions {
            infoNew[name] = info.reversedChirality()
        }
        let m = HandVectorMatcher(chirality: chirality == .left ? .right : .left, allPositions: infoNew, transform: simd_float4x4([-transform.columns.0, transform.columns.1, -transform.columns.2, transform.columns.3]))!
        return m
    }
}

fileprivate extension HandSkeleton.Joint {
    var localPosition: simd_float3 {
        return anchorFromJointTransform.columns.3.xyz
    }
}

