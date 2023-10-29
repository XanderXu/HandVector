//
//  HandVector.swift
//  HandVector
//
//  Created by xu on 2023/9/22.
//

#if targetEnvironment(simulator)
import ARKit
#else
@preconcurrency import ARKit
#endif
import Foundation
import simd

public struct HandVector: CustomStringConvertible, Sendable, Hashable, Codable {
    public struct PositionInfo: CustomStringConvertible, Sendable, Hashable, Codable {
        public let name: HandSkeleton.JointName
        public let isTracked: Bool
        public let position: simd_float3
        
        public init(joint: HandSkeleton.Joint) {
            self.name = joint.name
            self.isTracked = joint.isTracked
            self.position = joint.localPosition
        }
        public init(name: HandSkeleton.JointName, isTracked: Bool, position: simd_float3) {
            self.name = name
            self.isTracked = isTracked
            self.position = position
        }
        public var description: String {
            return "name: \(name), isTracked: \(isTracked), position: \(position)"
        }
        
        public func reverseChirality() -> PositionInfo {
            return PositionInfo(name: name, isTracked: isTracked, position: -position)
        }
    }
    public struct VectorInfo: CustomStringConvertible, Hashable, @unchecked Sendable, Codable {
        public let from: PositionInfo
        public let to: PositionInfo
        public let vector: simd_float3
        public let normalizedVector: simd_float3
        
        public var description: String {
            return "from: \(from),\nto: \(to),\nvector: \(vector), normalizedVector:\(normalizedVector)"
        }
        public init(from: PositionInfo, to: PositionInfo) {
            self.from = from
            self.to = to
            self.vector = to.position - from.position
            if vector == .zero {
                self.normalizedVector = .zero
            } else {
                self.normalizedVector = normalize(vector)
            }
        }
        
        public func reverseChirality() -> VectorInfo {
            return VectorInfo(from: from.reverseChirality(), to: to.reverseChirality())
        }
    }
    
    public let chirality: HandAnchor.Chirality
    /// A textual representation of this HandVector.
    public var description: String {
        return "chirality: \(chirality)\nallVectors: \(allVectors)"
    }
    /// All vectors of this skeleton.
    public let allVectors: [HandSkeleton.JointName: VectorInfo]
    
    public func vector(to named: HandSkeleton.JointName) -> VectorInfo {
        return allVectors[named]!
    }
    
    private init(chirality: HandAnchor.Chirality, allVectors: [HandSkeleton.JointName: VectorInfo]) {
        self.chirality = chirality
        self.allVectors = allVectors
    }
    public init?(handAnchor: HandAnchor) {
        guard let handSkeleton = handAnchor.handSkeleton else  {
            return nil
        }
        self.init(chirality: handAnchor.chirality, handSkeleton: handSkeleton)
    }
    public init(chirality: HandAnchor.Chirality, handSkeleton: HandSkeleton) {
        self.chirality = chirality
        self.allVectors = Self.genetateVectors(from: handSkeleton)
    }
    
    public static func genetateVectors(from handSkeleton: HandSkeleton) -> [HandSkeleton.JointName: VectorInfo] {
        var vectors: [HandSkeleton.JointName: VectorInfo] = [:]
        
        let wrist = handSkeleton.joint(.wrist)
        let forearmWrist = handSkeleton.joint(.forearmWrist)
        let forearmArm = handSkeleton.joint(.forearmArm)
        
        vectors[.forearmWrist] = VectorInfo(from: PositionInfo(joint: forearmArm), to: PositionInfo(joint: forearmWrist))
        vectors[.forearmArm] = VectorInfo(from: PositionInfo(joint: forearmWrist), to: PositionInfo(joint: forearmArm))
        vectors[.wrist] = VectorInfo(from: PositionInfo(joint: forearmArm), to: PositionInfo(joint: wrist))
        
        let thumbKnuckle = handSkeleton.joint(.thumbKnuckle)
        let thumbIntermediateBase = handSkeleton.joint(.thumbIntermediateBase)
        let thumbIntermediateTip = handSkeleton.joint(.thumbIntermediateTip)
        let thumbTip = handSkeleton.joint(.thumbTip)
        
        vectors[.thumbKnuckle] = VectorInfo(from: PositionInfo(joint: wrist), to: PositionInfo(joint: thumbKnuckle))
        vectors[.thumbIntermediateBase] = VectorInfo(from: PositionInfo(joint: thumbKnuckle), to: PositionInfo(joint: thumbIntermediateBase))
        vectors[.thumbIntermediateTip] = VectorInfo(from: PositionInfo(joint: thumbIntermediateBase), to: PositionInfo(joint: thumbIntermediateTip))
        vectors[.thumbTip] = VectorInfo(from: PositionInfo(joint: thumbIntermediateTip), to: PositionInfo(joint: thumbTip))

        
        let indexFingerMetacarpal = handSkeleton.joint(.indexFingerMetacarpal)
        let indexFingerKnuckle = handSkeleton.joint(.indexFingerKnuckle)
        let indexFingerIntermediateBase = handSkeleton.joint(.indexFingerIntermediateBase)
        let indexFingerIntermediateTip = handSkeleton.joint(.indexFingerIntermediateTip)
        let indexFingerTip = handSkeleton.joint(.indexFingerTip)
        
        vectors[.indexFingerMetacarpal] = VectorInfo(from: PositionInfo(joint: wrist), to: PositionInfo(joint: indexFingerMetacarpal))
        vectors[.indexFingerKnuckle] = VectorInfo(from: PositionInfo(joint: indexFingerMetacarpal), to: PositionInfo(joint: indexFingerKnuckle))
        vectors[.indexFingerIntermediateBase] = VectorInfo(from: PositionInfo(joint: indexFingerKnuckle), to: PositionInfo(joint: indexFingerIntermediateBase))
        vectors[.indexFingerIntermediateTip] = VectorInfo(from: PositionInfo(joint: indexFingerIntermediateBase), to: PositionInfo(joint: indexFingerIntermediateTip))
        vectors[.indexFingerTip] = VectorInfo(from: PositionInfo(joint: indexFingerIntermediateTip), to: PositionInfo(joint: indexFingerTip))
        
        
        let middleFingerMetacarpal = handSkeleton.joint(.middleFingerMetacarpal)
        let middleFingerKnuckle = handSkeleton.joint(.middleFingerKnuckle)
        let middleFingerIntermediateBase = handSkeleton.joint(.middleFingerIntermediateBase)
        let middleFingerIntermediateTip = handSkeleton.joint(.middleFingerIntermediateTip)
        let middleFingerTip = handSkeleton.joint(.middleFingerTip)
        
        vectors[.middleFingerMetacarpal] = VectorInfo(from: PositionInfo(joint: wrist), to: PositionInfo(joint: middleFingerMetacarpal))
        vectors[.middleFingerKnuckle] = VectorInfo(from: PositionInfo(joint: middleFingerMetacarpal), to: PositionInfo(joint: middleFingerKnuckle))
        vectors[.middleFingerIntermediateBase] = VectorInfo(from: PositionInfo(joint: middleFingerKnuckle), to: PositionInfo(joint: middleFingerIntermediateBase))
        vectors[.middleFingerIntermediateTip] = VectorInfo(from: PositionInfo(joint: middleFingerIntermediateBase), to: PositionInfo(joint: middleFingerIntermediateTip))
        vectors[.middleFingerTip] = VectorInfo(from: PositionInfo(joint: middleFingerIntermediateTip), to: PositionInfo(joint: middleFingerTip))
        
        
        let ringFingerMetacarpal = handSkeleton.joint(.ringFingerMetacarpal)
        let ringFingerKnuckle = handSkeleton.joint(.ringFingerKnuckle)
        let ringFingerIntermediateBase = handSkeleton.joint(.ringFingerIntermediateBase)
        let ringFingerIntermediateTip = handSkeleton.joint(.ringFingerIntermediateTip)
        let ringFingerTip = handSkeleton.joint(.ringFingerTip)
        
        vectors[.ringFingerMetacarpal] = VectorInfo(from: PositionInfo(joint: wrist), to: PositionInfo(joint: ringFingerMetacarpal))
        vectors[.ringFingerKnuckle] = VectorInfo(from: PositionInfo(joint: ringFingerMetacarpal), to: PositionInfo(joint: ringFingerKnuckle))
        vectors[.ringFingerIntermediateBase] = VectorInfo(from: PositionInfo(joint: ringFingerKnuckle), to: PositionInfo(joint: ringFingerIntermediateBase))
        vectors[.ringFingerIntermediateTip] = VectorInfo(from: PositionInfo(joint: ringFingerIntermediateBase), to: PositionInfo(joint: ringFingerIntermediateTip))
        vectors[.ringFingerTip] = VectorInfo(from: PositionInfo(joint: ringFingerIntermediateTip), to: PositionInfo(joint: ringFingerTip))
        
        
        let littleFingerMetacarpal = handSkeleton.joint(.littleFingerMetacarpal)
        let littleFingerKnuckle = handSkeleton.joint(.littleFingerKnuckle)
        let littleFingerIntermediateBase = handSkeleton.joint(.littleFingerIntermediateBase)
        let littleFingerIntermediateTip = handSkeleton.joint(.littleFingerIntermediateTip)
        let littleFingerTip = handSkeleton.joint(.littleFingerTip)
        
        vectors[.littleFingerMetacarpal] = VectorInfo(from: PositionInfo(joint: wrist), to: PositionInfo(joint: littleFingerMetacarpal))
        vectors[.littleFingerKnuckle] = VectorInfo(from: PositionInfo(joint: littleFingerMetacarpal), to: PositionInfo(joint: littleFingerKnuckle))
        vectors[.littleFingerIntermediateBase] = VectorInfo(from: PositionInfo(joint: littleFingerKnuckle), to: PositionInfo(joint: littleFingerIntermediateBase))
        vectors[.littleFingerIntermediateTip] = VectorInfo(from: PositionInfo(joint: littleFingerIntermediateBase), to: PositionInfo(joint: littleFingerIntermediateTip))
        vectors[.littleFingerTip] = VectorInfo(from: PositionInfo(joint: littleFingerIntermediateTip), to: PositionInfo(joint: littleFingerTip))
        
        return vectors
    }
    
    
}
public extension HandVector {
    enum JointOfFinger: CaseIterable {
        case thump
        case indexFinger
        case middleFinger
        case ringFinger
        case littleFinger
        
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
            }
        }
        static let keyWeight: Float = 1.0
        static let normalWeight: Float = 0.8
        static let insensitiveWeight: Float = 0.5
    }
    
    func similarity(to vector: HandVector, mirrorIfNeeded: Bool = true) -> Float {
        var similarity: Float = 0
        similarity = HandSkeleton.JointName.allCases.map { name in
            let dv = dot(vector.vector(to: name).normalizedVector, self.vector(to: name).normalizedVector)
            return dv
        }.reduce(similarity) { $0 + $1 }
        if mirrorIfNeeded, chirality != vector.chirality {
            similarity *= -1
        }
        similarity /= Float(HandSkeleton.JointName.allCases.count)
        return similarity
    }
    func similarity(of keyFingers: [JointOfFinger], normalFingers: [JointOfFinger] = [], insensitiveFingers: [JointOfFinger] = [], to vector: HandVector, mirrorIfNeeded: Bool = true) -> Float {
        var similarity: Float = 0
        
        let keyJoints = keyFingers.flatMap { $0.jointNames }
        similarity = keyJoints.map { name in
            let dv = dot(vector.vector(to: name).normalizedVector, self.vector(to: name).normalizedVector)
            return dv * JointOfFinger.keyWeight
        }.reduce(similarity) { $0 + $1 }
        
        let normalJoints = normalFingers.flatMap { $0.jointNames }
        similarity = normalJoints.map { name in
            let dv = dot(vector.vector(to: name).normalizedVector, self.vector(to: name).normalizedVector)
            return dv * JointOfFinger.normalWeight
        }.reduce(similarity) { $0 + $1 }
        
        let insensitiveJoints = insensitiveFingers.flatMap { $0.jointNames }
        similarity = insensitiveJoints.map { name in
            let dv = dot(vector.vector(to: name).normalizedVector, self.vector(to: name).normalizedVector)
            return dv * JointOfFinger.insensitiveWeight
        }.reduce(similarity) { $0 + $1 }
        
        if mirrorIfNeeded, chirality != vector.chirality {
            similarity *= -1
        }
        let weights = Float(keyJoints.count) * JointOfFinger.keyWeight + Float(normalJoints.count) * JointOfFinger.normalWeight + Float(insensitiveJoints.count) * JointOfFinger.insensitiveWeight
        similarity /= weights
        
        return similarity
    }
    func similarity(of finger: JointOfFinger, to vector: HandVector, mirrorIfNeeded: Bool = true) -> Float {
        var similarity: Float = 0
        similarity = finger.jointNames.map { name in
            let dv = dot(vector.vector(to: name).normalizedVector, self.vector(to: name).normalizedVector)
            return dv
        }.reduce(0) { $0 + $1 }
        if mirrorIfNeeded, chirality != vector.chirality {
            similarity *= -1
        }
        similarity /= Float(finger.jointNames.count)
        return similarity
    }
    
    func reverseChirality() -> HandVector {
        var infoNew: [HandSkeleton.JointName: VectorInfo] = [:]
        for (name, info) in allVectors {
            infoNew[name] = info.reverseChirality()
        }
        let m = HandVector(chirality: chirality == .left ? .right : .left, allVectors: infoNew)
        return m
    }
}

fileprivate extension HandSkeleton.Joint {
    var localPosition: simd_float3 {
        return anchorFromJointTransform.columns.3.xyz
    }
}

