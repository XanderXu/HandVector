//
//  File.swift
//  
//
//  Created by 许同学 on 2024/6/5.
//

import ARKit

public struct HVJointInfo: Sendable, Equatable {
    public let name: HandSkeleton.JointName.NameCodingKey
    public let isTracked: Bool
    public let transform: simd_float4x4
    
    private(set) var transformToParent: simd_float4x4
    
    public init(joint: HandSkeleton.Joint) {
        self.name = joint.name.codableName
        self.isTracked = joint.isTracked
        self.transform = joint.anchorFromJointTransform
        self.transformToParent = joint.parentFromJointTransform
    }
    
    public init(name: HandSkeleton.JointName.NameCodingKey, isTracked: Bool, anchorFromJointTransform: simd_float4x4, parentFromJointTransform: simd_float4x4) {
        self.name = name
        self.isTracked = isTracked
        self.transform = anchorFromJointTransform
        self.transformToParent = parentFromJointTransform
    }
    
    public mutating func updateTransformToParent(_ transform: simd_float4x4) {
        self.transformToParent = transform
    }
    public func reversedChirality() -> HVJointInfo {
        let anchorTransform = simd_float4x4(
            [transform.columns.0,
             transform.columns.1,
             transform.columns.2,
             SIMD4<Float>(-transform.columns.3.xyz, 1)]
        )
        let parentTransform = simd_float4x4(
            [transformToParent.columns.0,
             transformToParent.columns.1,
             transformToParent.columns.2,
             SIMD4<Float>(-transformToParent.columns.3.xyz, 1)]
        )
        return HVJointInfo(name: name, isTracked: isTracked, anchorFromJointTransform: anchorTransform, parentFromJointTransform: parentTransform)
    }

    public var position: SIMD3<Float> {
        return transform.columns.3.xyz
    }
    
}
extension HVJointInfo: CustomStringConvertible, Codable {
    public var description: String {
        return "name: \(name), isTracked: \(isTracked), position: \(transform.columns.0.xyz)"
    }
    
    enum CodingKeys: CodingKey {
        case name
        case isTracked
        case transform
        case transformToParent
    }
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<HVJointInfo.CodingKeys> = try decoder.container(keyedBy: HVJointInfo.CodingKeys.self)
        
        self.name = try container.decode(HandSkeleton.JointName.NameCodingKey.self, forKey: HVJointInfo.CodingKeys.name)
        self.isTracked = try container.decode(Bool.self, forKey: HVJointInfo.CodingKeys.isTracked)
        self.transform = try simd_float4x4(container.decode([SIMD4<Float>].self, forKey: HVJointInfo.CodingKeys.transform))
        
        let arrT = try container.decodeIfPresent([SIMD4<Float>].self, forKey: HVJointInfo.CodingKeys.transformToParent)
        if let arrT {
            self.transformToParent = simd_float4x4(arrT)
        } else {
            self.transformToParent = .init(diagonal: .one)
        }
        
    }
    
    public func encode(to encoder: Encoder) throws {
        var container: KeyedEncodingContainer<HVJointInfo.CodingKeys> = encoder.container(keyedBy: HVJointInfo.CodingKeys.self)
        
        try container.encode(self.name, forKey: HVJointInfo.CodingKeys.name)
        try container.encode(self.isTracked, forKey: HVJointInfo.CodingKeys.isTracked)
        try container.encode(self.transform.float4Array, forKey: HVJointInfo.CodingKeys.transform)
    }
}



public enum HVJointOfFinger: CaseIterable {
    case thump
    case indexFinger
    case middleFinger
    case ringFinger
    case littleFinger
    case wristMetacarpal
    case foreArm
    
    public var jointGroupNames: [HandSkeleton.JointName] {
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
    
    public static let allFingers: Set<HVJointOfFinger> = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger]
    public static let allFingersAndWrist: Set<HVJointOfFinger> = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .wristMetacarpal]
    public static let allFingersAndWristAndForearm: Set<HVJointOfFinger> = [.thump, .indexFinger, .middleFinger, .ringFinger, .littleFinger, .wristMetacarpal, .foreArm]
}


/*
 name:wrist,parent:nil
 name:thumbKnuckle,parent:Optional(wrist)
 name:thumbIntermediateBase,parent:Optional(thumbKnuckle)
 name:thumbIntermediateTip,parent:Optional(thumbIntermediateBase)
 name:thumbTip,parent:Optional(thumbIntermediateTip)
 name:indexFingerMetacarpal,parent:Optional(wrist)
 name:indexFingerKnuckle,parent:Optional(indexFingerMetacarpal)
 name:indexFingerIntermediateBase,parent:Optional(indexFingerKnuckle)
 name:indexFingerIntermediateTip,parent:Optional(indexFingerIntermediateBase)
 name:indexFingerTip,parent:Optional(indexFingerIntermediateTip)
 name:middleFingerMetacarpal,parent:Optional(wrist)
 name:middleFingerKnuckle,parent:Optional(middleFingerMetacarpal)
 name:middleFingerIntermediateBase,parent:Optional(middleFingerKnuckle)
 name:middleFingerIntermediateTip,parent:Optional(middleFingerIntermediateBase)
 name:middleFingerTip,parent:Optional(middleFingerIntermediateTip)
 name:ringFingerMetacarpal,parent:Optional(wrist)
 name:ringFingerKnuckle,parent:Optional(ringFingerMetacarpal)
 name:ringFingerIntermediateBase,parent:Optional(ringFingerKnuckle)
 name:ringFingerIntermediateTip,parent:Optional(ringFingerIntermediateBase)
 name:ringFingerTip,parent:Optional(ringFingerIntermediateTip)
 name:littleFingerMetacarpal,parent:Optional(wrist)
 name:littleFingerKnuckle,parent:Optional(littleFingerMetacarpal)
 name:littleFingerIntermediateBase,parent:Optional(littleFingerKnuckle)
 name:littleFingerIntermediateTip,parent:Optional(littleFingerIntermediateBase)
 name:littleFingerTip,parent:Optional(littleFingerIntermediateTip)
 name:forearmWrist,parent:Optional(wrist)
 name:forearmArm,parent:Optional(forearmWrist)
 
 ▿ 27 elements
   ▿ 0 : HandSkeleton.Joint(name: wrist, isTracked: true, parentFromJointTransform: <translation=(0.000000 0.000000 0.000000) rotation=(-0.00° 0.00° 0.00°)>, anchorFromJointTransform: <translation=(0.000000 0.000000 0.000000) rotation=(-0.00° 0.00° 0.00°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301486b80 name=hand_joint transform=<translation=(0.000000 0.000000 0.000000) rotation=(-0.00° 0.00° 0.00°)> tracked=YES>
   ▿ 1 : HandSkeleton.Joint(name: thumbKnuckle, isTracked: true, parentFromJointTransform: <translation=(-0.042254 -0.006919 0.021656) rotation=(61.00° 96.53° 69.27°)>, anchorFromJointTransform: <translation=(-0.042254 -0.006919 0.021656) rotation=(61.00° 96.53° 69.27°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x3014871b0 name=handThumbStart_joint transform=<translation=(-0.042254 -0.006919 0.021656) rotation=(61.00° 96.53° 69.27°)> tracked=YES>
   ▿ 2 : HandSkeleton.Joint(name: thumbIntermediateBase, isTracked: true, parentFromJointTransform: <translation=(-0.043353 0.005140 0.010334) rotation=(-0.95° -0.38° 15.99°)>, anchorFromJointTransform: <translation=(-0.068636 -0.034735 0.044958) rotation=(60.99° 94.42° 83.41°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301485410 name=handThumb_1_joint transform=<translation=(-0.068636 -0.034735 0.044958) rotation=(60.99° 94.42° 83.41°)> tracked=YES>
   ▿ 3 : HandSkeleton.Joint(name: thumbIntermediateTip, isTracked: true, parentFromJointTransform: <translation=(-0.031860 0.000706 0.001605) rotation=(-0.14° -0.65° -17.45°)>, anchorFromJointTransform: <translation=(-0.095052 -0.051445 0.051369) rotation=(61.62° 93.97° 65.57°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301487570 name=handThumb_2_joint transform=<translation=(-0.095052 -0.051445 0.051369) rotation=(61.62° 93.97° 65.57°)> tracked=YES>
   ▿ 4 : HandSkeleton.Joint(name: thumbTip, isTracked: true, parentFromJointTransform: <translation=(-0.030709 0.000075 -0.000494) rotation=(-0.00° -0.00° 0.00°)>, anchorFromJointTransform: <translation=(-0.118915 -0.064285 0.065824) rotation=(61.62° 93.97° 65.57°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301486ca0 name=handThumbEnd_joint transform=<translation=(-0.118915 -0.064285 0.065824) rotation=(61.62° 93.97° 65.57°)> tracked=YES>
   ▿ 5 : HandSkeleton.Joint(name: indexFingerMetacarpal, isTracked: true, parentFromJointTransform: <translation=(-0.031504 0.001581 0.018729) rotation=(-0.30° 9.94° 0.07°)>, anchorFromJointTransform: <translation=(-0.031504 0.001581 0.018729) rotation=(-0.30° 9.94° 0.07°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301485800 name=handIndexStart_joint transform=<translation=(-0.031504 0.001581 0.018729) rotation=(-0.30° 9.94° 0.07°)> tracked=YES>
   ▿ 6 : HandSkeleton.Joint(name: indexFingerKnuckle, isTracked: true, parentFromJointTransform: <translation=(-0.065266 -0.001279 0.000825) rotation=(8.52° -8.87° 60.15°)>, anchorFromJointTransform: <translation=(-0.095646 0.000225 0.030815) rotation=(8.23° 1.09° 60.27°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301485f80 name=handIndex_1_joint transform=<translation=(-0.095646 0.000225 0.030815) rotation=(8.23° 1.09° 60.27°)> tracked=YES>
   ▿ 7 : HandSkeleton.Joint(name: indexFingerIntermediateBase, isTracked: true, parentFromJointTransform: <translation=(-0.047502 0.001347 0.000158) rotation=(0.11° -0.31° 20.32°)>, anchorFromJointTransform: <translation=(-0.120478 -0.039959 0.025636) rotation=(8.55° 1.03° 80.58°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301487120 name=handIndex_2_joint transform=<translation=(-0.120478 -0.039959 0.025636) rotation=(8.55° 1.03° 80.58°)> tracked=YES>
   ▿ 8 : HandSkeleton.Joint(name: indexFingerIntermediateTip, isTracked: true, parentFromJointTransform: <translation=(-0.025429 0.000536 0.000043) rotation=(0.02° -0.00° 4.08°)>, anchorFromJointTransform: <translation=(-0.125233 -0.064686 0.022046) rotation=(8.55° 1.05° 84.67°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301487540 name=handIndex_3_joint transform=<translation=(-0.125233 -0.064686 0.022046) rotation=(8.55° 1.05° 84.67°)> tracked=YES>
   ▿ 9 : HandSkeleton.Joint(name: indexFingerTip, isTracked: true, parentFromJointTransform: <translation=(-0.022803 0.000436 0.000020) rotation=(0.00° -0.00° 0.00°)>, anchorFromJointTransform: <translation=(-0.127847 -0.087100 0.018742) rotation=(8.55° 1.05° 84.67°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301484990 name=handIndexEnd_joint transform=<translation=(-0.127847 -0.087100 0.018742) rotation=(8.55° 1.05° 84.67°)> tracked=YES>
   ▿ 10 : HandSkeleton.Joint(name: middleFingerMetacarpal, isTracked: true, parentFromJointTransform: <translation=(-0.026117 -0.000586 0.004392) rotation=(-0.23° -0.30° 0.08°)>, anchorFromJointTransform: <translation=(-0.026117 -0.000586 0.004392) rotation=(-0.23° -0.30° 0.08°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301485980 name=handMidStart_joint transform=<translation=(-0.026117 -0.000586 0.004392) rotation=(-0.23° -0.30° 0.08°)> tracked=YES>
   ▿ 11 : HandSkeleton.Joint(name: middleFingerKnuckle, isTracked: true, parentFromJointTransform: <translation=(-0.069248 0.000991 0.000262) rotation=(-1.64° -7.15° 33.74°)>, anchorFromJointTransform: <translation=(-0.095367 0.000314 0.004286) rotation=(-1.85° -7.45° 33.84°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x3014870f0 name=handMid_1_joint transform=<translation=(-0.095367 0.000314 0.004286) rotation=(-1.85° -7.45° 33.84°)> tracked=YES>
   ▿ 12 : HandSkeleton.Joint(name: middleFingerIntermediateBase, isTracked: true, parentFromJointTransform: <translation=(-0.050270 0.001176 0.000709) rotation=(0.80° -2.46° 50.77°)>, anchorFromJointTransform: <translation=(-0.137621 -0.026669 0.000356) rotation=(0.18° -9.05° 84.66°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301485bc0 name=handMid_2_joint transform=<translation=(-0.137621 -0.026669 0.000356) rotation=(0.18° -9.05° 84.66°)> tracked=YES>
   ▿ 13 : HandSkeleton.Joint(name: middleFingerIntermediateTip, isTracked: true, parentFromJointTransform: <translation=(-0.030280 0.000462 0.000276) rotation=(0.21° -0.52° 15.88°)>, anchorFromJointTransform: <translation=(-0.140888 -0.056775 0.000019) rotation=(0.72° -8.89° 100.54°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301487300 name=handMid_3_joint transform=<translation=(-0.140888 -0.056775 0.000019) rotation=(0.72° -8.89° 100.54°)> tracked=YES>
   ▿ 14 : HandSkeleton.Joint(name: middleFingerTip, isTracked: true, parentFromJointTransform: <translation=(-0.023289 0.000200 0.000140) rotation=(0.00° -0.00° 0.00°)>, anchorFromJointTransform: <translation=(-0.136849 -0.079707 0.000501) rotation=(0.72° -8.89° 100.54°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301486be0 name=handMidEnd_joint transform=<translation=(-0.136849 -0.079707 0.000501) rotation=(0.72° -8.89° 100.54°)> tracked=YES>
   ▿ 15 : HandSkeleton.Joint(name: ringFingerMetacarpal, isTracked: true, parentFromJointTransform: <translation=(-0.026337 -0.002043 -0.009747) rotation=(-0.17° -7.60° 0.07°)>, anchorFromJointTransform: <translation=(-0.026337 -0.002043 -0.009747) rotation=(-0.17° -7.60° 0.07°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x3014874b0 name=handRingStart_joint transform=<translation=(-0.026337 -0.002043 -0.009747) rotation=(-0.17° -7.60° 0.07°)> tracked=YES>
   ▿ 16 : HandSkeleton.Joint(name: ringFingerKnuckle, isTracked: true, parentFromJointTransform: <translation=(-0.066674 0.000900 0.000802) rotation=(1.98° 4.00° 26.53°)>, anchorFromJointTransform: <translation=(-0.092532 -0.001223 -0.017773) rotation=(1.81° -3.60° 26.58°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301485020 name=handRing_1_joint transform=<translation=(-0.092532 -0.001223 -0.017773) rotation=(1.81° -3.60° 26.58°)> tracked=YES>
   ▿ 17 : HandSkeleton.Joint(name: ringFingerIntermediateBase, isTracked: true, parentFromJointTransform: <translation=(-0.044196 0.000977 0.000622) rotation=(-0.17° 0.46° 52.88°)>, anchorFromJointTransform: <translation=(-0.132416 -0.020138 -0.020256) rotation=(1.45° -3.26° 79.47°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x3014873c0 name=handRing_2_joint transform=<translation=(-0.132416 -0.020138 -0.020256) rotation=(1.45° -3.26° 79.47°)> tracked=YES>
   ▿ 18 : HandSkeleton.Joint(name: ringFingerIntermediateTip, isTracked: true, parentFromJointTransform: <translation=(-0.027928 0.000530 0.000288) rotation=(0.13° -0.36° 14.76°)>, anchorFromJointTransform: <translation=(-0.138008 -0.047497 -0.020979) rotation=(1.82° -3.20° 94.23°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x3014853b0 name=handRing_3_joint transform=<translation=(-0.138008 -0.047497 -0.020979) rotation=(1.82° -3.20° 94.23°)> tracked=YES>
   ▿ 19 : HandSkeleton.Joint(name: ringFingerTip, isTracked: true, parentFromJointTransform: <translation=(-0.022174 0.000281 0.000165) rotation=(0.00° 0.00° 0.00°)>, anchorFromJointTransform: <translation=(-0.136623 -0.069625 -0.021442) rotation=(1.82° -3.20° 94.23°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301487030 name=handRingEnd_joint transform=<translation=(-0.136623 -0.069625 -0.021442) rotation=(1.82° -3.20° 94.23°)> tracked=YES>
   ▿ 20 : HandSkeleton.Joint(name: littleFingerMetacarpal, isTracked: true, parentFromJointTransform: <translation=(-0.025650 -0.003508 -0.025797) rotation=(-0.12° -12.99° 0.10°)>, anchorFromJointTransform: <translation=(-0.025650 -0.003508 -0.025797) rotation=(-0.12° -12.99° 0.10°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301487420 name=handPinkyStart_joint transform=<translation=(-0.025650 -0.003508 -0.025797) rotation=(-0.12° -12.99° 0.10°)> tracked=YES>
   ▿ 21 : HandSkeleton.Joint(name: littleFingerKnuckle, isTracked: true, parentFromJointTransform: <translation=(-0.057669 0.000738 0.001069) rotation=(-2.35° 3.95° 28.43°)>, anchorFromJointTransform: <translation=(-0.082084 -0.002863 -0.037721) rotation=(-2.48° -9.04° 28.52°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x3014872a0 name=handPinky_1_joint transform=<translation=(-0.082084 -0.002863 -0.037721) rotation=(-2.48° -9.04° 28.52°)> tracked=YES>
   ▿ 22 : HandSkeleton.Joint(name: littleFingerIntermediateBase, isTracked: true, parentFromJointTransform: <translation=(-0.036536 0.000826 0.000759) rotation=(-0.07° -0.40° 33.97°)>, anchorFromJointTransform: <translation=(-0.114411 -0.019531 -0.041365) rotation=(-2.35° -9.42° 62.51°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301486fd0 name=handPinky_2_joint transform=<translation=(-0.114411 -0.019531 -0.041365) rotation=(-2.35° -9.42° 62.51°)> tracked=YES>
   ▿ 23 : HandSkeleton.Joint(name: littleFingerIntermediateTip, isTracked: true, parentFromJointTransform: <translation=(-0.020009 0.000467 0.000366) rotation=(0.04° -0.26° 12.31°)>, anchorFromJointTransform: <translation=(-0.124110 -0.037036 -0.041876) rotation=(-2.10° -9.51° 74.82°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x3014856b0 name=handPinky_3_joint transform=<translation=(-0.124110 -0.037036 -0.041876) rotation=(-2.10° -9.51° 74.82°)> tracked=YES>
   ▿ 24 : HandSkeleton.Joint(name: littleFingerTip, isTracked: true, parentFromJointTransform: <translation=(-0.019876 0.000384 0.000307) rotation=(-0.00° 0.00° -0.00°)>, anchorFromJointTransform: <translation=(-0.129776 -0.056094 -0.041804) rotation=(-2.10° -9.51° 74.82°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301487060 name=handPinkyEnd_joint transform=<translation=(-0.129776 -0.056094 -0.041804) rotation=(-2.10° -9.51° 74.82°)> tracked=YES>
   ▿ 25 : HandSkeleton.Joint(name: forearmWrist, isTracked: true, parentFromJointTransform: <translation=(-0.000000 0.000000 0.000000) rotation=(-0.16° 172.83° 3.28°)>, anchorFromJointTransform: <translation=(-0.000000 0.000000 0.000000) rotation=(-0.16° 172.83° 3.28°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x301487000 name=forearmWrist_joint transform=<translation=(-0.000000 0.000000 0.000000) rotation=(-0.16° 172.83° 3.28°)> tracked=YES>
   ▿ 26 : HandSkeleton.Joint(name: forearmArm, isTracked: true, parentFromJointTransform: <translation=(-0.246855 0.003686 -0.005090) rotation=(0.00° -0.00° 0.00°)>, anchorFromJointTransform: <translation=(0.244102 -0.010479 0.035800) rotation=(-0.16° 172.83° 3.28°)>)
     - _cSkeletonJoint : <ar_skeleton_joint_t: 0x3014863d0 name=forearmArm_joint transform=<translation=(0.244102 -0.010479 0.035800) rotation=(-0.16° 172.83° 3.28°)> tracked=YES>
 */
