//
//  HandVectorMatcher.swift
//  FingerDance
//
//  Created by 许同学 on 2024/1/2.
//

import Foundation
import simd
import ARKit

public struct HandVectorMatcher: Sendable, Equatable {
    public let chirality: HandAnchor.Chirality.NameCodingKey
    public let allPositions: [HandSkeleton.JointName.NameCodingKey: PositionInfo]
    public let transform: simd_float4x4
    
    internal let internalVectors: [HandSkeleton.JointName.NameCodingKey: VectorInfo]
    internal func vectorEndTo(_ named: HandSkeleton.JointName) -> VectorInfo {
        return internalVectors[named.codableName]!
    }
    //world space direction
    public var fingersExtendedDirection: simd_float3 {
        return chirality == .left ? transform.columns.0.xyz : -transform.columns.0.xyz
    }
    public var thumbExtendedDirection: simd_float3 {
        return chirality == .left ? -transform.columns.2.xyz : transform.columns.2.xyz
    }
    public var palmDirection: simd_float3 {
        return chirality == .left ? transform.columns.1.xyz : -transform.columns.1.xyz
    }
    
    public static func genetatePositions(from handSkeleton: HandSkeleton) -> [HandSkeleton.JointName.NameCodingKey: PositionInfo] {
        var positions: [HandSkeleton.JointName.NameCodingKey: PositionInfo] = [:]
        HandSkeleton.JointName.allCases.forEach { jointName in
            positions[jointName.codableName] = PositionInfo(joint: handSkeleton.joint(jointName))
        }
        return positions
    }
    
    public init?(chirality: HandAnchor.Chirality, allPositions: [HandSkeleton.JointName.NameCodingKey: PositionInfo], transform: simd_float4x4) {
        if allPositions.count >= HandSkeleton.JointName.allCases.count {
            self.chirality = chirality.codableName
            self.allPositions = allPositions
            self.transform = transform
            self.internalVectors = Self.genetateVectors(from: allPositions)
        } else {
            return nil
        }
    }
    public init?(handAnchor: HandAnchor) {
        guard let handSkeleton = handAnchor.handSkeleton else  {
            return nil
        }
        self.init(chirality: handAnchor.chirality, handSkeleton: handSkeleton, transform: handAnchor.originFromAnchorTransform)
    }
    public init(chirality: HandAnchor.Chirality, handSkeleton: HandSkeleton, transform: simd_float4x4) {
        self.chirality = chirality.codableName
        self.allPositions = Self.genetatePositions(from: handSkeleton)
        self.transform = transform
        self.internalVectors = Self.genetateVectors(from: allPositions)
    }
    static func genetateVectors(from positions: [HandSkeleton.JointName.NameCodingKey: PositionInfo]) -> [HandSkeleton.JointName.NameCodingKey: VectorInfo] {
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
    public struct PositionInfo: Sendable, Hashable {
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
        
        public func reversedChirality() -> PositionInfo {
            return PositionInfo(name: name, isTracked: isTracked, position: -position)
        }
    }
    public struct VectorInfo: Hashable, Sendable, Codable {
        public let from: HandSkeleton.JointName.NameCodingKey
        public let to: HandSkeleton.JointName.NameCodingKey
        public let vector: simd_float3
        public let normalizedVector: simd_float3
        
        public func reversedChirality() -> VectorInfo {
            return VectorInfo(from: from, to: to, vector: -vector)
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
    }

    public enum JointOfFinger: CaseIterable {
        case thump
        case indexFinger
        case middleFinger
        case ringFinger
        case littleFinger
        case wristMetacarpal
        case foreArm
        
        public var jointNames: [HandSkeleton.JointName] {
            switch self {
            case .thump:
                return [.thumbKnuckle, .thumbIntermediateBase, .thumbIntermediateTip, .thumbTip]
            case .indexFinger:
                return [.indexFingerKnuckle, .indexFingerIntermediateBase, .indexFingerIntermediateTip, .indexFingerTip]
            case .middleFinger:
                return [.middleFingerKnuckle, .middleFingerIntermediateBase, .middleFingerIntermediateTip, .middleFingerTip]
            case .ringFinger:
                return [.ringFingerKnuckle, .ringFingerIntermediateBase, .ringFingerIntermediateTip, .ringFingerTip]
            case .littleFinger:
                return [.littleFingerKnuckle, .littleFingerIntermediateBase, .littleFingerIntermediateTip, .littleFingerTip]
            case .wristMetacarpal:
                return [.wrist, .indexFingerMetacarpal, .middleFingerMetacarpal, .ringFingerMetacarpal, .littleFingerMetacarpal]
            case .foreArm:
                return [.forearmWrist, .forearmArm]
            }
        }
    }
    public static let allFingers: Set<JointOfFinger> = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger]
    public static let allFingersAndWrist: Set<JointOfFinger> = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .wristMetacarpal]
    public static let allFingersAndWristAndForearm: Set<JointOfFinger> = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .wristMetacarpal, .foreArm]
    
    /// Fingers and wrist and forearm
    func similarity(to vector: HandVectorMatcher) -> Float {
        return similarity(of: HandVectorMatcher.allFingersAndWristAndForearm, to: vector)
    }
    /// Fingers your selected
    func similarity(of fingers: Set<JointOfFinger>, to vector: HandVectorMatcher) -> Float {
        var similarity: Float = 0
        let jointNames = fingers.flatMap { $0.jointNames }
        similarity = jointNames.map { name in
            let dv = dot(vector.vectorEndTo(name).normalizedVector, self.vectorEndTo(name).normalizedVector)
            return dv
        }.reduce(0) { $0 + $1 }
        
        similarity /= Float(jointNames.count)
        return similarity
    }
    
    func similarities(to vector: HandVectorMatcher) -> (average: Float, each: [JointOfFinger: Float]) {
        return similarities(of: HandVectorMatcher.allFingersAndWristAndForearm, to: vector)
    }
    func similarities(of fingers: Set<JointOfFinger>, to vector: HandVectorMatcher) -> (average: Float, each: [JointOfFinger: Float]) {
        let fingerTotal = fingers.reduce(into: [JointOfFinger: Float]()) { partialResult, finger in
            let fingerResult = finger.jointNames.reduce(into: Float.zero) { partialResult, name in
                let dv = dot(vector.vectorEndTo(name).normalizedVector, self.vectorEndTo(name).normalizedVector)
                partialResult += dv
            }
            partialResult[finger] = fingerResult
        }
        let fingerScore = fingerTotal.reduce(into: [JointOfFinger: Float]()) { partialResult, ele in
            partialResult[ele.key]  = ele.value / Float(ele.key.jointNames.count)
        }
        
        let jointTotal = fingerTotal.reduce(into: Float.zero) { partialResult, element in
            partialResult += element.value
        }
        let jointCount = fingers.flatMap { $0.jointNames }.count
        return (average: jointTotal / Float(jointCount), each: fingerScore)
    }
    
    func reversedChirality() -> HandVectorMatcher {
        var infoNew: [HandSkeleton.JointName.NameCodingKey: PositionInfo] = [:]
        for (name, info) in allPositions {
            infoNew[name] = info.reversedChirality()
        }
        let m = HandVectorMatcher(chirality: chirality == .left ? .right : .left, allPositions: infoNew, transform: simd_float4x4([-transform.columns.0, transform.columns.1, -transform.columns.2, transform.columns.3]))!
        return m
    }
    //in world space
    //direction: from knukle to tip of a finger
    func fingerPositionDirection(of finger: HandVectorMatcher.JointOfFinger) -> (position: SIMD3<Float>, direction: SIMD3<Float>) {
        let tip = finger.jointNames.last!
        let tipLocal = allPositions[tip.codableName]?.position ?? .zero
        let tipWorld = transform * SIMD4(tipLocal, 1)
        
        let back = chirality == .left ? SIMD3<Float>(1, 0, 0) : SIMD3<Float>(-1, 0, 0)
        let knukle = finger.jointNames.first!
        let knukleLocal = allPositions[knukle.codableName]?.position ?? back
        let knukleWorld = transform * SIMD4(knukleLocal, 1)
        
        return (position: tipWorld.xyz, direction: simd_normalize(tipWorld.xyz - knukleWorld.xyz))
    }
}
