//
//  HandAnchor+Extensions.swift
//  HandVector
//
//  Created by xu on 2023/9/28.
//

import Foundation
import simd
import ARKit


public extension HandAnchor.Chirality {
    enum NameCodingKey: String, Codable, CodingKey {
        case right
        case left
        
        public var description: String {
            return self.rawValue
        }
    }
    var codableName: NameCodingKey {
        switch self {
        case .right:
            return .right
        case .left:
            return .left
        }
    }
}
public extension HandSkeleton.JointName {
    enum NameCodingKey: String, Codable, CodingKey, CaseIterable {
        case wrist

        /// The thumb knuckle joint of a hand skeleton.
        case thumbKnuckle

        /// The thumb intermediate base joint of a hand skeleton.
        case thumbIntermediateBase

        /// The thumb intermediate tip joint of a hand skeleton.
        case thumbIntermediateTip

        /// The thumb tip joint of a hand skeleton.
        case thumbTip

        /// The index finger metacarpal joint of a hand skeleton.
        case indexFingerMetacarpal

        /// The index finger knuckle joint of a hand skeleton.
        case indexFingerKnuckle

        /// The index finger intermediate base joint of a hand skeleton.
        case indexFingerIntermediateBase

        /// The index finger intermediate tip joint of a hand skeleton.
        case indexFingerIntermediateTip

        /// The index finger tip joint of a hand skeleton.
        case indexFingerTip

        /// The middle finger metacarpal joint of a hand skeleton.
        case middleFingerMetacarpal

        /// The middle finger knuckle joint of a hand skeleton.
        case middleFingerKnuckle

        /// The middle finger intermediate base joint of a hand skeleton.
        case middleFingerIntermediateBase

        /// The middle finger intermediate tip joint of a hand skeleton.
        case middleFingerIntermediateTip

        /// The middle finger tip joint of a hand skeleton.
        case middleFingerTip

        /// The ring finger metacarpal joint of a hand skeleton.
        case ringFingerMetacarpal

        /// The ring finger knuckle joint of a hand skeleton.
        case ringFingerKnuckle

        /// The ring finger intermediate base joint of a hand skeleton.
        case ringFingerIntermediateBase

        /// The ring finger intermediate tip joint of a hand skeleton.
        case ringFingerIntermediateTip

        /// The ring finger tip joint of a hand skeleton.
        case ringFingerTip

        /// The little finger metacarpal joint of a hand skeleton.
        case littleFingerMetacarpal

        /// The little finger knuckle joint of a hand skeleton.
        case littleFingerKnuckle

        /// The little finger intermediate base joint of a hand skeleton.
        case littleFingerIntermediateBase

        /// The little finger intermediate tip joint of a hand skeleton.
        case littleFingerIntermediateTip

        /// The little finger tip joint of a hand skeleton.
        case littleFingerTip

        /// The wrist joint at the forearm of a hand skeleton.
        case forearmWrist

        /// The forearm joint of a hand skeleton.
        case forearmArm
        
        case unknown
        
        public var description: String {
            return self.rawValue
        }
        
        
        public var parentName: HandSkeleton.JointName.NameCodingKey? {
            return Self.getParentName(jointName: self)
        }
        
        private static func getParentName(jointName:HandSkeleton.JointName.NameCodingKey) -> HandSkeleton.JointName.NameCodingKey? {
            switch jointName {
            case .wrist:
                return nil
            case .thumbKnuckle:
                return .wrist
            case .thumbIntermediateBase:
                return .thumbKnuckle
            case .thumbIntermediateTip:
                return .thumbIntermediateBase
            case .thumbTip:
                return .thumbIntermediateTip
            case .indexFingerMetacarpal:
                return .wrist
            case .indexFingerKnuckle:
                return .indexFingerMetacarpal
            case .indexFingerIntermediateBase:
                return .indexFingerKnuckle
            case .indexFingerIntermediateTip:
                return .indexFingerIntermediateBase
            case .indexFingerTip:
                return .indexFingerIntermediateTip
            case .middleFingerMetacarpal:
                return .wrist
            case .middleFingerKnuckle:
                return .middleFingerMetacarpal
            case .middleFingerIntermediateBase:
                return .middleFingerKnuckle
            case .middleFingerIntermediateTip:
                return .middleFingerIntermediateBase
            case .middleFingerTip:
                return .middleFingerIntermediateTip
            case .ringFingerMetacarpal:
                return .wrist
            case .ringFingerKnuckle:
                return .ringFingerMetacarpal
            case .ringFingerIntermediateBase:
                return .ringFingerKnuckle
            case .ringFingerIntermediateTip:
                return .ringFingerIntermediateBase
            case .ringFingerTip:
                return .ringFingerIntermediateTip
            case .littleFingerMetacarpal:
                return .wrist
            case .littleFingerKnuckle:
                return .littleFingerMetacarpal
            case .littleFingerIntermediateBase:
                return .littleFingerKnuckle
            case .littleFingerIntermediateTip:
                return .littleFingerIntermediateBase
            case .littleFingerTip:
                return .littleFingerIntermediateTip
            case .forearmWrist:
                return .wrist
            case .forearmArm:
                return .forearmWrist
            case .unknown:
                return nil
            default:
                return nil
            }
        }
    }
    var codableName: NameCodingKey {
        switch self {
        case .wrist:
            return .wrist
        case .thumbKnuckle:
            return .thumbKnuckle
        case .thumbIntermediateBase:
            return .thumbIntermediateBase
        case .thumbIntermediateTip:
            return .thumbIntermediateTip
        case .thumbTip:
            return .thumbTip
        case .indexFingerMetacarpal:
            return .indexFingerMetacarpal
        case .indexFingerKnuckle:
            return .indexFingerKnuckle
        case .indexFingerIntermediateBase:
            return .indexFingerIntermediateBase
        case .indexFingerIntermediateTip:
            return .indexFingerIntermediateTip
        case .indexFingerTip:
            return .indexFingerTip
        case .middleFingerMetacarpal:
            return .middleFingerMetacarpal
        case .middleFingerKnuckle:
            return .middleFingerKnuckle
        case .middleFingerIntermediateBase:
            return .middleFingerIntermediateBase
        case .middleFingerIntermediateTip:
            return .middleFingerIntermediateTip
        case .middleFingerTip:
            return .middleFingerTip
        case .ringFingerMetacarpal:
            return .ringFingerMetacarpal
        case .ringFingerKnuckle:
            return .ringFingerKnuckle
        case .ringFingerIntermediateBase:
            return .ringFingerIntermediateBase
        case .ringFingerIntermediateTip:
            return .ringFingerIntermediateTip
        case .ringFingerTip:
            return .ringFingerTip
        case .littleFingerMetacarpal:
            return .littleFingerMetacarpal
        case .littleFingerKnuckle:
            return .littleFingerKnuckle
        case .littleFingerIntermediateBase:
            return .littleFingerIntermediateBase
        case .littleFingerIntermediateTip:
            return .littleFingerIntermediateTip
        case .littleFingerTip:
            return .littleFingerTip
        case .forearmWrist:
            return .forearmWrist
        case .forearmArm:
            return .forearmArm
        @unknown default:
            return .unknown
        }
    }
}

