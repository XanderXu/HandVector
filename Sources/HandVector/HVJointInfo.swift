//
//  File.swift
//  
//
//  Created by 许同学 on 2024/6/5.
//

import ARKit


public struct HVJointInfo: Sendable, Equatable, HVJoint {
    public let name: HandSkeleton.JointName.NameCodingKey
    public let isTracked: Bool
    public let transform: simd_float4x4
    public let transformToParent: simd_float4x4
    
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

extension HVJointInfo: CustomStringConvertible {
    public var description: String {
        return "name: \(name), isTracked: \(isTracked), position: \(transform.columns.0.xyz)"
    }
    
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
/*
 po leftHandVector?.allJoints
▿ Optional<Dictionary<NameCodingKey, HVJointInfo>>
  ▿ some : 27 elements
    ▿ 0 : 2 elements
      - key : indexFingerIntermediateTip
      ▿ value : name: indexFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(0.9437773, -0.28323892, -0.17046884)
        - name : indexFingerIntermediateTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9437773, -0.28323892, -0.17046884, 0.0], [0.28342965, 0.95869917, -0.023736674, 0.0], [0.1701516, -0.02591371, 0.98507696, 0.0], [0.16453932, -0.012948287, -0.041481465, 0.99999994]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9437773, -0.28323892, -0.17046884, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.28342965, 0.95869917, -0.023736674, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.1701516, -0.02591371, 0.98507696, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.16453932, -0.012948287, -0.041481465, 0.99999994)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.997526, -0.070266485, -0.0020754123, 0.0], [0.07026607, 0.9975281, -0.00029661658, 0.0], [0.002091175, 0.0001501047, 0.9999977, 0.0], [0.024977043, 0.0002625086, -0.0005254643, 0.99999994]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.997526, -0.070266485, -0.0020754123, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.07026607, 0.9975281, -0.00029661658, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.002091175, 0.0001501047, 0.9999977, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.024977043, 0.0002625086, -0.0005254643, 0.99999994)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 1 : 2 elements
      - key : forearmArm
      ▿ value : name: forearmArm, isTracked: true, position: SIMD3<Float>(-0.9793838, -0.19232245, -0.06180325)
        - name : forearmArm
        - isTracked : true
        ▿ transform : simd_float4x4([[-0.9793838, -0.19232245, -0.06180325, 0.0], [-0.1923455, 0.9813113, -0.005634746, 0.0], [0.061731867, 0.0063689887, -0.9980726, 0.0], [-0.27473032, -0.055210702, -0.020651255, 0.99999994]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(-0.9793838, -0.19232245, -0.06180325, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.1923455, 0.9813113, -0.005634746, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.061731867, 0.0063689887, -0.9980726, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(-0.27473032, -0.055210702, -0.020651255, 0.99999994)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[1.0, -1.0546561e-08, 2.2037767e-09, 0.0], [2.5749628e-08, 1.0, 9.600292e-09, 0.0], [7.1820807e-09, -1.5840165e-09, 0.99999994, 0.0], [0.28096092, -0.0012194216, 0.00330019, 0.99999994]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(1.0, -1.0546561e-08, 2.2037767e-09, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(2.5749628e-08, 1.0, 9.600292e-09, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(7.1820807e-09, -1.5840165e-09, 0.99999994, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.28096092, -0.0012194216, 0.00330019, 0.99999994)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 2 : 2 elements
      - key : middleFingerTip
      ▿ value : name: middleFingerTip, isTracked: true, position: SIMD3<Float>(0.9544006, -0.2757961, 0.11426305)
        - name : middleFingerTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9544006, -0.2757961, 0.11426305, 0.0], [0.28848076, 0.9505144, -0.11533107, 0.0], [-0.07680079, 0.14303488, 0.98673344, 0.0], [0.1946311, -0.025190748, 0.00039377576, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9544006, -0.2757961, 0.11426305, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.28848076, 0.9505144, -0.11533107, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.07680079, 0.14303488, 0.98673344, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.1946311, -0.025190748, 0.00039377576, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.99999994, -1.1523367e-07, 2.2694326e-08, 0.0], [1.4445204e-07, 1.0, -1.682852e-07, 0.0], [-6.742457e-08, 2.247092e-07, 1.0000001, 0.0], [0.022734392, 0.0003713495, -0.0006283848, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.99999994, -1.1523367e-07, 2.2694326e-08, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(1.4445204e-07, 1.0, -1.682852e-07, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-6.742457e-08, 2.247092e-07, 1.0000001, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.022734392, 0.0003713495, -0.0006283848, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 3 : 2 elements
      - key : middleFingerMetacarpal
      ▿ value : name: middleFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.9999019, 0.004137184, 0.013375766)
        - name : middleFingerMetacarpal
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9999019, 0.004137184, 0.013375766, 0.0], [-0.004125836, 0.9999912, -0.0008716665, 0.0], [-0.013379162, 0.0008164466, 0.99991006, 0.0], [0.02868978, 0.00041365623, -0.005076617, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9999019, 0.004137184, 0.013375766, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.004125836, 0.9999912, -0.0008716665, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.013379162, 0.0008164466, 0.99991006, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.02868978, 0.00041365623, -0.005076617, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9999019, 0.004137184, 0.013375766, 0.0], [-0.004125836, 0.9999912, -0.0008716665, 0.0], [-0.013379162, 0.0008164466, 0.99991006, 0.0], [0.02868978, 0.00041365623, -0.005076617, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9999019, 0.004137184, 0.013375766, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.004125836, 0.9999912, -0.0008716665, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.013379162, 0.0008164466, 0.99991006, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.02868978, 0.00041365623, -0.005076617, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 4 : 2 elements
      - key : ringFingerIntermediateBase
      ▿ value : name: ringFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(0.9393184, -0.30967584, 0.14758468)
        - name : ringFingerIntermediateBase
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9393184, -0.30967584, 0.14758468, 0.0], [0.30667806, 0.9508306, 0.043236047, 0.0], [-0.15371716, 0.0046485933, 0.9881037, 0.0], [0.13349305, -0.010502159, 0.019241033, 0.9999999]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9393184, -0.30967584, 0.14758468, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.30667806, 0.9508306, 0.043236047, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.15371716, 0.0046485933, 0.9881037, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.13349305, -0.010502159, 0.019241033, 0.9999999)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.99961275, 0.02058082, -0.01871581, 0.0], [-0.020648595, 0.99978065, -0.003436583, 0.0], [0.01864094, 0.0038216491, 0.99981874, 0.0], [0.043059796, 0.00050732493, -0.0014663655, 0.9999999]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.99961275, 0.02058082, -0.01871581, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.020648595, 0.99978065, -0.003436583, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.01864094, 0.0038216491, 0.99981874, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.043059796, 0.00050732493, -0.0014663655, 0.9999999)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 5 : 2 elements
      - key : thumbIntermediateTip
      ▿ value : name: thumbIntermediateTip, isTracked: true, position: SIMD3<Float>(0.82956684, 0.026226308, -0.5577914)
        - name : thumbIntermediateTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.82956684, 0.026226308, -0.5577914, 0.0], [0.53801364, 0.22995247, 0.8109645, 0.0], [0.14953409, -0.9728486, 0.17665087, 0.0], [0.09379738, 0.020769179, -0.07158694, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.82956684, 0.026226308, -0.5577914, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.53801364, 0.22995247, 0.8109645, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.14953409, -0.9728486, 0.17665087, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.09379738, 0.020769179, -0.07158694, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.99360675, -0.11289158, -0.001082028, 0.0], [0.112892635, 0.9936066, 0.0010641529, 0.0], [0.0009548901, -0.0011794706, 0.99999887, 0.0], [0.0329745, -0.00024896208, -0.00021021115, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.99360675, -0.11289158, -0.001082028, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.112892635, 0.9936066, 0.0010641529, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.0009548901, -0.0011794706, 0.99999887, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.0329745, -0.00024896208, -0.00021021115, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 6 : 2 elements
      - key : littleFingerKnuckle
      ▿ value : name: littleFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.86830825, -0.3519857, 0.3494947)
        - name : littleFingerKnuckle
        - isTracked : true
        ▿ transform : simd_float4x4([[0.86830825, -0.3519857, 0.3494947, 0.0], [0.3520176, 0.9336804, 0.06575869, 0.0], [-0.34946242, 0.06592953, 0.9346278, 0.0], [0.08207557, 0.004765689, 0.03202882, 0.99999994]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.86830825, -0.3519857, 0.3494947, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.3520176, 0.9336804, 0.06575869, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.34946242, 0.06592953, 0.9346278, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.08207557, 0.004765689, 0.03202882, 0.99999994)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.91712916, -0.35577238, 0.17972268, 0.0], [0.3619169, 0.9322092, -0.0015038727, 0.0], [-0.16700402, 0.06642394, 0.98371625, 0.0], [0.05478066, 0.00068923365, -0.0019873772, 0.99999994]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.91712916, -0.35577238, 0.17972268, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.3619169, 0.9322092, -0.0015038727, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.16700402, 0.06642394, 0.98371625, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.05478066, 0.00068923365, -0.0019873772, 0.99999994)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 7 : 2 elements
      - key : littleFingerIntermediateBase
      ▿ value : name: littleFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(0.86988324, -0.35127044, 0.34628338)
        - name : littleFingerIntermediateBase
        - isTracked : true
        ▿ transform : simd_float4x4([[0.86988324, -0.35127044, 0.34628338, 0.0], [0.35113424, 0.93403685, 0.06541993, 0.0], [-0.34642136, 0.06468427, 0.9358461, 0.0], [0.111670256, -0.0066927066, 0.04253414, 0.99999994]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.86988324, -0.35127044, 0.34628338, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.35113424, 0.93403685, 0.06541993, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.34642136, 0.06468427, 0.9358461, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.111670256, -0.0066927066, 0.04253414, 0.99999994)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.99999344, 0.0010110303, -0.0035046164, 0.0], [-0.001010892, 0.9999995, 1.5586988e-05, 0.0], [0.0035046735, -1.2065937e-05, 0.99999386, 0.0], [0.03340206, 0.0004101855, -0.0012791182, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.99999344, 0.0010110303, -0.0035046164, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.001010892, 0.9999995, 1.5586988e-05, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.0035046735, -1.2065937e-05, 0.99999386, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.03340206, 0.0004101855, -0.0012791182, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 8 : 2 elements
      - key : ringFingerKnuckle
      ▿ value : name: ringFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.9297572, -0.32910272, 0.16505407)
        - name : ringFingerKnuckle
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9297572, -0.32910272, 0.16505407, 0.0], [0.32535535, 0.9442669, 0.05004024, 0.0], [-0.17232333, 0.007176021, 0.9850142, 0.0], [0.09304015, 0.0032004118, 0.0135528445, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9297572, -0.32910272, 0.16505407, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.32535535, 0.9442669, 0.05004024, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.17232333, 0.007176021, 0.9850142, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.09304015, 0.0032004118, 0.0135528445, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.94107974, -0.3332336, 0.057655808, 0.0], [0.33305326, 0.94281846, 0.01299321, 0.0], [-0.058688655, 0.006974833, 0.9982519, 0.0], [0.06435959, 0.000790386, -0.002092002, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.94107974, -0.3332336, 0.057655808, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.33305326, 0.94281846, 0.01299321, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.058688655, 0.006974833, 0.9982519, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.06435959, 0.000790386, -0.002092002, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 9 : 2 elements
      - key : littleFingerTip
      ▿ value : name: littleFingerTip, isTracked: true, position: SIMD3<Float>(0.8842168, -0.3119706, 0.3476127)
        - name : littleFingerTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.8842168, -0.3119706, 0.3476127, 0.0], [0.31417438, 0.9479616, 0.05160327, 0.0], [-0.34562224, 0.0635826, 0.93621683, 0.0], [0.14600551, -0.019034425, 0.05451535, 0.9999999]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.8842168, -0.3119706, 0.3476127, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.31417438, 0.9479616, 0.05160327, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.34562224, 0.0635826, 0.93621683, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.14600551, -0.019034425, 0.05451535, 0.9999999)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9999998, 8.596804e-08, -2.0625711e-07, 0.0], [-6.630275e-08, 0.9999999, -1.7337014e-07, 0.0], [1.7169697e-07, 1.75131e-07, 0.9999999, 0.0], [0.019801458, 0.00025682067, -0.0007507805, 0.99999994]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9999998, 8.596804e-08, -2.0625711e-07, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-6.630275e-08, 0.9999999, -1.7337014e-07, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(1.7169697e-07, 1.75131e-07, 0.9999999, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.019801458, 0.00025682067, -0.0007507805, 0.99999994)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 10 : 2 elements
      - key : indexFingerKnuckle
      ▿ value : name: indexFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.9621471, -0.21506725, -0.16738775)
        - name : indexFingerKnuckle
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9621471, -0.21506725, -0.16738775, 0.0], [0.21621995, 0.9762768, -0.011528332, 0.0], [0.16589613, -0.025100552, 0.9858238, 0.0], [0.09780341, 0.0012386292, -0.028335394, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9621471, -0.21506725, -0.16738775, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.21621995, 0.9762768, -0.011528332, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.16589613, -0.025100552, 0.9858238, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.09780341, 0.0012386292, -0.028335394, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9744781, -0.21812117, -0.053061467, 0.0], [0.2191953, 0.97556156, 0.015272708, 0.0], [0.04843335, -0.02651371, 0.9984745, 0.0], [0.071871296, 0.00075668114, -0.0016166726, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9744781, -0.21812117, -0.053061467, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.2191953, 0.97556156, 0.015272708, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.04843335, -0.02651371, 0.9984745, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.071871296, 0.00075668114, -0.0016166726, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 11 : 2 elements
      - key : thumbIntermediateBase
      ▿ value : name: thumbIntermediateBase, isTracked: true, position: SIMD3<Float>(0.8851438, 0.05108954, -0.46250466)
        - name : thumbIntermediateBase
        - isTracked : true
        ▿ transform : simd_float4x4([[0.8851438, 0.05108954, -0.46250466, 0.0], [0.4407465, 0.22666904, 0.86854124, 0.0], [0.14920889, -0.97263116, 0.17811713, 0.0], [0.06475129, 0.0189365, -0.0560824, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.8851438, 0.05108954, -0.46250466, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.4407465, 0.22666904, 0.86854124, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.14920889, -0.97263116, 0.17811713, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.06475129, 0.0189365, -0.0560824, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.96785784, 0.2173182, 0.12658744, 0.0], [-0.21751747, 0.97597754, -0.012415861, 0.0], [-0.12624465, -0.015518162, 0.99187785, 0.0], [0.05383118, -0.00013206899, -0.00011826353, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.96785784, 0.2173182, 0.12658744, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.21751747, 0.97597754, -0.012415861, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.12624465, -0.015518162, 0.99187785, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.05383118, -0.00013206899, -0.00011826353, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 12 : 2 elements
      - key : thumbKnuckle
      ▿ value : name: thumbKnuckle, isTracked: true, position: SIMD3<Float>(0.74198616, 0.12293238, -0.6590478)
        - name : thumbKnuckle
        - isTracked : true
        ▿ transform : simd_float4x4([[0.74198616, 0.12293238, -0.6590478, 0.0], [0.62020093, 0.24742001, 0.74440193, 0.0], [0.25457272, -0.9610781, 0.10733945, 0.0], [0.024921319, 0.012237921, -0.020494074, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.74198616, 0.12293238, -0.6590478, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.62020093, 0.24742001, 0.74440193, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.25457272, -0.9610781, 0.10733945, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.024921319, 0.012237921, -0.020494074, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.74198616, 0.12293238, -0.6590478, 0.0], [0.62020093, 0.24742001, 0.74440193, 0.0], [0.25457272, -0.9610781, 0.10733945, 0.0], [0.024921319, 0.012237921, -0.020494074, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.74198616, 0.12293238, -0.6590478, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.62020093, 0.24742001, 0.74440193, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.25457272, -0.9610781, 0.10733945, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.024921319, 0.012237921, -0.020494074, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 13 : 2 elements
      - key : thumbTip
      ▿ value : name: thumbTip, isTracked: true, position: SIMD3<Float>(0.82956684, 0.026226439, -0.55779135)
        - name : thumbTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.82956684, 0.026226439, -0.55779135, 0.0], [0.5380134, 0.2299526, 0.8109645, 0.0], [0.14953424, -0.9728485, 0.1766509, 0.0], [0.11866458, 0.021661952, -0.08852217, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.82956684, 0.026226439, -0.55779135, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.5380134, 0.2299526, 0.8109645, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.14953424, -0.9728485, 0.1766509, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.11866458, 0.021661952, -0.08852217, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[1.0, 1.4183544e-07, -1.0343187e-07, 0.0], [-1.5622213e-07, 0.99999994, -1.5976264e-07, 0.0], [1.3250241e-07, 1.5413548e-07, 0.9999999, 0.0], [0.030098747, -0.00014968682, -0.00014166288, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(1.0, 1.4183544e-07, -1.0343187e-07, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-1.5622213e-07, 0.99999994, -1.5976264e-07, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(1.3250241e-07, 1.5413548e-07, 0.9999999, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.030098747, -0.00014968682, -0.00014166288, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 14 : 2 elements
      - key : ringFingerIntermediateTip
      ▿ value : name: ringFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(0.92462844, -0.35309792, 0.14277373)
        - name : ringFingerIntermediateTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.92462844, -0.35309792, 0.14277373, 0.0], [0.34961373, 0.9355777, 0.049643848, 0.0], [-0.15110497, 0.0040135384, 0.9885097, 0.0], [0.15912329, -0.01857069, 0.022349237, 0.9999999]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.92462844, -0.35309792, 0.14277373, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.34961373, 0.9355777, 0.049643848, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.15110497, 0.0040135384, 0.9885097, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.15912329, -0.01857069, 0.022349237, 0.9999999)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.99893814, -0.04600021, -0.0026974704, 0.0], [0.04599948, 0.9989416, -0.00033929327, 0.0], [0.0027102628, 0.00021482694, 0.99999666, 0.0], [0.027032329, 0.0003228099, -0.0009060883, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.99893814, -0.04600021, -0.0026974704, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.04599948, 0.9989416, -0.00033929327, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.0027102628, 0.00021482694, 0.99999666, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.027032329, 0.0003228099, -0.0009060883, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 15 : 2 elements
      - key : indexFingerTip
      ▿ value : name: indexFingerTip, isTracked: true, position: SIMD3<Float>(0.9437773, -0.28323886, -0.17046876)
        - name : indexFingerTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9437773, -0.28323886, -0.17046876, 0.0], [0.28342956, 0.95869917, -0.02373666, 0.0], [0.17015156, -0.025913753, 0.98507696, 0.0], [0.18567984, -0.019063339, -0.04577002, 0.9999999]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9437773, -0.28323886, -0.17046876, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.28342956, 0.95869917, -0.02373666, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.17015156, -0.025913753, 0.98507696, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.18567984, -0.019063339, -0.04577002, 0.9999999)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.99999994, 3.7133088e-08, 5.5894233e-08, 0.0], [-1.089252e-07, 1.0, -2.3965796e-09, 0.0], [-1.8924151e-08, -5.0824138e-08, 1.0, 0.0], [0.02241505, 0.00023115578, -0.00046900148, 0.99999994]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.99999994, 3.7133088e-08, 5.5894233e-08, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-1.089252e-07, 1.0, -2.3965796e-09, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-1.8924151e-08, -5.0824138e-08, 1.0, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.02241505, 0.00023115578, -0.00046900148, 0.99999994)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 16 : 2 elements
      - key : ringFingerMetacarpal
      ▿ value : name: ringFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.9934498, 0.004358054, 0.11418588)
        - name : ringFingerMetacarpal
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9934498, 0.004358054, 0.11418588, 0.0], [-0.0042772475, 0.99999046, -0.00095241837, 0.0], [-0.11418888, 0.0004578231, 0.9934589, 0.0], [0.028866637, 0.0021305084, 0.008282959, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9934498, 0.004358054, 0.11418588, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.0042772475, 0.99999046, -0.00095241837, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.11418888, 0.0004578231, 0.9934589, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.028866637, 0.0021305084, 0.008282959, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9934498, 0.004358054, 0.11418588, 0.0], [-0.0042772475, 0.99999046, -0.00095241837, 0.0], [-0.11418888, 0.0004578231, 0.9934589, 0.0], [0.028866637, 0.0021305084, 0.008282959, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9934498, 0.004358054, 0.11418588, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.0042772475, 0.99999046, -0.00095241837, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.11418888, 0.0004578231, 0.9934589, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.028866637, 0.0021305084, 0.008282959, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 17 : 2 elements
      - key : middleFingerKnuckle
      ▿ value : name: middleFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.95225847, -0.29553384, 0.07657215)
        - name : middleFingerKnuckle
        - isTracked : true
        ▿ transform : simd_float4x4([[0.95225847, -0.29553384, 0.07657215, 0.0], [0.30306315, 0.945344, -0.12032269, 0.0], [-0.036827568, 0.13778457, 0.98977727, 0.0], [0.096492104, 0.0014854817, -0.00607422, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.95225847, -0.29553384, 0.07657215, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.30306315, 0.945344, -0.12032269, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.036827568, 0.13778457, 0.98977727, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.096492104, 0.0014854817, -0.00607422, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.95196676, -0.29952687, 0.06358349, 0.0], [0.3053351, 0.94418997, -0.12359488, 0.0], [-0.023014987, 0.13707247, 0.9902937, 0.0], [0.067786776, 0.00079294055, -0.0019037831, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.95196676, -0.29952687, 0.06358349, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.3053351, 0.94418997, -0.12359488, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.023014987, 0.13707247, 0.9902937, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.067786776, 0.00079294055, -0.0019037831, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 18 : 2 elements
      - key : wrist
      ▿ value : name: wrist, isTracked: true, position: SIMD3<Float>(1.0, 0.0, 0.0)
        - name : wrist
        - isTracked : true
        ▿ transform : simd_float4x4([[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 0.0, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(1.0, 0.0, 0.0, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.0, 1.0, 0.0, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.0, 0.0, 1.0, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.0, 0.0, 0.0, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 0.0, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(1.0, 0.0, 0.0, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.0, 1.0, 0.0, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.0, 0.0, 1.0, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.0, 0.0, 0.0, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 19 : 2 elements
      - key : forearmWrist
      ▿ value : name: forearmWrist, isTracked: true, position: SIMD3<Float>(-0.9793838, -0.19232243, -0.061803248)
        - name : forearmWrist
        - isTracked : true
        ▿ transform : simd_float4x4([[-0.9793838, -0.19232243, -0.061803248, 0.0], [-0.19234547, 0.9813113, -0.005634735, 0.0], [0.06173188, 0.006368992, -0.9980727, 0.0], [-1.8626451e-08, 0.0, 0.0, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(-0.9793838, -0.19232243, -0.061803248, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.19234547, 0.9813113, -0.005634735, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.06173188, 0.006368992, -0.9980727, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(-1.8626451e-08, 0.0, 0.0, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[-0.9793838, -0.19232243, -0.061803248, 0.0], [-0.19234547, 0.9813113, -0.005634735, 0.0], [0.06173188, 0.006368992, -0.9980727, 0.0], [-1.8626451e-08, 0.0, 0.0, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(-0.9793838, -0.19232243, -0.061803248, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.19234547, 0.9813113, -0.005634735, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.06173188, 0.006368992, -0.9980727, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(-1.8626451e-08, 0.0, 0.0, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 20 : 2 elements
      - key : middleFingerIntermediateTip
      ▿ value : name: middleFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(0.95440066, -0.275796, 0.11426302)
        - name : middleFingerIntermediateTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.95440066, -0.275796, 0.11426302, 0.0], [0.2884806, 0.9505145, -0.11533091, 0.0], [-0.07680078, 0.14303462, 0.9867334, 0.0], [0.17277801, -0.019183785, -0.001541048, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.95440066, -0.275796, 0.11426302, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.2884806, 0.9505145, -0.11533091, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.07680078, 0.14303462, 0.9867334, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.17277801, -0.019183785, -0.001541048, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9989914, -0.04464405, 0.004824169, 0.0], [0.044642586, 0.99900293, 0.00039778417, 0.0], [-0.0048370953, -0.0001820368, 0.9999884, 0.0], [0.028966822, 0.00048707123, -0.0008007891, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9989914, -0.04464405, 0.004824169, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.044642586, 0.99900293, 0.00039778417, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.0048370953, -0.0001820368, 0.9999884, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.028966822, 0.00048707123, -0.0008007891, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 21 : 2 elements
      - key : indexFingerIntermediateBase
      ▿ value : name: indexFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(0.96171397, -0.21522841, -0.1696551)
        - name : indexFingerIntermediateBase
        - isTracked : true
        ▿ transform : simd_float4x4([[0.96171397, -0.21522841, -0.1696551, 0.0], [0.2164387, 0.976228, -0.011551934, 0.0], [0.16810839, -0.025610223, 0.9854357, 0.0], [0.14055008, -0.007842243, -0.036723137, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.96171397, -0.21522841, -0.1696551, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.2164387, 0.976228, -0.011551934, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.16810839, -0.025610223, 0.9854357, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.14055008, -0.007842243, -0.036723137, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9999973, -0.00022487034, -0.0023030275, 0.0], [0.00022493217, 0.9999999, 1.4247686e-05, 0.0], [0.0023030813, -1.4775955e-05, 0.99999726, 0.0], [0.0444856, 0.00047393702, -0.0009493954, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9999973, -0.00022487034, -0.0023030275, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.00022493217, 0.9999999, 1.4247686e-05, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.0023030813, -1.4775955e-05, 0.99999726, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.0444856, 0.00047393702, -0.0009493954, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 22 : 2 elements
      - key : middleFingerIntermediateBase
      ▿ value : name: middleFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(0.9666879, -0.23377615, 0.10422613)
        - name : middleFingerIntermediateBase
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9666879, -0.23377615, 0.10422613, 0.0], [0.2455987, 0.9618534, -0.12049669, 0.0], [-0.072080955, 0.14208056, 0.987227, 0.0], [0.14459878, -0.012766749, -0.0037108965, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9666879, -0.23377615, 0.10422613, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.2455987, 0.9618534, -0.12049669, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.072080955, 0.14208056, 0.987227, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.14459878, -0.012766749, -0.0037108965, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9976066, 0.059427883, 0.03534914, 0.0], [-0.059613463, 0.99821264, 0.0042188014, 0.0], [-0.035035234, -0.0063159605, 0.99936604, 0.0], [0.05020298, 0.0008217413, -0.0013962255, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9976066, 0.059427883, 0.03534914, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.059613463, 0.99821264, 0.0042188014, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.035035234, -0.0063159605, 0.99936604, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.05020298, 0.0008217413, -0.0013962255, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 23 : 2 elements
      - key : ringFingerTip
      ▿ value : name: ringFingerTip, isTracked: true, position: SIMD3<Float>(0.92462844, -0.35309792, 0.14277379)
        - name : ringFingerTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.92462844, -0.35309792, 0.14277379, 0.0], [0.34961367, 0.93557775, 0.04964362, 0.0], [-0.15110494, 0.0040138154, 0.9885096, 0.0], [0.17977178, -0.026149945, 0.02479249, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.92462844, -0.35309792, 0.14277379, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.34961367, 0.93557775, 0.04964362, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.15110494, 0.0040138154, 0.9885096, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.17977178, -0.026149945, 0.02479249, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[1.0000001, 5.4147684e-08, 5.9666576e-08, 0.0], [-5.2933366e-08, 1.0, -2.1939671e-07, 0.0], [-8.667279e-08, 2.6353504e-07, 0.9999999, 0.0], [0.022117203, 0.00024929654, -0.00073533034, 1.0000001]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(1.0000001, 5.4147684e-08, 5.9666576e-08, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-5.2933366e-08, 1.0, -2.1939671e-07, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-8.667279e-08, 2.6353504e-07, 0.9999999, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.022117203, 0.00024929654, -0.00073533034, 1.0000001)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 24 : 2 elements
      - key : littleFingerIntermediateTip
      ▿ value : name: littleFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(0.88421685, -0.31197074, 0.34761298)
        - name : littleFingerIntermediateTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.88421685, -0.31197074, 0.34761298, 0.0], [0.3141744, 0.94796175, 0.05160346, 0.0], [-0.3456225, 0.06358249, 0.93621695, 0.0], [0.12815657, -0.01305267, 0.04832175, 0.99999994]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.88421685, -0.31197074, 0.34761298, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.3141744, 0.94796175, 0.05160346, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.3456225, 0.06358249, 0.93621695, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.12815657, -0.01305267, 0.04832175, 0.99999994)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9991241, 0.0418274, -0.0011791257, 0.0], [-0.04182657, 0.9991246, 0.0007743233, 0.0], [0.0012103679, -0.00072432664, 0.999999, 0.0], [0.018579394, 0.00022709504, -0.0007062919, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9991241, 0.0418274, -0.0011791257, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.04182657, 0.9991246, 0.0007743233, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.0012103679, -0.00072432664, 0.999999, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.018579394, 0.00022709504, -0.0007062919, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 25 : 2 elements
      - key : indexFingerMetacarpal
      ▿ value : name: indexFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.9930207, 0.0032011885, -0.11789585)
        - name : indexFingerMetacarpal
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9930207, 0.0032011885, -0.11789585, 0.0], [-0.0033273883, 0.99999416, -0.0008736555, 0.0], [0.117892444, 0.0012598826, 0.9930256, 0.0], [0.02662683, 0.0002539158, -0.018256009, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9930207, 0.0032011885, -0.11789585, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.0033273883, 0.99999416, -0.0008736555, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.117892444, 0.0012598826, 0.9930256, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.02662683, 0.0002539158, -0.018256009, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9930207, 0.0032011885, -0.11789585, 0.0], [-0.0033273883, 0.99999416, -0.0008736555, 0.0], [0.117892444, 0.0012598826, 0.9930256, 0.0], [0.02662683, 0.0002539158, -0.018256009, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9930207, 0.0032011885, -0.11789585, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.0033273883, 0.99999416, -0.0008736555, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.117892444, 0.0012598826, 0.9930256, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.02662683, 0.0002539158, -0.018256009, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 26 : 2 elements
      - key : littleFingerMetacarpal
      ▿ value : name: littleFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.98211354, 0.00408792, 0.1882443)
        - name : littleFingerMetacarpal
        - isTracked : true
        ▿ transform : simd_float4x4([[0.98211354, 0.00408792, 0.1882443, 0.0], [-0.003978666, 0.9999915, -0.0009580654, 0.0], [-0.1882466, 0.00019198694, 0.9821216, 0.0], [0.027903374, 0.0038529038, 0.023669183, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.98211354, 0.00408792, 0.1882443, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.003978666, 0.9999915, -0.0009580654, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.1882466, 0.00019198694, 0.9821216, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.027903374, 0.0038529038, 0.023669183, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.98211354, 0.00408792, 0.1882443, 0.0], [-0.003978666, 0.9999915, -0.0009580654, 0.0], [-0.1882466, 0.00019198694, 0.9821216, 0.0], [0.027903374, 0.0038529038, 0.023669183, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.98211354, 0.00408792, 0.1882443, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.003978666, 0.9999915, -0.0009580654, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.1882466, 0.00019198694, 0.9821216, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.027903374, 0.0038529038, 0.023669183, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
 
 
 
 
 
 po rightHandVector?.allJoints
 ▿ Optional<Dictionary<NameCodingKey, HVJointInfo>>
   ▿ some : 27 elements
     ▿ 0 : 2 elements
       - key : thumbIntermediateBase
       ▿ value : name: thumbIntermediateBase, isTracked: true, position: SIMD3<Float>(0.9551221, 0.26733106, -0.12757693)
         - name : thumbIntermediateBase
         - isTracked : true
         ▿ transform : simd_float4x4([[0.9551221, 0.26733106, -0.12757693, 0.0], [0.108472675, 0.08511461, 0.990449, 0.0], [0.27563652, -0.9598384, 0.05229679, 0.0], [-0.06460369, -0.027484711, 0.047795326, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9551221, 0.26733106, -0.12757693, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.108472675, 0.08511461, 0.990449, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.27563652, -0.9598384, 0.05229679, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.06460369, -0.027484711, 0.047795326, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.89901257, 0.42860636, 0.08985128, 0.0], [-0.4274498, 0.9034467, -0.0327242, 0.0], [-0.09520164, -0.008987405, 0.99541754, 0.0], [-0.052300423, -0.00010370707, 0.0004065157, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.89901257, 0.42860636, 0.08985128, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.4274498, 0.9034467, -0.0327242, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.09520164, -0.008987405, 0.99541754, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.052300423, -0.00010370707, 0.0004065157, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 1 : 2 elements
       - key : wrist
       ▿ value : name: wrist, isTracked: true, position: SIMD3<Float>(1.0, 0.0, 0.0)
         - name : wrist
         - isTracked : true
         ▿ transform : simd_float4x4([[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 0.0, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(1.0, 0.0, 0.0, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.0, 1.0, 0.0, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.0, 0.0, 1.0, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(0.0, 0.0, 0.0, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[1.0, 0.0, 0.0, 0.0], [0.0, 1.0, 0.0, 0.0], [0.0, 0.0, 1.0, 0.0], [0.0, 0.0, 0.0, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(1.0, 0.0, 0.0, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.0, 1.0, 0.0, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.0, 0.0, 1.0, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(0.0, 0.0, 0.0, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 2 : 2 elements
       - key : ringFingerKnuckle
       ▿ value : name: ringFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.965595, 0.25179955, 0.06498808)
         - name : ringFingerKnuckle
         - isTracked : true
         ▿ transform : simd_float4x4([[0.965595, 0.25179955, 0.06498808, 0.0], [-0.25305957, 0.96737874, 0.0118087465, 0.0], [-0.059894633, -0.027848354, 0.9978164, 0.0], [-0.08838473, -0.0035463572, -0.017858386, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.965595, 0.25179955, 0.06498808, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.25305957, 0.96737874, 0.0118087465, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.059894633, -0.027848354, 0.9978164, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.08838473, -0.0035463572, -0.017858386, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9659541, 0.24552032, -0.08156302, 0.0], [-0.24172583, 0.9688586, 0.053681474, 0.0], [0.092202865, -0.032137953, 0.9952215, 0.0], [-0.06194784, -0.0011985988, 7.7860175e-05, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9659541, 0.24552032, -0.08156302, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.24172583, 0.9688586, 0.053681474, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.092202865, -0.032137953, 0.9952215, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.06194784, -0.0011985988, 7.7860175e-05, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 3 : 2 elements
       - key : middleFingerIntermediateBase
       ▿ value : name: middleFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(0.28791934, 0.957638, 0.0056601735)
         - name : middleFingerIntermediateBase
         - isTracked : true
         ▿ transform : simd_float4x4([[0.28791934, 0.957638, 0.0056601735, 0.0], [-0.944845, 0.2850267, -0.1613314, 0.0], [-0.15611018, 0.04110246, 0.9868841, 0.0], [-0.13487542, -0.02254409, 0.00028705504, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.28791934, 0.957638, 0.0056601735, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.944845, 0.2850267, -0.1613314, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.15611018, 0.04110246, 0.9868841, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.13487542, -0.02254409, 0.00028705504, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.6687186, 0.74273473, 0.03407258, 0.0], [-0.74210435, 0.66957027, -0.030936886, 0.0], [-0.045791842, -0.0045973263, 0.99894047, 0.0], [-0.047479335, -0.0002781246, 9.389315e-05, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.6687186, 0.74273473, 0.03407258, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.74210435, 0.66957027, -0.030936886, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.045791842, -0.0045973263, 0.99894047, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.047479335, -0.0002781246, 9.389315e-05, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 4 : 2 elements
       - key : forearmWrist
       ▿ value : name: forearmWrist, isTracked: true, position: SIMD3<Float>(-0.95315003, -0.19649035, -0.22999229)
         - name : forearmWrist
         - isTracked : true
         ▿ transform : simd_float4x4([[-0.95315003, -0.19649035, -0.22999229, 0.0], [-0.2010872, 0.97956705, -0.0035186128, 0.0], [0.22598417, 0.042894676, -0.9731862, 0.0], [2.9802322e-08, -5.9604645e-08, -5.9604645e-08, 1.0000001]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(-0.95315003, -0.19649035, -0.22999229, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.2010872, 0.97956705, -0.0035186128, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.22598417, 0.042894676, -0.9731862, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(2.9802322e-08, -5.9604645e-08, -5.9604645e-08, 1.0000001)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[-0.95315003, -0.19649035, -0.22999229, 0.0], [-0.2010872, 0.97956705, -0.0035186128, 0.0], [0.22598417, 0.042894676, -0.9731862, 0.0], [2.9802322e-08, -5.9604645e-08, -5.9604645e-08, 1.0000001]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(-0.95315003, -0.19649035, -0.22999229, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.2010872, 0.97956705, -0.0035186128, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.22598417, 0.042894676, -0.9731862, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(2.9802322e-08, -5.9604645e-08, -5.9604645e-08, 1.0000001)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 5 : 2 elements
       - key : middleFingerMetacarpal
       ▿ value : name: middleFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.99994355, 0.006307183, 0.008541583)
         - name : middleFingerMetacarpal
         - isTracked : true
         ▿ transform : simd_float4x4([[0.99994355, 0.006307183, 0.008541583, 0.0], [-0.006282171, 0.999976, -0.002953696, 0.0], [-0.008559984, 0.0028998696, 0.99995923, 0.0], [-0.027025372, -0.00035363436, 0.0044017434, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.99994355, 0.006307183, 0.008541583, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.006282171, 0.999976, -0.002953696, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.008559984, 0.0028998696, 0.99995923, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.027025372, -0.00035363436, 0.0044017434, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.99994355, 0.006307183, 0.008541583, 0.0], [-0.006282171, 0.999976, -0.002953696, 0.0], [-0.008559984, 0.0028998696, 0.99995923, 0.0], [-0.027025372, -0.00035363436, 0.0044017434, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.99994355, 0.006307183, 0.008541583, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.006282171, 0.999976, -0.002953696, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.008559984, 0.0028998696, 0.99995923, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.027025372, -0.00035363436, 0.0044017434, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 6 : 2 elements
       - key : thumbIntermediateTip
       ▿ value : name: thumbIntermediateTip, isTracked: true, position: SIMD3<Float>(0.9175701, 0.2476308, -0.31103694)
         - name : thumbIntermediateTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.9175701, 0.2476308, -0.31103694, 0.0], [0.2861255, 0.1318768, 0.94907355, 0.0], [0.2760385, -0.9598372, 0.050152756, 0.0], [-0.09510591, -0.03654265, 0.051874768, 0.9999998]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9175701, 0.2476308, -0.31103694, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.2861255, 0.1318768, 0.94907355, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.2760385, -0.9598372, 0.050152756, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.09510591, -0.03654265, 0.051874768, 0.9999998)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.982272, -0.18745787, -0.001035987, 0.0], [0.18745963, 0.98227036, 0.0019196596, 0.0], [0.00065778143, -0.0020798533, 0.9999975, 0.0], [-0.032075252, -3.913471e-05, 0.0004999767, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.982272, -0.18745787, -0.001035987, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.18745963, 0.98227036, 0.0019196596, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.00065778143, -0.0020798533, 0.9999975, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.032075252, -3.913471e-05, 0.0004999767, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 7 : 2 elements
       - key : littleFingerIntermediateTip
       ▿ value : name: littleFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(0.52908444, 0.8434113, 0.09342008)
         - name : littleFingerIntermediateTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.52908444, 0.8434113, 0.09342008, 0.0], [-0.82714057, 0.5371734, -0.16517623, 0.0], [-0.18949413, 0.010120631, 0.98182976, 0.0], [-0.1261572, -0.025110604, -0.045852903, 0.9999998]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.52908444, 0.8434113, 0.09342008, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.82714057, 0.5371734, -0.16517623, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.18949413, 0.010120631, 0.98182976, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.1261572, -0.025110604, -0.045852903, 0.9999998)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.976469, 0.21565759, -0.00034016912, 0.0], [-0.21565667, 0.9764676, 0.0017625095, 0.0], [0.0007123029, -0.0016476328, 0.9999984, 0.0], [-0.020007083, -1.0733215e-05, 6.3891086e-05, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.976469, 0.21565759, -0.00034016912, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.21565667, 0.9764676, 0.0017625095, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.0007123029, -0.0016476328, 0.9999984, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.020007083, -1.0733215e-05, 6.3891086e-05, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 8 : 2 elements
       - key : middleFingerIntermediateTip
       ▿ value : name: middleFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(0.07532944, 0.9970219, -0.016532185)
         - name : middleFingerIntermediateTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.07532944, 0.9970219, -0.016532185, 0.0], [-0.9843907, 0.07171003, -0.16072728, 0.0], [-0.15906294, 0.028381554, 0.98686063, 0.0], [-0.14343598, -0.050567582, 7.513119e-05, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.07532944, 0.9970219, -0.016532185, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.9843907, 0.07171003, -0.16072728, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.15906294, 0.028381554, 0.98686063, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.14343598, -0.050567582, 7.513119e-05, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.97638106, 0.21567023, 0.012904971, 0.0], [-0.21566263, 0.9764661, -0.0019981633, 0.0], [-0.0130323125, -0.0008321083, 0.9999149, 0.0], [-0.029302314, 0.00013515726, -2.4585752e-05, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.97638106, 0.21567023, 0.012904971, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.21566263, 0.9764661, -0.0019981633, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.0130323125, -0.0008321083, 0.9999149, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.029302314, 0.00013515726, -2.4585752e-05, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 9 : 2 elements
       - key : littleFingerTip
       ▿ value : name: littleFingerTip, isTracked: true, position: SIMD3<Float>(0.52908444, 0.84341127, 0.09342003)
         - name : littleFingerTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.52908444, 0.84341127, 0.09342003, 0.0], [-0.8271407, 0.5371735, -0.16517614, 0.0], [-0.18949407, 0.010120602, 0.9818299, 0.0], [-0.13664839, -0.041781295, -0.047706123, 0.99999976]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.52908444, 0.84341127, 0.09342003, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.8271407, 0.5371735, -0.16517614, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.18949407, 0.010120602, 0.9818299, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.13664839, -0.041781295, -0.047706123, 0.99999976)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.99999994, 3.748599e-09, -5.5631684e-08, 0.0], [5.9574468e-08, 1.0000001, 1.06837966e-07, 0.0], [1.45438355e-08, -8.086875e-08, 1.0000001, 0.0], [-0.01978411, 2.8758775e-05, -2.4531255e-07, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.99999994, 3.748599e-09, -5.5631684e-08, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(5.9574468e-08, 1.0000001, 1.06837966e-07, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(1.45438355e-08, -8.086875e-08, 1.0000001, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.01978411, 2.8758775e-05, -2.4531255e-07, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 10 : 2 elements
       - key : thumbTip
       ▿ value : name: thumbTip, isTracked: true, position: SIMD3<Float>(0.91757035, 0.24763083, -0.31103706)
         - name : thumbTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.91757035, 0.24763083, -0.31103706, 0.0], [0.28612554, 0.13187677, 0.9490737, 0.0], [0.27603847, -0.9598373, 0.05015268, 0.0], [-0.12247299, -0.044362303, 0.061114654, 0.9999998]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.91757035, 0.24763083, -0.31103706, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.28612554, 0.13187677, 0.9490737, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.27603847, -0.9598373, 0.05015268, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.12247299, -0.044362303, 0.061114654, 0.9999998)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[1.0000002, -6.2919995e-08, 4.4605148e-08, 0.0], [7.445164e-09, 1.0000001, 3.8609183e-08, 0.0], [-2.7044791e-08, -9.060978e-08, 1.0000001, 0.0], [-0.029921552, -9.2314454e-05, 0.00041463517, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(1.0000002, -6.2919995e-08, 4.4605148e-08, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(7.445164e-09, 1.0000001, 3.8609183e-08, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-2.7044791e-08, -9.060978e-08, 1.0000001, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.029921552, -9.2314454e-05, 0.00041463517, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 11 : 2 elements
       - key : littleFingerMetacarpal
       ▿ value : name: littleFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.9668527, 0.007070238, 0.25523654)
         - name : littleFingerMetacarpal
         - isTracked : true
         ▿ transform : simd_float4x4([[0.9668527, 0.007070238, 0.25523654, 0.0], [-0.005767264, 0.99996626, -0.0058531724, 0.0], [-0.25526914, 0.004187159, 0.96686107, 0.0], [-0.026197642, -0.0035199523, -0.023431093, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9668527, 0.007070238, 0.25523654, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.005767264, 0.99996626, -0.0058531724, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.25526914, 0.004187159, 0.96686107, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.026197642, -0.0035199523, -0.023431093, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9668527, 0.007070238, 0.25523654, 0.0], [-0.005767264, 0.99996626, -0.0058531724, 0.0], [-0.25526914, 0.004187159, 0.96686107, 0.0], [-0.026197642, -0.0035199523, -0.023431093, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9668527, 0.007070238, 0.25523654, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.005767264, 0.99996626, -0.0058531724, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.25526914, 0.004187159, 0.96686107, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.026197642, -0.0035199523, -0.023431093, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 12 : 2 elements
       - key : ringFingerIntermediateTip
       ▿ value : name: ringFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(0.12543124, 0.9916279, 0.030681966)
         - name : ringFingerIntermediateTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.12543124, 0.9916279, 0.030681966, 0.0], [-0.990701, 0.12683731, -0.049234755, 0.0], [-0.05271401, -0.02422107, 0.99831605, 0.0], [-0.13954498, -0.039928824, -0.021547738, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.12543124, 0.9916279, 0.030681966, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.990701, 0.12683731, -0.049234755, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.05271401, -0.02422107, 0.99831605, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.13954498, -0.039928824, -0.021547738, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9693007, 0.24586874, 0.0023125056, 0.0], [-0.24586985, 0.969303, 0.00015719469, 0.0], [-0.0022027597, -0.0007210702, 0.99999744, 0.0], [-0.027309041, 8.2898885e-05, -4.435492e-05, 1.0000001]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9693007, 0.24586874, 0.0023125056, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.24586985, 0.969303, 0.00015719469, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.0022027597, -0.0007210702, 0.99999744, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.027309041, 8.2898885e-05, -4.435492e-05, 1.0000001)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 13 : 2 elements
       - key : forearmArm
       ▿ value : name: forearmArm, isTracked: true, position: SIMD3<Float>(-0.9531499, -0.19649032, -0.22999223)
         - name : forearmArm
         - isTracked : true
         ▿ transform : simd_float4x4([[-0.9531499, -0.19649032, -0.22999223, 0.0], [-0.20108718, 0.97956693, -0.0035186193, 0.0], [0.22598422, 0.042894684, -0.97318614, 0.0], [0.27306026, 0.048532516, 0.059689812, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(-0.9531499, -0.19649032, -0.22999223, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.20108718, 0.97956693, -0.0035186193, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.22598422, 0.042894684, -0.97318614, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(0.27306026, 0.048532516, 0.059689812, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9999999, 4.3641357e-09, -3.0974483e-08, 0.0], [-1.3439994e-08, 0.9999999, 1.0403964e-08, 0.0], [-5.7288794e-08, -1.6010002e-09, 0.99999994, 0.0], [-0.28353179, -0.0075780153, 0.0056997538, 0.99999976]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9999999, 4.3641357e-09, -3.0974483e-08, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-1.3439994e-08, 0.9999999, 1.0403964e-08, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-5.7288794e-08, -1.6010002e-09, 0.99999994, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.28353179, -0.0075780153, 0.0056997538, 0.99999976)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 14 : 2 elements
       - key : middleFingerTip
       ▿ value : name: middleFingerTip, isTracked: true, position: SIMD3<Float>(0.075329386, 0.9970218, -0.01653214)
         - name : middleFingerTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.075329386, 0.9970218, -0.01653214, 0.0], [-0.9843906, 0.07170995, -0.16072716, 0.0], [-0.15906282, 0.028381536, 0.9868605, 0.0], [-0.14521961, -0.07328481, 0.00039148238, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.075329386, 0.9970218, -0.01653214, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.9843906, 0.07170995, -0.16072716, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.15906282, 0.028381536, 0.9868605, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.14521961, -0.07328481, 0.00039148238, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9999998, 8.1484215e-09, 4.6990074e-08, 0.0], [-8.9327315e-08, 0.99999994, 1.12452824e-07, 0.0], [-4.722769e-09, -1.1350248e-07, 0.9999999, 0.0], [-0.022789156, 7.588323e-05, -4.8847724e-05, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9999998, 8.1484215e-09, 4.6990074e-08, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-8.9327315e-08, 0.99999994, 1.12452824e-07, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-4.722769e-09, -1.1350248e-07, 0.9999999, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.022789156, 7.588323e-05, -4.8847724e-05, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 15 : 2 elements
       - key : thumbKnuckle
       ▿ value : name: thumbKnuckle, isTracked: true, position: SIMD3<Float>(0.7860589, 0.29532987, -0.5430391)
         - name : thumbKnuckle
         - isTracked : true
         ▿ transform : simd_float4x4([[0.7860589, 0.29532987, -0.5430391, 0.0], [0.50489336, 0.20010278, 0.8396675, 0.0], [0.3566426, -0.93420506, 0.008182508, 0.0], [-0.023585096, -0.0116383135, 0.019477904, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.7860589, 0.29532987, -0.5430391, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.50489336, 0.20010278, 0.8396675, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.3566426, -0.93420506, 0.008182508, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.023585096, -0.0116383135, 0.019477904, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.7860589, 0.29532987, -0.5430391, 0.0], [0.50489336, 0.20010278, 0.8396675, 0.0], [0.3566426, -0.93420506, 0.008182508, 0.0], [-0.023585096, -0.0116383135, 0.019477904, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.7860589, 0.29532987, -0.5430391, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.50489336, 0.20010278, 0.8396675, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.3566426, -0.93420506, 0.008182508, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.023585096, -0.0116383135, 0.019477904, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 16 : 2 elements
       - key : ringFingerTip
       ▿ value : name: ringFingerTip, isTracked: true, position: SIMD3<Float>(0.125431, 0.99162763, 0.030681897)
         - name : ringFingerTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.125431, 0.99162763, 0.030681897, 0.0], [-0.9907007, 0.12683715, -0.049234673, 0.0], [-0.052713968, -0.024220984, 0.9983159, 0.0], [-0.14231713, -0.061572187, -0.02228618, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.125431, 0.99162763, 0.030681897, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.9907007, 0.12683715, -0.049234673, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.052713968, -0.024220984, 0.9983159, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.14231713, -0.061572187, -0.02228618, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.99999976, 2.0466575e-07, -4.8387676e-08, 0.0], [-1.4768526e-07, 0.9999997, 7.483648e-08, 0.0], [8.399804e-08, -2.3685368e-08, 0.9999998, 0.0], [-0.021832533, 3.7548252e-05, -6.684113e-05, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.99999976, 2.0466575e-07, -4.8387676e-08, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-1.4768526e-07, 0.9999997, 7.483648e-08, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(8.399804e-08, -2.3685368e-08, 0.9999998, 0.0)
               ▿ _storage : SIMD4Storage                - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.021832533, 3.7548252e-05, -6.684113e-05, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 17 : 2 elements
       - key : littleFingerKnuckle
       ▿ value : name: littleFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.9687599, 0.16162635, 0.18809867)
         - name : littleFingerKnuckle
         - isTracked : true
         ▿ transform : simd_float4x4([[0.9687599, 0.16162635, 0.18809867, 0.0], [-0.15571317, 0.98673517, -0.04590037, 0.0], [-0.19302222, 0.015176985, 0.98107696, 0.0], [-0.078177914, -0.0049283206, -0.037026018, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9687599, 0.16162635, 0.18809867, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.15571317, 0.98673517, -0.04590037, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.19302222, 0.015176985, 0.98107696, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.078177914, -0.0049283206, -0.037026018, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9858006, 0.15493286, -0.064752646, 0.0], [-0.15529068, 0.98786855, -0.0004988827, 0.0], [0.063889734, 0.010547255, 0.9979011, 0.0], [-0.053737156, -0.0010289657, 0.00011866817, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9858006, 0.15493286, -0.064752646, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.15529068, 0.98786855, -0.0004988827, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.063889734, 0.010547255, 0.9979011, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.053737156, -0.0010289657, 0.00011866817, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 18 : 2 elements
       - key : indexFingerTip
       ▿ value : name: indexFingerTip, isTracked: true, position: SIMD3<Float>(0.1844895, 0.9667667, 0.17699157)
         - name : indexFingerTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.1844895, 0.9667667, 0.17699157, 0.0], [-0.9820272, 0.18862219, -0.006666963, 0.0], [-0.039829873, -0.17258054, 0.98418987, 0.0], [-0.12975489, -0.080787376, 0.014942017, 0.9999998]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.1844895, 0.9667667, 0.17699157, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.9820272, 0.18862219, -0.006666963, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.039829873, -0.17258054, 0.98418987, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.12975489, -0.080787376, 0.014942017, 0.9999998)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[1.0, 2.7436128e-08, -1.5936124e-07, 0.0], [6.304246e-08, 1.0000001, 2.896592e-08, 0.0], [1.0804877e-07, -1.7910361e-08, 1.0, 0.0], [-0.022060765, 4.619721e-05, 8.146446e-06, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(1.0, 2.7436128e-08, -1.5936124e-07, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(6.304246e-08, 1.0000001, 2.896592e-08, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(1.0804877e-07, -1.7910361e-08, 1.0, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.022060765, 4.619721e-05, 8.146446e-06, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 19 : 2 elements
       - key : ringFingerMetacarpal
       ▿ value : name: ringFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.9883689, 0.006818698, 0.1519226)
         - name : ringFingerMetacarpal
         - isTracked : true
         ▿ transform : simd_float4x4([[0.9883689, 0.006818698, 0.1519226, 0.0], [-0.006180871, 0.9999701, -0.0046708714, 0.0], [-0.15194981, 0.0036775083, 0.98838156, 0.0], [-0.027152985, -0.0019256771, -0.008529663, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9883689, 0.006818698, 0.1519226, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.006180871, 0.9999701, -0.0046708714, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.15194981, 0.0036775083, 0.98838156, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.027152985, -0.0019256771, -0.008529663, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9883689, 0.006818698, 0.1519226, 0.0], [-0.006180871, 0.9999701, -0.0046708714, 0.0], [-0.15194981, 0.0036775083, 0.98838156, 0.0], [-0.027152985, -0.0019256771, -0.008529663, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9883689, 0.006818698, 0.1519226, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.006180871, 0.9999701, -0.0046708714, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.15194981, 0.0036775083, 0.98838156, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.027152985, -0.0019256771, -0.008529663, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 20 : 2 elements
       - key : littleFingerIntermediateBase
       ▿ value : name: littleFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(0.69487804, 0.707727, 0.12754251)
         - name : littleFingerIntermediateBase
         - isTracked : true
         ▿ transform : simd_float4x4([[0.69487804, 0.707727, 0.12754251, 0.0], [-0.6932628, 0.70640373, -0.14276025, 0.0], [-0.19113167, 0.010780428, 0.9815053, 0.0], [-0.11224994, -0.010944156, -0.04336539, 0.9999998]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.69487804, 0.707727, 0.12754251, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.6932628, 0.70640373, -0.14276025, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.19113167, 0.010780428, 0.9815053, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.11224994, -0.010944156, -0.04336539, 0.9999998)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.811548, 0.5842835, 0.0017432083, 0.0], [-0.5842848, 0.81153655, 0.004477503, 0.0], [0.0012014646, -0.004652284, 0.99998856, 0.0], [-0.035172362, -0.0003395961, 0.0002659464, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.811548, 0.5842835, 0.0017432083, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.5842848, 0.81153655, 0.004477503, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.0012014646, -0.004652284, 0.99998856, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.035172362, -0.0003395961, 0.0002659464, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 21 : 2 elements
       - key : ringFingerIntermediateBase
       ▿ value : name: ringFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(0.36527988, 0.9300529, 0.039646197)
         - name : ringFingerIntermediateBase
         - isTracked : true
         ▿ transform : simd_float4x4([[0.36527988, 0.9300529, 0.039646197, 0.0], [-0.92941165, 0.3667715, -0.040899385, 0.0], [-0.052579697, -0.021907974, 0.9983765, 0.0], [-0.1294948, -0.01456135, -0.020417362, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.36527988, 0.9300529, 0.039646197, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.92941165, 0.3667715, -0.040899385, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.052579697, -0.021907974, 0.9983765, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.1294948, -0.01456135, -0.020417362, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.58947587, 0.80774385, -0.008219095, 0.0], [-0.8077401, 0.5895203, 0.004642734, 0.0], [0.008595443, 0.0039020954, 0.9999553, 0.0], [-0.04263555, -0.00028259307, 0.00021563517, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.58947587, 0.80774385, -0.008219095, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.8077401, 0.5895203, 0.004642734, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.008595443, 0.0039020954, 0.9999553, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.04263555, -0.00028259307, 0.00021563517, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 22 : 2 elements
       - key : indexFingerIntermediateBase
       ▿ value : name: indexFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(0.2509824, 0.9520032, 0.17520842)
         - name : indexFingerIntermediateBase
         - isTracked : true
         ▿ transform : simd_float4x4([[0.2509824, 0.9520032, 0.17520842, 0.0], [-0.96717334, 0.25406995, 0.004954838, 0.0], [-0.039798137, -0.17070046, 0.984519, 0.0], [-0.11947082, -0.03632128, 0.023090718, 0.9999998]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.2509824, 0.9520032, 0.17520842, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.96717334, 0.25406995, 0.004954838, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.039798137, -0.17070046, 0.984519, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.11947082, -0.03632128, 0.023090718, 0.9999998)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9195519, 0.3928464, 0.009817107, 0.0], [-0.39284125, 0.91960305, -0.002528084, 0.0], [-0.010020981, -0.0015318732, 0.9999488, 0.0], [-0.044164196, -0.00012590419, 6.0479113e-05, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9195519, 0.3928464, 0.009817107, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.39284125, 0.91960305, -0.002528084, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.010020981, -0.0015318732, 0.9999488, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.044164196, -0.00012590419, 6.0479113e-05, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 23 : 2 elements
       - key : middleFingerKnuckle
       ▿ value : name: middleFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.90085894, 0.42698848, 0.078318484)
         - name : middleFingerKnuckle
         - isTracked : true
         ▿ transform : simd_float4x4([[0.90085894, 0.42698848, 0.078318484, 0.0], [-0.41807464, 0.9019271, -0.1083557, 0.0], [-0.116904095, 0.06487024, 0.99102235, 0.0], [-0.092208534, -0.0020262003, 0.0038823783, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.90085894, 0.42698848, 0.078318484, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.41807464, 0.9019271, -0.1083557, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.116904095, 0.06487024, 0.99102235, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.092208534, -0.0020262003, 0.0038823783, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9041703, 0.4210875, 0.071842134, 0.0], [-0.413288, 0.9048518, -0.10215708, 0.0], [-0.10802349, 0.0626759, 0.99217063, 0.0], [-0.06519448, -0.0012615008, 3.3774224e-05, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9041703, 0.4210875, 0.071842134, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.413288, 0.9048518, -0.10215708, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.10802349, 0.0626759, 0.99217063, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.06519448, -0.0012615008, 3.3774224e-05, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 24 : 2 elements
       - key : indexFingerIntermediateTip
       ▿ value : name: indexFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(0.18448953, 0.9667666, 0.17699173)
         - name : indexFingerIntermediateTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.18448953, 0.9667666, 0.17699173, 0.0], [-0.9820271, 0.18862213, -0.0066669923, 0.0], [-0.039829914, -0.17258063, 0.9841898, 0.0], [-0.12563922, -0.059467077, 0.018838882, 0.9999998]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.18448953, 0.9667666, 0.17699173, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.9820271, 0.18862213, -0.0066669923, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.039829914, -0.17258063, 0.9841898, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.12563922, -0.059467077, 0.018838882, 0.9999998)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9976788, 0.06806993, 0.0018818389, 0.0], [-0.068070844, 0.9976803, 0.00032123722, 0.0], [-0.0018555778, -0.00044859695, 0.99999815, 0.0], [-0.024327984, 6.419895e-05, 1.0475488e-05, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9976788, 0.06806993, 0.0018818389, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.068070844, 0.9976803, 0.00032123722, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.0018555778, -0.00044859695, 0.99999815, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.024327984, 6.419895e-05, 1.0475488e-05, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 25 : 2 elements
       - key : indexFingerMetacarpal
       ▿ value : name: indexFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.98339236, 0.0061067506, -0.18138972)
         - name : indexFingerMetacarpal
         - isTracked : true
         ▿ transform : simd_float4x4([[0.98339236, 0.0061067506, -0.18138972, 0.0], [-0.006327772, 0.99997985, -0.0006393399, 0.0], [0.18138218, 0.0017764925, 0.98341125, 0.0], [-0.025118202, -0.00026482344, 0.017194659, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.98339236, 0.0061067506, -0.18138972, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.006327772, 0.99997985, -0.0006393399, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.18138218, 0.0017764925, 0.98341125, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.025118202, -0.00026482344, 0.017194659, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.98339236, 0.0061067506, -0.18138972, 0.0], [-0.006327772, 0.99997985, -0.0006393399, 0.0], [0.18138218, 0.0017764925, 0.98341125, 0.0], [-0.025118202, -0.00026482344, 0.017194659, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.98339236, 0.0061067506, -0.18138972, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.006327772, 0.99997985, -0.0006393399, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.18138218, 0.0017764925, 0.98341125, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.025118202, -0.00026482344, 0.017194659, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 26 : 2 elements
       - key : indexFingerKnuckle
       ▿ value : name: indexFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.6111354, 0.7773174, 0.14930087)
         - name : indexFingerKnuckle
         - isTracked : true
         ▿ transform : simd_float4x4([[0.6111354, 0.7773174, 0.14930087, 0.0], [-0.7907567, 0.6078958, 0.071878314, 0.0], [-0.034887083, -0.16198806, 0.9861758, 0.0], [-0.09257797, -0.0019053518, 0.02963388, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.6111354, 0.7773174, 0.14930087, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.7907567, 0.6078958, 0.071878314, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.034887083, -0.16198806, 0.9861758, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.09257797, -0.0019053518, 0.02963388, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.57865125, 0.7733391, 0.25905406, 0.0], [-0.7869497, 0.6128411, -0.07166327, 0.0], [-0.21417907, -0.16239451, 0.96320033, 0.0], [-0.06860578, -0.0012215838, -6.0416846e-06, 0.99999994]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.57865125, 0.7733391, 0.25905406, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.7869497, 0.6128411, -0.07166327, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.21417907, -0.16239451, 0.96320033, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.06860578, -0.0012215838, -6.0416846e-06, 0.99999994)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
 */
