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

public struct HandVector: CustomStringConvertible, @unchecked Sendable, Hashable, Codable {
    public struct VectorInfo: CustomStringConvertible, Hashable, @unchecked Sendable, Codable {
        public let from: HandSkeleton.JointName
        public let to: HandSkeleton.JointName
        public let isFromTracked: Bool
        public let isToTracked: Bool
        public let vector: simd_float3
        public let normalizedVector: simd_float3
        
        public var description: String {
            return "from: \(from), isFromTracked: \(isFromTracked),\nto: \(to), isToTracked: \(isToTracked), vector: \(vector)"
        }
        public init(from: HandSkeleton.JointName, to: HandSkeleton.JointName, isFromTracked: Bool, isToTracked: Bool, vector: simd_float3) {
            self.from = from
            self.to = to
            self.isFromTracked = isFromTracked
            self.isToTracked = isToTracked
            self.vector = vector
            if vector == .zero {
                self.normalizedVector = .zero
            } else {
                self.normalizedVector = normalize(vector)
            }
        }
    }
    
    public let chirality: HandAnchor.Chirality
    /// A textual representation of this Skeleton.
    public var description: String {
        return "chirality: \(chirality)\nallVectors: \(allVectors)"
    }
    /// All joints of this skeleton.
    public let allVectors: [HandSkeleton.JointName: VectorInfo]
    
    public func vector(to named: HandSkeleton.JointName) -> VectorInfo {
        return allVectors[named]!
    }
    
    private init(chirality: HandAnchor.Chirality, allVectors: [HandSkeleton.JointName: VectorInfo]) {
        self.chirality = chirality
        self.allVectors = allVectors
    }
    init?(handAnchor: HandAnchor) {
        guard let handSkeleton = handAnchor.handSkeleton else  {
            return nil
        }
        self.init(chirality: handAnchor.chirality, handSkeleton: handSkeleton)
    }
    init(chirality: HandAnchor.Chirality, handSkeleton: HandSkeleton) {
        self.chirality = chirality
        self.allVectors = Self.genetateVectors(from: handSkeleton)
    }
    
    static func genetateVectors(from handSkeleton: HandSkeleton) -> [HandSkeleton.JointName: VectorInfo] {
        var vectors: [HandSkeleton.JointName: VectorInfo] = [:]
        
        let wrist = handSkeleton.joint(.wrist)
        
        let thumb1 = handSkeleton.joint(.thumbKnuckle)
        let thumb2 = handSkeleton.joint(.thumbIntermediateBase)
        let thumb3 = handSkeleton.joint(.thumbIntermediateTip)
        let thumb4 = handSkeleton.joint(.thumbTip)
        
        let thumbKnuckle = VectorInfo(from: .wrist, to: .thumbKnuckle, isFromTracked: wrist.isTracked, isToTracked: thumb1.isTracked, vector: thumb1.localPosition - wrist.localPosition)
        let thumbIntermediateBase = VectorInfo(from: .thumbKnuckle, to: .thumbIntermediateBase, isFromTracked: thumb1.isTracked, isToTracked: thumb2.isTracked, vector: thumb2.localPosition - thumb1.localPosition)
        let thumbIntermediateTip = VectorInfo(from: .thumbIntermediateBase, to: .thumbIntermediateTip, isFromTracked: thumb2.isTracked, isToTracked: thumb3.isTracked, vector: thumb3.localPosition - thumb2.localPosition)
        let thumbTip = VectorInfo(from: .thumbIntermediateTip, to: .thumbTip, isFromTracked: thumb3.isTracked, isToTracked: thumb4.isTracked, vector: thumb4.localPosition - thumb3.localPosition)
        
        vectors[.thumbKnuckle] = thumbKnuckle
        vectors[.thumbIntermediateBase] = thumbIntermediateBase
        vectors[.thumbIntermediateTip] = thumbIntermediateTip
        vectors[.thumbTip] = thumbTip
        
        
        let index1 = handSkeleton.joint(.indexFingerMetacarpal)
        let index2 = handSkeleton.joint(.indexFingerKnuckle)
        let index3 = handSkeleton.joint(.indexFingerIntermediateBase)
        let index4 = handSkeleton.joint(.indexFingerIntermediateTip)
        let index5 = handSkeleton.joint(.indexFingerTip)
        
        let indexFingerMetacarpal = VectorInfo(from: .wrist, to: .indexFingerMetacarpal, isFromTracked: wrist.isTracked, isToTracked: index1.isTracked, vector: index1.localPosition - wrist.localPosition)
        let indexFingerKnuckle = VectorInfo(from: .indexFingerMetacarpal, to: .indexFingerKnuckle, isFromTracked: index1.isTracked, isToTracked: index2.isTracked, vector: index2.localPosition - index1.localPosition)
        let indexFingerIntermediateBase = VectorInfo(from: .indexFingerKnuckle, to: .indexFingerIntermediateBase, isFromTracked: index2.isTracked, isToTracked: index3.isTracked, vector: index3.localPosition - index2.localPosition)
        let indexFingerIntermediateTip = VectorInfo(from: .indexFingerIntermediateBase, to: .indexFingerIntermediateTip, isFromTracked: index3.isTracked, isToTracked: index4.isTracked, vector: index4.localPosition - index3.localPosition)
        let indexFingerTip = VectorInfo(from: .indexFingerIntermediateTip, to: .indexFingerTip, isFromTracked: index4.isTracked, isToTracked: index5.isTracked, vector: index5.localPosition - index4.localPosition)
        
        vectors[.indexFingerMetacarpal] = indexFingerMetacarpal
        vectors[.indexFingerKnuckle] = indexFingerKnuckle
        vectors[.indexFingerIntermediateBase] = indexFingerIntermediateBase
        vectors[.indexFingerIntermediateTip] = indexFingerIntermediateTip
        vectors[.indexFingerTip] = indexFingerTip
        
        
        let middle1 = handSkeleton.joint(.middleFingerMetacarpal)
        let middle2 = handSkeleton.joint(.middleFingerKnuckle)
        let middle3 = handSkeleton.joint(.middleFingerIntermediateBase)
        let middle4 = handSkeleton.joint(.middleFingerIntermediateTip)
        let middle5 = handSkeleton.joint(.middleFingerTip)
        
        let middleFingerMetacarpal = VectorInfo(from: .wrist, to: .middleFingerMetacarpal, isFromTracked: wrist.isTracked, isToTracked: middle1.isTracked, vector: middle1.localPosition - wrist.localPosition)
        let middleFingerKnuckle = VectorInfo(from: .middleFingerMetacarpal, to: .middleFingerKnuckle, isFromTracked: middle1.isTracked, isToTracked: middle2.isTracked, vector: middle2.localPosition - middle1.localPosition)
        let middleFingerIntermediateBase = VectorInfo(from: .middleFingerKnuckle, to: .middleFingerIntermediateBase, isFromTracked: middle2.isTracked, isToTracked: middle3.isTracked, vector: middle3.localPosition - middle2.localPosition)
        let middleFingerIntermediateTip = VectorInfo(from: .middleFingerIntermediateBase, to: .middleFingerIntermediateTip, isFromTracked: middle3.isTracked, isToTracked: middle4.isTracked, vector: middle4.localPosition - middle3.localPosition)
        let middleFingerTip = VectorInfo(from: .middleFingerIntermediateTip, to: .middleFingerTip, isFromTracked: middle4.isTracked, isToTracked: middle5.isTracked, vector: middle5.localPosition - middle4.localPosition)
        
        vectors[.middleFingerMetacarpal] = middleFingerMetacarpal
        vectors[.middleFingerKnuckle] = middleFingerKnuckle
        vectors[.middleFingerIntermediateBase] = middleFingerIntermediateBase
        vectors[.middleFingerIntermediateTip] = middleFingerIntermediateTip
        vectors[.middleFingerTip] = middleFingerTip
        
        
        let ring1 = handSkeleton.joint(.ringFingerMetacarpal)
        let ring2 = handSkeleton.joint(.ringFingerKnuckle)
        let ring3 = handSkeleton.joint(.ringFingerIntermediateBase)
        let ring4 = handSkeleton.joint(.ringFingerIntermediateTip)
        let ring5 = handSkeleton.joint(.ringFingerTip)
        
        let ringFingerMetacarpal = VectorInfo(from: .wrist, to: .ringFingerMetacarpal, isFromTracked: wrist.isTracked, isToTracked: ring1.isTracked, vector: ring1.localPosition - wrist.localPosition)
        let ringFingerKnuckle = VectorInfo(from: .ringFingerMetacarpal, to: .ringFingerKnuckle, isFromTracked: ring1.isTracked, isToTracked: ring2.isTracked, vector: ring2.localPosition - ring1.localPosition)
        let ringFingerIntermediateBase = VectorInfo(from: .ringFingerKnuckle, to: .ringFingerIntermediateBase, isFromTracked: ring2.isTracked, isToTracked: ring3.isTracked, vector: ring3.localPosition - ring2.localPosition)
        let ringFingerIntermediateTip = VectorInfo(from: .ringFingerIntermediateBase, to: .ringFingerIntermediateTip, isFromTracked: ring3.isTracked, isToTracked: ring4.isTracked, vector: ring4.localPosition - ring3.localPosition)
        let ringFingerTip = VectorInfo(from: .ringFingerIntermediateTip, to: .ringFingerTip, isFromTracked: ring4.isTracked, isToTracked: ring5.isTracked, vector: ring5.localPosition - ring4.localPosition)
        
        vectors[.ringFingerMetacarpal] = ringFingerMetacarpal
        vectors[.ringFingerKnuckle] = ringFingerKnuckle
        vectors[.ringFingerIntermediateBase] = ringFingerIntermediateBase
        vectors[.ringFingerIntermediateTip] = ringFingerIntermediateTip
        vectors[.ringFingerTip] = ringFingerTip
        
        
        let little1 = handSkeleton.joint(.littleFingerMetacarpal)
        let little2 = handSkeleton.joint(.littleFingerKnuckle)
        let little3 = handSkeleton.joint(.littleFingerIntermediateBase)
        let little4 = handSkeleton.joint(.littleFingerIntermediateTip)
        let little5 = handSkeleton.joint(.littleFingerTip)
        
        let littleFingerMetacarpal = VectorInfo(from: .wrist, to: .littleFingerMetacarpal, isFromTracked: wrist.isTracked, isToTracked: little1.isTracked, vector: little1.localPosition - wrist.localPosition)
        let littleFingerKnuckle = VectorInfo(from: .littleFingerMetacarpal, to: .littleFingerKnuckle, isFromTracked: little1.isTracked, isToTracked: little2.isTracked, vector: little2.localPosition - little1.localPosition)
        let littleFingerIntermediateBase = VectorInfo(from: .littleFingerKnuckle, to: .littleFingerIntermediateBase, isFromTracked: little2.isTracked, isToTracked: little3.isTracked, vector: little3.localPosition - little2.localPosition)
        let littleFingerIntermediateTip = VectorInfo(from: .littleFingerIntermediateBase, to: .littleFingerIntermediateTip, isFromTracked: little3.isTracked, isToTracked: little4.isTracked, vector: little4.localPosition - little3.localPosition)
        let littleFingerTip = VectorInfo(from: .littleFingerIntermediateTip, to: .littleFingerTip, isFromTracked: little4.isTracked, isToTracked: little5.isTracked, vector: little5.localPosition - little4.localPosition)
        
        vectors[.littleFingerMetacarpal] = littleFingerMetacarpal
        vectors[.littleFingerKnuckle] = littleFingerKnuckle
        vectors[.littleFingerIntermediateBase] = littleFingerIntermediateBase
        vectors[.littleFingerIntermediateTip] = littleFingerIntermediateTip
        vectors[.littleFingerTip] = littleFingerTip
        
        
        let forearm1 = handSkeleton.joint(.forearmWrist)
        let forearm2 = handSkeleton.joint(.forearmArm)
        
        let forearmWrist = VectorInfo(from: .forearmArm, to: .forearmWrist, isFromTracked: forearm2.isTracked, isToTracked: forearm1.isTracked, vector: forearm1.localPosition - forearm2.localPosition)
        let forearmArm = VectorInfo(from: .forearmWrist, to: .forearmArm, isFromTracked: forearm1.isTracked, isToTracked: forearm2.isTracked, vector: forearm2.localPosition - forearm1.localPosition)
        
        vectors[.forearmWrist] = forearmWrist
        vectors[.forearmArm] = forearmArm
        vectors[.wrist] = VectorInfo(from: .forearmArm, to: .wrist, isFromTracked: forearm2.isTracked, isToTracked: wrist.isTracked, vector: wrist.localPosition - forearm2.localPosition)
        
        return vectors
    }
    
    func compare(_ vector: HandVector, mirrorIfNeeded: Bool = true) -> Float {
        var simility: Float = 0
        HandSkeleton.JointName.allCases.forEach { name in
            let dv = dot(vector.vector(to: name).normalizedVector, self.vector(to: name).normalizedVector)
            simility += dv
        }
        if mirrorIfNeeded, chirality != vector.chirality {
            simility *= -1
        }
        simility /= Float(HandSkeleton.JointName.allCases.count)
        return simility
    }
    
    func mirror() -> HandVector {
        var infoNew: [HandSkeleton.JointName: VectorInfo] = [:]
        for (name, info) in allVectors {
            infoNew[name] = VectorInfo(from: info.from, to: info.to, isFromTracked: info.isFromTracked, isToTracked: info.isToTracked, vector: -info.vector)
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
extension HandAnchor.Chirality: Codable {
    private var codingKeys: String {
        switch self {
        case .left:
            return "left"
        case .right:
            return "right"
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let nameStr = try container.decode(String.self)
        switch nameStr {
        case "left":
            self = .left
        case "right":
            self = .right
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown Chirality")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.codingKeys)
    }
}

extension HandSkeleton.JointName: Codable {
    private var codingKeys: String {
        switch self {
        case .wrist:
            return "wrist"
        case .thumbKnuckle:
            return "thumbKnuckle"
        case .thumbIntermediateBase:
            return "thumbIntermediateBase"
        case .thumbIntermediateTip:
            return "thumbIntermediateTip"
        case .thumbTip:
            return "thumbTip"
        case .indexFingerMetacarpal:
            return "indexFingerMetacarpal"
        case .indexFingerKnuckle:
            return "indexFingerKnuckle"
        case .indexFingerIntermediateBase:
            return "indexFingerIntermediateBase"
        case .indexFingerIntermediateTip:
            return "indexFingerIntermediateTip"
        case .indexFingerTip:
            return "indexFingerTip"
        case .middleFingerMetacarpal:
            return "middleFingerMetacarpal"
        case .middleFingerKnuckle:
            return "middleFingerKnuckle"
        case .middleFingerIntermediateBase:
            return "middleFingerIntermediateBase"
        case .middleFingerIntermediateTip:
            return "middleFingerIntermediateTip"
        case .middleFingerTip:
            return "middleFingerTip"
        case .ringFingerMetacarpal:
            return "ringFingerMetacarpal"
        case .ringFingerKnuckle:
            return "ringFingerKnuckle"
        case .ringFingerIntermediateBase:
            return "ringFingerIntermediateBase"
        case .ringFingerIntermediateTip:
            return "ringFingerIntermediateTip"
        case .ringFingerTip:
            return "ringFingerTip"
        case .littleFingerMetacarpal:
            return "littleFingerMetacarpal"
        case .littleFingerKnuckle:
            return "littleFingerKnuckle"
        case .littleFingerIntermediateBase:
            return "littleFingerIntermediateBase"
        case .littleFingerIntermediateTip:
            return "littleFingerIntermediateTip"
        case .littleFingerTip:
            return "littleFingerTip"
        case .forearmWrist:
            return "forearmWrist"
        case .forearmArm:
            return "forearmArm"
        @unknown default:
            return self.description
        }
    }
    private static func jointName(from codingKey: String) -> HandSkeleton.JointName? {
        switch codingKey {
        case "wrist":
            return .wrist
        case "thumbKnuckle":
            return .thumbKnuckle
        case "thumbIntermediateBase":
            return .thumbIntermediateBase
        case "thumbIntermediateTip":
            return .thumbIntermediateTip
        case "thumbTip":
            return .thumbTip
        case "indexFingerMetacarpal":
            return .indexFingerMetacarpal
        case "indexFingerKnuckle":
            return .indexFingerKnuckle
        case "indexFingerIntermediateBase":
            return .indexFingerIntermediateBase
        case "indexFingerIntermediateTip":
            return .indexFingerIntermediateTip
        case "indexFingerTip":
            return .indexFingerTip
        case "middleFingerMetacarpal":
            return .middleFingerMetacarpal
        case "middleFingerKnuckle":
            return .middleFingerKnuckle
        case "middleFingerIntermediateBase":
            return .middleFingerIntermediateBase
        case "middleFingerIntermediateTip":
            return .middleFingerIntermediateTip
        case "middleFingerTip":
            return .middleFingerTip
        case "ringFingerMetacarpal":
            return .ringFingerMetacarpal
        case "ringFingerKnuckle":
            return .ringFingerKnuckle
        case "ringFingerIntermediateBase":
            return .ringFingerIntermediateBase
        case "ringFingerIntermediateTip":
            return .ringFingerIntermediateTip
        case "ringFingerTip":
            return .ringFingerTip
        case "littleFingerMetacarpal":
            return .littleFingerMetacarpal
        case "littleFingerKnuckle":
            return .littleFingerKnuckle
        case "littleFingerIntermediateBase":
            return .littleFingerIntermediateBase
        case "littleFingerIntermediateTip":
            return .littleFingerIntermediateTip
        case "littleFingerTip":
            return .littleFingerTip
        case "forearmWrist":
            return .forearmWrist
        case "forearmArm":
            return .forearmArm
        default:
            return nil
        }
    }
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let nameStr = try container.decode(String.self)
        if let jn = Self.jointName(from: nameStr) {
            self = jn
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unknown JointName:\(nameStr)")
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(self.codingKeys)
    }
}
