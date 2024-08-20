//
//  File.swift
//  
//
//  Created by 许同学 on 2024/6/5.
//

import ARKit


public struct HVJointInfo: Sendable, Equatable {
    public let name: HandSkeleton.JointName
    public let isTracked: Bool
    // relative to anchor
    public let transform: simd_float4x4
    // relative to parent joint
    public let transformToParent: simd_float4x4
    
    public init(joint: HandSkeleton.Joint) {
        self.name = joint.name
        self.isTracked = joint.isTracked
        self.transform = joint.anchorFromJointTransform
        self.transformToParent = joint.parentFromJointTransform
    }
    
    public init(name: HandSkeleton.JointName, isTracked: Bool, anchorFromJointTransform: simd_float4x4, parentFromJointTransform: simd_float4x4) {
        self.name = name
        self.isTracked = isTracked
        self.transform = anchorFromJointTransform
        self.transformToParent = parentFromJointTransform
    }
    
    public func reversedChirality() -> HVJointInfo {
        return HVJointInfo(name: name, isTracked: isTracked, anchorFromJointTransform: transform.positionReversed, parentFromJointTransform: transformToParent.positionReversed)
    }

    public var position: SIMD3<Float> {
        return transform.columns.3.xyz
    }

    public var description: String {
        return "name: \(name), isTracked: \(isTracked), position: \(transform.columns.0.xyz)"
    }
    
}

//Full Curl
//CustomStringConvertible


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
 */


/*
 po leftHandVector?.allJoints
▿ Optional<Dictionary<NameCodingKey, HVJointInfo>>
  ▿ some : 27 elements
    ▿ 0 : 2 elements
      - key : indexFingerMetacarpal
      ▿ value : name: indexFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.9863474, 0.0031139816, -0.16464798)
        - name : indexFingerMetacarpal
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9863474, 0.0031139816, -0.16464798, 0.0], [-0.0025380738, 0.9999898, 0.0037075544, 0.0], [0.16465786, -0.0032391238, 0.98634523, 0.0], [0.024695534, 4.786253e-05, -0.016919255, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9863474, 0.0031139816, -0.16464798, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.0025380738, 0.9999898, 0.0037075544, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.16465786, -0.0032391238, 0.98634523, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.024695534, 4.786253e-05, -0.016919255, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9863474, 0.0031139816, -0.16464798, 0.0], [-0.0025380738, 0.9999898, 0.0037075544, 0.0], [0.16465786, -0.0032391238, 0.98634523, 0.0], [0.024695534, 4.786253e-05, -0.016919255, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9863474, 0.0031139816, -0.16464798, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.0025380738, 0.9999898, 0.0037075544, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.16465786, -0.0032391238, 0.98634523, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.024695534, 4.786253e-05, -0.016919255, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 1 : 2 elements
      - key : ringFingerIntermediateBase
      ▿ value : name: ringFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(-0.9953664, 0.06257769, -0.0730058)
        - name : ringFingerIntermediateBase
        - isTracked : true
        ▿ transform : simd_float4x4([[-0.9953664, 0.06257769, -0.0730058, 0.0], [-0.06799102, -0.9949243, 0.07418357, 0.0], [-0.06799305, 0.07880347, 0.99456894, 0.0], [0.10066244, 0.039795905, 0.017426549, 1.0000001]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(-0.9953664, 0.06257769, -0.0730058, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.06799102, -0.9949243, 0.07418357, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.06799305, 0.07880347, 0.99456894, 0.0)              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.10066244, 0.039795905, 0.017426549, 1.0000001)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[-0.2514807, 0.9678522, 0.004448457, 0.0], [-0.96777356, -0.25151715, 0.012397962, 0.0], [0.013118252, -0.0011873007, 0.9999134, 0.0], [0.040069364, 1.225993e-05, -1.9922387e-05, 1.0000001]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(-0.2514807, 0.9678522, 0.004448457, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.96777356, -0.25151715, 0.012397962, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.013118252, -0.0011873007, 0.9999134, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.040069364, 1.225993e-05, -1.9922387e-05, 1.0000001)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 2 : 2 elements
      - key : ringFingerKnuckle
      ▿ value : name: ringFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.31522325, 0.94815785, -0.040386327)
        - name : ringFingerKnuckle
        - isTracked : true
        ▿ transform : simd_float4x4([[0.31522325, 0.94815785, -0.040386327, 0.0], [-0.9461858, 0.31071293, -0.090498075, 0.0], [-0.07325797, 0.066739984, 0.99507743, 0.0], [0.08804178, 0.0018013419, 0.019065736, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.31522325, 0.94815785, -0.040386327, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.9461858, 0.31071293, -0.090498075, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.07325797, 0.066739984, 0.99507743, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.08804178, 0.0018013419, 0.019065736, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.3068106, 0.94707596, -0.09441766, 0.0], [-0.946842, 0.31379882, 0.070856504, 0.0], [0.0967346, 0.06765908, 0.99300796, 0.0], [0.062219523, 3.5938807e-05, -4.110951e-05, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.3068106, 0.94707596, -0.09441766, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.946842, 0.31379882, 0.070856504, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.0967346, 0.06765908, 0.99300796, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.062219523, 3.5938807e-05, -4.110951e-05, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 3 : 2 elements
      - key : indexFingerIntermediateTip
      ▿ value : name: indexFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(0.9848766, 0.105888315, 0.13713266)
        - name : indexFingerIntermediateTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9848766, 0.105888315, 0.13713266, 0.0], [-0.11738204, 0.9899702, 0.07861434, 0.0], [-0.127433, -0.093522444, 0.98742795, 0.0], [0.15331936, 0.023483457, -0.018206304, 1.0000001]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9848766, 0.105888315, 0.13713266, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.11738204, 0.9899702, 0.07861434, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.127433, -0.093522444, 0.98742795, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.15331936, 0.023483457, -0.018206304, 1.0000001)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.98199064, -0.18891114, 0.0025529196, 0.0], [0.18891107, 0.98199403, 0.00028377163, 0.0], [-0.0025605904, 0.00020361997, 0.9999964, 0.0], [0.024351139, 1.5546568e-05, -1.8505274e-05, 1.0000001]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.98199064, -0.18891114, 0.0025529196, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.18891107, 0.98199403, 0.00028377163, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.0025605904, 0.00020361997, 0.9999964, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.024351139, 1.5546568e-05, -1.8505274e-05, 1.0000001)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 4 : 2 elements
      - key : littleFingerKnuckle
      ▿ value : name: littleFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.81195116, 0.39558628, 0.4292396)
        - name : littleFingerKnuckle
        - isTracked : true
        ▿ transform : simd_float4x4([[0.81195116, 0.39558628, 0.4292396, 0.0], [-0.39887747, 0.91288704, -0.08679692, 0.0], [-0.42618293, -0.1007392, 0.89901024, 0.0], [0.07838775, 0.0032950637, 0.03413987, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.81195116, 0.39558628, 0.4292396, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.39887747, 0.91288704, -0.08679692, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.42618293, -0.1007392, 0.89901024, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.07838775, 0.0032950637, 0.03413987, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.88336045, 0.39269716, 0.25585714, 0.0], [-0.4049313, 0.91433156, -0.005296881, 0.0], [-0.23601826, -0.09892544, 0.9666999, 0.0], [0.053686652, 2.9696384e-05, -3.6127865e-05, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.88336045, 0.39269716, 0.25585714, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.4049313, 0.91433156, -0.005296881, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.23601826, -0.09892544, 0.9666999, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.053686652, 2.9696384e-05, -3.6127865e-05, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 5 : 2 elements
      - key : littleFingerIntermediateBase
      ▿ value : name: littleFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(0.8587789, 0.26407424, 0.43904853)
        - name : littleFingerIntermediateBase
        - isTracked : true
        ▿ transform : simd_float4x4([[0.8587789, 0.26407424, 0.43904853, 0.0], [-0.28169537, 0.95915407, -0.025905797, 0.0], [-0.42795622, -0.10143071, 0.89808965, 0.0], [0.10471842, 0.01614546, 0.048029717, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.8587789, 0.26407424, 0.43904853, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.28169537, 0.95915407, -0.025905797, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.42795622, -0.10143071, 0.89808965, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.10471842, 0.01614546, 0.048029717, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9902078, -0.1395856, 0.0021095616, 0.0], [0.13958566, 0.9902101, 0.0001398136, 0.0], [-0.0021085332, 0.00015595873, 0.9999978, 0.0], [0.032424726, 2.2664666e-05, -2.91029e-05, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9902078, -0.1395856, 0.0021095616, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.13958566, 0.9902101, 0.0001398136, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.0021085332, 0.00015595873, 0.9999978, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.032424726, 2.2664666e-05, -2.91029e-05, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 6 : 2 elements
      - key : indexFingerIntermediateBase
      ▿ value : name: indexFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(0.94529164, 0.29123715, 0.14698584)
        - name : indexFingerIntermediateBase
        - isTracked : true
        ▿ transform : simd_float4x4([[0.94529164, 0.29123715, 0.14698584, 0.0], [-0.30134872, 0.95212257, 0.051493984, 0.0], [-0.12495155, -0.09297091, 0.98779744, 0.0], [0.1303028, 0.01637497, -0.021768095, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.94529164, 0.29123715, 0.14698584, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.30134872, 0.95212257, 0.051493984, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.12495155, -0.09297091, 0.98779744, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.1303028, 0.01637497, -0.021768095, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9955485, -0.09425199, -6.5192384e-05, 0.0], [0.09425196, 0.9955484, 0.00014784359, 0.0], [5.0995302e-05, -0.00015332141, 1.0000002, 0.0], [0.042289592, 2.8163195e-05, -3.4501776e-05, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9955485, -0.09425199, -6.5192384e-05, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.09425196, 0.9955484, 0.00014784359, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(5.0995302e-05, -0.00015332141, 1.0000002, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.042289592, 2.8163195e-05, -3.4501776e-05, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 7 : 2 elements
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
    ▿ 8 : 2 elements
      - key : thumbIntermediateTip
      ▿ value : name: thumbIntermediateTip, isTracked: true, position: SIMD3<Float>(0.84760803, 0.08054915, -0.5244731)
        - name : thumbIntermediateTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.84760803, 0.08054915, -0.5244731, 0.0], [0.5020771, 0.19807434, 0.8418343, 0.0], [0.17169367, -0.97687155, 0.12744762, 0.0], [0.087028675, 0.025426919, -0.06448481, 0.99999976]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.84760803, 0.08054915, -0.5244731, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.5020771, 0.19807434, 0.8418343, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.17169367, -0.97687155, 0.12744762, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.087028675, 0.025426919, -0.06448481, 0.99999976)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9936598, -0.11242109, -0.001291994, 0.0], [0.11242214, 0.9936603, 0.00080785615, 0.0], [0.0011930009, -0.0009480315, 0.9999988, 0.0], [0.030840503, -2.1555932e-06, -8.065359e-06, 0.9999999]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9936598, -0.11242109, -0.001291994, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.11242214, 0.9936603, 0.00080785615, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.0011930009, -0.0009480315, 0.9999988, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.030840503, -2.1555932e-06, -8.065359e-06, 0.9999999)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 9 : 2 elements
      - key : middleFingerIntermediateTip
      ▿ value : name: middleFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(-0.94132185, -0.32519233, -0.09035019)
        - name : middleFingerIntermediateTip
        - isTracked : true
        ▿ transform : simd_float4x4([[-0.94132185, -0.32519233, -0.09035019, 0.0], [0.33246228, -0.9395273, -0.082202025, 0.0], [-0.058155056, -0.10741669, 0.9925118, 0.0], [0.07855159, 0.044096213, -0.0018124888, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(-0.94132185, -0.32519233, -0.09035019, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.33246228, -0.9395273, -0.082202025, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.058155056, -0.10741669, 0.9925118, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.07855159, 0.044096213, -0.0018124888, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9310789, 0.36463723, 0.011476803, 0.0], [-0.364655, 0.93114245, -0.00056685467, 0.0], [-0.010893201, -0.0036572937, 0.9999339, 0.0], [0.028702676, 9.905547e-06, 1.7378712e-05, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9310789, 0.36463723, 0.011476803, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.364655, 0.93114245, -0.00056685467, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.010893201, -0.0036572937, 0.9999339, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.028702676, 9.905547e-06, 1.7378712e-05, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 10 : 2 elements
      - key : littleFingerTip
      ▿ value : name: littleFingerTip, isTracked: true, position: SIMD3<Float>(0.88870054, 0.12715505, 0.44050282)
        - name : littleFingerTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.88870054, 0.12715505, 0.44050282, 0.0], [-0.15881449, 0.98666644, 0.03559319, 0.0], [-0.43010354, -0.10159, 0.89704514, 0.0], [0.13678119, 0.023238234, 0.06412386, 0.9999999]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.88870054, 0.12715505, 0.44050282, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.15881449, 0.98666644, 0.03559319, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.43010354, -0.10159, 0.89704514, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.13678119, 0.023238234, 0.06412386, 0.9999999)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.99999994, -9.2414716e-08, -9.885419e-08, 0.0], [1.5171388e-07, 0.99999976, -1.9629033e-07, 0.0], [6.1100344e-08, 1.5682612e-07, 0.99999976, 0.0], [0.01908608, 1.115521e-05, -1.6891241e-05, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.99999994, -9.2414716e-08, -9.885419e-08, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(1.5171388e-07, 0.99999976, -1.9629033e-07, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(6.1100344e-08, 1.5682612e-07, 0.99999976, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.01908608, 1.115521e-05, -1.6891241e-05, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 11 : 2 elements
      - key : ringFingerMetacarpal
      ▿ value : name: ringFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.9855156, 0.0031648583, 0.16955484)
        - name : ringFingerMetacarpal
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9855156, 0.0031648583, 0.16955484, 0.0], [-0.0033281825, 0.9999941, 0.00067892484, 0.0], [-0.16955176, -0.0012334678, 0.9855205, 0.0], [0.02671662, 0.0015684366, 0.008556604, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9855156, 0.0031648583, 0.16955484, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.0033281825, 0.9999941, 0.00067892484, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.16955176, -0.0012334678, 0.9855205, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.02671662, 0.0015684366, 0.008556604, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9855156, 0.0031648583, 0.16955484, 0.0], [-0.0033281825, 0.9999941, 0.00067892484, 0.0], [-0.16955176, -0.0012334678, 0.9855205, 0.0], [0.02671662, 0.0015684366, 0.008556604, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9855156, 0.0031648583, 0.16955484, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.0033281825, 0.9999941, 0.00067892484, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.16955176, -0.0012334678, 0.9855205, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.02671662, 0.0015684366, 0.008556604, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 12 : 2 elements
      - key : indexFingerKnuckle
      ▿ value : name: indexFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.9126743, 0.37967536, 0.15123524)
        - name : indexFingerKnuckle
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9126743, 0.37967536, 0.15123524, 0.0], [-0.38908362, 0.92044854, 0.037259597, 0.0], [-0.12505773, -0.09284913, 0.9877952, 0.0], [0.09171282, 0.00028952956, -0.02813074, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9126743, 0.37967536, 0.15123524, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.38908362, 0.92044854, 0.037259597, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.12505773, -0.09284913, 0.9877952, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.09171282, 0.00028952956, -0.02813074, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.8764958, 0.3779158, 0.29821947, 0.0], [-0.3870402, 0.92156506, -0.030296234, 0.0], [-0.28627804, -0.08886839, 0.95401645, 0.0], [0.06794903, 2.999674e-05, -2.4257228e-05, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.8764958, 0.3779158, 0.29821947, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.3870402, 0.92156506, -0.030296234, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.28627804, -0.08886839, 0.95401645, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.06794903, 2.999674e-05, -2.4257228e-05, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 13 : 2 elements
      - key : middleFingerKnuckle
      ▿ value : name: middleFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.35500902, 0.9309376, 0.08557829)
        - name : middleFingerKnuckle
        - isTracked : true
        ▿ transform : simd_float4x4([[0.35500902, 0.9309376, 0.08557829, 0.0], [-0.93268967, 0.35893458, -0.03543457, 0.0], [-0.06370438, -0.06723845, 0.995701, 0.0], [0.090928234, 0.00030097368, -0.0038546028, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.35500902, 0.9309376, 0.08557829, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.93268967, 0.35893458, -0.03543457, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.06370438, -0.06723845, 0.995701, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.090928234, 0.00030097368, -0.0038546028, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.3584072, 0.93003654, 0.081095494, 0.0], [-0.9318128, 0.36170235, -0.029939448, 0.0], [-0.05717713, -0.06483527, 0.99625665, 0.0], [0.06435435, 3.4160552e-05, -3.4138095e-05, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.3584072, 0.93003654, 0.081095494, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.9318128, 0.36170235, -0.029939448, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.05717713, -0.06483527, 0.99625665, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.06435435, 3.4160552e-05, -3.4138095e-05, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 14 : 2 elements
      - key : middleFingerIntermediateBase
      ▿ value : name: middleFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(-0.9970455, 0.04099382, -0.06495944)
        - name : middleFingerIntermediateBase
        - isTracked : true
        ▿ transform : simd_float4x4([[-0.9970455, 0.04099382, -0.06495944, 0.0], [-0.033458427, -0.9930181, -0.113116734, 0.0], [-0.06914302, -0.11060921, 0.99145603, 0.0], [0.107171, 0.042931337, 3.5911333e-05, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(-0.9970455, 0.04099382, -0.06495944, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.033458427, -0.9930181, -0.113116734, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.06914302, -0.11060921, 0.99145603, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.107171, 0.042931337, 3.5911333e-05, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[-0.32135665, 0.9469503, -0.0039203577, 0.0], [-0.94599646, -0.32121408, -0.043730054, 0.0], [-0.042669512, -0.010344294, 0.99903595, 0.0], [0.045785487, 1.4193356e-05, -2.7344562e-05, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(-0.32135665, 0.9469503, -0.0039203577, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.94599646, -0.32121408, -0.043730054, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.042669512, -0.010344294, 0.99903595, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.045785487, 1.4193356e-05, -2.7344562e-05, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 15 : 2 elements
      - key : middleFingerTip
      ▿ value : name: middleFingerTip, isTracked: true, position: SIMD3<Float>(-0.94132185, -0.32519227, -0.09035009)
        - name : middleFingerTip
        - isTracked : true
        ▿ transform : simd_float4x4([[-0.94132185, -0.32519227, -0.09035009, 0.0], [0.33246234, -0.9395272, -0.08220195, 0.0], [-0.05815494, -0.107416555, 0.9925118, 0.0], [0.05863164, 0.03720609, -0.0037115824, 0.9999999]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(-0.94132185, -0.32519227, -0.09035009, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.33246234, -0.9395272, -0.08220195, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.05815494, -0.107416555, 0.9925118, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.05863164, 0.03720609, -0.0037115824, 0.9999999)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[1.0, -2.323812e-08, 8.954726e-08, 0.0], [-8.2104116e-08, 0.99999994, 6.356725e-08, 0.0], [-1.4979484e-07, -8.817707e-08, 0.99999994, 0.0], [0.021163272, 6.9299713e-06, 1.3683661e-05, 0.9999999]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(1.0, -2.323812e-08, 8.954726e-08, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-8.2104116e-08, 0.99999994, 6.356725e-08, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-1.4979484e-07, -8.817707e-08, 0.99999994, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.021163272, 6.9299713e-06, 1.3683661e-05, 0.9999999)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 16 : 2 elements
      - key : thumbKnuckle
      ▿ value : name: thumbKnuckle, isTracked: true, position: SIMD3<Float>(0.7286268, 0.22165273, -0.6480532)
        - name : thumbKnuckle
        - isTracked : true
        ▿ transform : simd_float4x4([[0.7286268, 0.22165273, -0.6480532, 0.0], [0.60517216, 0.23473586, 0.7607007, 0.0], [0.32073277, -0.9464507, 0.03689689, 0.0], [0.023175266, 0.011310369, -0.01920423, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.7286268, 0.22165273, -0.6480532, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.60517216, 0.23473586, 0.7607007, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.32073277, -0.9464507, 0.03689689, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.023175266, 0.011310369, -0.01920423, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.7286268, 0.22165273, -0.6480532, 0.0], [0.60517216, 0.23473586, 0.7607007, 0.0], [0.32073277, -0.9464507, 0.03689689, 0.0], [0.023175266, 0.011310369, -0.01920423, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.7286268, 0.22165273, -0.6480532, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.60517216, 0.23473586, 0.7607007, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.32073277, -0.9464507, 0.03689689, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.023175266, 0.011310369, -0.01920423, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 17 : 2 elements
      - key : ringFingerIntermediateTip
      ▿ value : name: ringFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(-0.9694061, -0.24143621, -0.044276524)
        - name : ringFingerIntermediateTip
        - isTracked : true
        ▿ transform : simd_float4x4([[-0.9694061, -0.24143621, -0.044276524, 0.0], [0.23651735, -0.967009, 0.09462074, 0.0], [-0.06566067, 0.08125363, 0.9945284, 0.0], [0.074904844, 0.041404657, 0.015551806, 1.0000001]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(-0.9694061, -0.24143621, -0.044276524, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.23651735, -0.967009, 0.09462074, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.06566067, 0.08125363, 0.9945284, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.074904844, 0.041404657, 0.015551806, 1.0000001)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.95303804, 0.30283687, 0.0028507682, 0.0], [-0.30284256, 0.9530387, 0.0018215675, 0.0], [-0.0021652842, -0.0025993101, 0.9999942, 0.0], [0.025875783, 1.1620078e-05, 1.3550218e-05, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.95303804, 0.30283687, 0.0028507682, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.30284256, 0.9530387, 0.0018215675, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.0021652842, -0.0025993101, 0.9999942, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.025875783, 1.1620078e-05, 1.3550218e-05, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 18 : 2 elements
      - key : middleFingerMetacarpal
      ▿ value : name: middleFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.99997234, 0.0030394031, 0.0067588617)
        - name : middleFingerMetacarpal
        - isTracked : true
        ▿ transform : simd_float4x4([[0.99997234, 0.0030394031, 0.0067588617, 0.0], [-0.003054382, 0.99999267, 0.0022175927, 0.0], [-0.0067521385, -0.0022382468, 0.9999745, 0.0], [0.026575536, 7.113814e-05, -0.0042555034, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.99997234, 0.0030394031, 0.0067588617, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.003054382, 0.99999267, 0.0022175927, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.0067521385, -0.0022382468, 0.9999745, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.026575536, 7.113814e-05, -0.0042555034, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.99997234, 0.0030394031, 0.0067588617, 0.0], [-0.003054382, 0.99999267, 0.0022175927, 0.0], [-0.0067521385, -0.0022382468, 0.9999745, 0.0], [0.026575536, 7.113814e-05, -0.0042555034, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.99997234, 0.0030394031, 0.0067588617, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.003054382, 0.99999267, 0.0022175927, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.0067521385, -0.0022382468, 0.9999745, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.026575536, 7.113814e-05, -0.0042555034, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 19 : 2 elements
      - key : ringFingerTip
      ▿ value : name: ringFingerTip, isTracked: true, position: SIMD3<Float>(-0.9694061, -0.2414362, -0.044276472)
        - name : ringFingerTip
        - isTracked : true
        ▿ transform : simd_float4x4([[-0.9694061, -0.2414362, -0.044276472, 0.0], [0.23651735, -0.967009, 0.09462072, 0.0], [-0.06566063, 0.08125364, 0.9945283, 0.0], [0.055986308, 0.0366859, 0.014698297, 1.0000001]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(-0.9694061, -0.2414362, -0.044276472, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.23651735, -0.967009, 0.09462072, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.06566063, 0.08125364, 0.9945283, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.055986308, 0.0366859, 0.014698297, 1.0000001)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[1.0, -1.9169379e-08, 5.3240925e-08, 0.0], [-1.1199919e-08, 1.0, -2.579761e-08, 0.0], [-3.544852e-08, -1.2145484e-08, 0.9999999, 0.0], [0.019516818, 7.755123e-06, 9.947813e-06, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(1.0, -1.9169379e-08, 5.3240925e-08, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-1.1199919e-08, 1.0, -2.579761e-08, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-3.544852e-08, -1.2145484e-08, 0.9999999, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.019516818, 7.755123e-06, 9.947813e-06, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 20 : 2 elements
      - key : forearmArm
      ▿ value : name: forearmArm, isTracked: true, position: SIMD3<Float>(-0.9685943, -0.23967828, -0.06617802)
        - name : forearmArm
        - isTracked : true
        ▿ transform : simd_float4x4([[-0.9685943, -0.23967828, -0.06617802, 0.0], [-0.24016301, 0.9707324, -0.00064980227, 0.0], [0.064396955, 0.015264077, -0.9978077, 0.0], [-0.25962055, -0.064049274, -0.017986301, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(-0.9685943, -0.23967828, -0.06617802, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.24016301, 0.9707324, -0.00064980227, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.064396955, 0.015264077, -0.9978077, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(-0.25962055, -0.064049274, -0.017986301, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[1.0, 3.4078722e-09, -1.3032299e-08, 0.0], [4.790053e-10, 0.99999994, -9.730606e-09, 0.0], [-2.0930628e-08, -1.1257439e-08, 0.99999994, 0.0], [0.2680084, 0.00018817186, 0.00025045872, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(1.0, 3.4078722e-09, -1.3032299e-08, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(4.790053e-10, 0.99999994, -9.730606e-09, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-2.0930628e-08, -1.1257439e-08, 0.99999994, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.2680084, 0.00018817186, 0.00025045872, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 21 : 2 elements
      - key : thumbIntermediateBase
      ▿ value : name: thumbIntermediateBase, isTracked: true, position: SIMD3<Float>(0.89888346, 0.10114102, -0.42635491)
        - name : thumbIntermediateBase
        - isTracked : true
        ▿ transform : simd_float4x4([[0.89888346, 0.10114102, -0.42635491, 0.0], [0.40344226, 0.18868922, 0.8953381, 0.0], [0.17100398, -0.97681445, 0.12880524, 0.0], [0.059308913, 0.022300212, -0.051332854, 0.9999999]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.89888346, 0.10114102, -0.42635491, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.40344226, 0.18868922, 0.8953381, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.17100398, -0.97681445, 0.12880524, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.059308913, 0.022300212, -0.051332854, 0.9999999)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.95366955, 0.24339227, 0.17684528, 0.0], [-0.2444444, 0.9695287, -0.0161528, 0.0], [-0.17538814, -0.027824434, 0.984106, 0.0], [0.04958494, 6.523682e-06, 2.4549663e-06, 0.9999999]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.95366955, 0.24339227, 0.17684528, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.2444444, 0.9695287, -0.0161528, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.17538814, -0.027824434, 0.984106, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.04958494, 6.523682e-06, 2.4549663e-06, 0.9999999)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 22 : 2 elements
      - key : indexFingerTip
      ▿ value : name: indexFingerTip, isTracked: true, position: SIMD3<Float>(0.9848765, 0.105888486, 0.13713261)
        - name : indexFingerTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9848765, 0.105888486, 0.13713261, 0.0], [-0.11738228, 0.9899703, 0.078614265, 0.0], [-0.12743288, -0.09352243, 0.9874281, 0.0], [0.17465757, 0.025791543, -0.015249976, 1.0000001]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9848765, 0.105888486, 0.13713261, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.11738228, 0.9899703, 0.078614265, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.12743288, -0.09352243, 0.9874281, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.17465757, 0.025791543, -0.015249976, 1.0000001)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.99999994, 1.8644681e-07, -8.514064e-08, 0.0], [-2.1730892e-07, 1.0000001, -5.7132343e-08, 0.0], [1.08368745e-07, 1.2302519e-08, 1.0000001, 0.0], [0.021665322, 1.26300465e-05, -1.5882038e-05, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.99999994, 1.8644681e-07, -8.514064e-08, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-2.1730892e-07, 1.0000001, -5.7132343e-08, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(1.08368745e-07, 1.2302519e-08, 1.0000001, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.021665322, 1.26300465e-05, -1.5882038e-05, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 23 : 2 elements
      - key : forearmWrist
      ▿ value : name: forearmWrist, isTracked: true, position: SIMD3<Float>(-0.9685943, -0.23967828, -0.06617803)
        - name : forearmWrist
        - isTracked : true
        ▿ transform : simd_float4x4([[-0.9685943, -0.23967828, -0.06617803, 0.0], [-0.24016303, 0.97073245, -0.000649812, 0.0], [0.06439693, 0.015264084, -0.99780774, 0.0], [-5.2154064e-08, 2.9802322e-08, 0.0, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(-0.9685943, -0.23967828, -0.06617803, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.24016303, 0.97073245, -0.000649812, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.06439693, 0.015264084, -0.99780774, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(-5.2154064e-08, 2.9802322e-08, 0.0, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[-0.9685943, -0.23967828, -0.06617803, 0.0], [-0.24016303, 0.97073245, -0.000649812, 0.0], [0.06439693, 0.015264084, -0.99780774, 0.0], [-5.2154064e-08, 2.9802322e-08, 0.0, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(-0.9685943, -0.23967828, -0.06617803, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.24016303, 0.97073245, -0.000649812, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.06439693, 0.015264084, -0.99780774, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(-5.2154064e-08, 2.9802322e-08, 0.0, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 24 : 2 elements
      - key : thumbTip
      ▿ value : name: thumbTip, isTracked: true, position: SIMD3<Float>(0.847608, 0.08054909, -0.5244731)
        - name : thumbTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.847608, 0.08054909, -0.5244731, 0.0], [0.5020771, 0.1980744, 0.84183407, 0.0], [0.17169368, -0.97687143, 0.12744772, 0.0], [0.11098546, 0.027712688, -0.079312064, 0.99999976]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.847608, 0.08054909, -0.5244731, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.5020771, 0.1980744, 0.84183407, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(0.17169368, -0.97687143, 0.12744772, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.11098546, 0.027712688, -0.079312064, 0.99999976)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.99999994, -4.9935085e-08, 4.418754e-08, 0.0], [8.225146e-08, 0.99999976, -1.060378e-07, 0.0], [-3.3579617e-08, 1.1058289e-07, 0.9999999, 0.0], [0.028266585, -1.1816682e-06, -9.367861e-06, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.99999994, -4.9935085e-08, 4.418754e-08, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(8.225146e-08, 0.99999976, -1.060378e-07, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-3.3579617e-08, 1.1058289e-07, 0.9999999, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.028266585, -1.1816682e-06, -9.367861e-06, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 25 : 2 elements
      - key : littleFingerMetacarpal
      ▿ value : name: littleFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.9793508, 0.003565142, 0.20213717)
        - name : littleFingerMetacarpal
        - isTracked : true
        ▿ transform : simd_float4x4([[0.9793508, 0.003565142, 0.20213717, 0.0], [-0.0036949096, 0.9999932, 0.00026499433, 0.0], [-0.20213489, -0.0010065072, 0.97935724, 0.0], [0.02580249, 0.0030739307, 0.023323178, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9793508, 0.003565142, 0.20213717, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.0036949096, 0.9999932, 0.00026499433, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.20213489, -0.0010065072, 0.97935724, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.02580249, 0.0030739307, 0.023323178, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.9793508, 0.003565142, 0.20213717, 0.0], [-0.0036949096, 0.9999932, 0.00026499433, 0.0], [-0.20213489, -0.0010065072, 0.97935724, 0.0], [0.02580249, 0.0030739307, 0.023323178, 1.0]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.9793508, 0.003565142, 0.20213717, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.0036949096, 0.9999932, 0.00026499433, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.20213489, -0.0010065072, 0.97935724, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.02580249, 0.0030739307, 0.023323178, 1.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
    ▿ 26 : 2 elements
      - key : littleFingerIntermediateTip
      ▿ value : name: littleFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(0.88870054, 0.12715515, 0.44050294)
        - name : littleFingerIntermediateTip
        - isTracked : true
        ▿ transform : simd_float4x4([[0.88870054, 0.12715515, 0.44050294, 0.0], [-0.15881474, 0.9866667, 0.0355933, 0.0], [-0.43010366, -0.10159019, 0.8970453, 0.0], [0.11981387, 0.020798622, 0.05573114, 0.9999999]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.88870054, 0.12715515, 0.44050294, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(-0.15881474, 0.9866667, 0.0355933, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.43010366, -0.10159019, 0.8970453, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.11981387, 0.020798622, 0.05573114, 0.9999999)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
        ▿ transformToParent : simd_float4x4([[0.99017787, -0.139793, 0.002388811, 0.0], [0.13979378, 0.99018073, -0.00014644142, 0.0], [-0.0023448132, 0.0004790188, 0.99999726, 0.0], [0.017573759, 1.1260156e-05, -1.560196e-05, 0.9999999]])
          ▿ columns : 4 elements
            ▿ .0 : SIMD4<Float>(0.99017787, -0.139793, 0.002388811, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .1 : SIMD4<Float>(0.13979378, 0.99018073, -0.00014644142, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .2 : SIMD4<Float>(-0.0023448132, 0.0004790188, 0.99999726, 0.0)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
            ▿ .3 : SIMD4<Float>(0.017573759, 1.1260156e-05, -1.560196e-05, 0.9999999)
              ▿ _storage : SIMD4Storage
                - _value : (Opaque Value)
*/
 
/*
 po rightHandVector?.allJoints
 ▿ Optional<Dictionary<NameCodingKey, HVJointInfo>>
   ▿ some : 27 elements
     ▿ 0 : 2 elements
       - key : middleFingerMetacarpal
       ▿ value : name: middleFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.9999442, 0.00086713576, 0.010529585)
         - name : middleFingerMetacarpal
         - isTracked : true
         ▿ transform : simd_float4x4([[0.9999442, 0.00086713576, 0.010529585, 0.0], [-0.00090474024, 0.9999931, 0.0035718984, 0.0], [-0.010526303, -0.0035812703, 0.9999382, 0.0], [-0.026538067, 1.8328428e-06, 0.004146248, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9999442, 0.00086713576, 0.010529585, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.00090474024, 0.9999931, 0.0035718984, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.010526303, -0.0035812703, 0.9999382, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.026538067, 1.8328428e-06, 0.004146248, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9999442, 0.00086713576, 0.010529585, 0.0], [-0.00090474024, 0.9999931, 0.0035718984, 0.0], [-0.010526303, -0.0035812703, 0.9999382, 0.0], [-0.026538067, 1.8328428e-06, 0.004146248, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9999442, 0.00086713576, 0.010529585, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.00090474024, 0.9999931, 0.0035718984, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.010526303, -0.0035812703, 0.9999382, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.026538067, 1.8328428e-06, 0.004146248, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 1 : 2 elements
       - key : littleFingerTip
       ▿ value : name: littleFingerTip, isTracked: true, position: SIMD3<Float>(0.9029559, 0.16792677, 0.3955643)
         - name : littleFingerTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.9029559, 0.16792677, 0.3955643, 0.0], [-0.19458152, 0.9804884, 0.027930511, 0.0], [-0.38315594, -0.10218959, 0.91801316, 0.0], [-0.13393095, -0.02607797, -0.06069914, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9029559, 0.16792677, 0.3955643, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.19458152, 0.9804884, 0.027930511, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.38315594, -0.10218959, 0.91801316, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.13393095, -0.02607797, -0.06069914, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.99999994, 3.5384435e-09, -1.75199e-07, 0.0], [5.7652876e-08, 1.0, 8.72204e-08, 0.0], [7.4516095e-08, -1.2786957e-07, 0.9999999, 0.0], [-0.018767357, -1.1090744e-08, -1.3049892e-06, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.99999994, 3.5384435e-09, -1.75199e-07, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(5.7652876e-08, 1.0, 8.72204e-08, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(7.4516095e-08, -1.2786957e-07, 0.9999999, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.018767357, -1.1090744e-08, -1.3049892e-06, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 2 : 2 elements
       - key : middleFingerIntermediateTip
       ▿ value : name: middleFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(-0.9876994, -0.14010234, -0.06943542)
         - name : middleFingerIntermediateTip
         - isTracked : true
         ▿ transform : simd_float4x4([[-0.9876994, -0.14010234, -0.06943542, 0.0], [0.14702743, -0.9832821, -0.10741902, 0.0], [-0.053224847, -0.116306655, 0.99178606, 0.0], [-0.07487145, -0.045250233, 0.0008185801, 0.99999976]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(-0.9876994, -0.14010234, -0.06943542, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.14702743, -0.9832821, -0.10741902, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.053224847, -0.116306655, 0.99178606, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.07487145, -0.045250233, 0.0008185801, 0.99999976)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9717319, 0.23600511, 0.0062167943, 0.0], [-0.23599827, 0.9717516, -0.0018225368, 0.0], [-0.0064713564, 0.0003038496, 0.99997896, 0.0], [-0.028671589, 1.6912818e-06, 1.0343501e-06, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9717319, 0.23600511, 0.0062167943, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.23599827, 0.9717516, -0.0018225368, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.0064713564, 0.0003038496, 0.99997896, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.028671589, 1.6912818e-06, 1.0343501e-06, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 3 : 2 elements
       - key : ringFingerTip
       ▿ value : name: ringFingerTip, isTracked: true, position: SIMD3<Float>(-0.9898095, -0.12299492, -0.07175805)
         - name : ringFingerTip
         - isTracked : true
         ▿ transform : simd_float4x4([[-0.9898095, -0.12299492, -0.07175805, 0.0], [0.114558086, -0.98711103, 0.11175038, 0.0], [-0.08457789, 0.10239107, 0.99114203, 0.0], [-0.050817974, -0.039353605, -0.013392778, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(-0.9898095, -0.12299492, -0.07175805, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.114558086, -0.98711103, 0.11175038, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.08457789, 0.10239107, 0.99114203, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.050817974, -0.039353605, -0.013392778, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.99999994, 1.7055115e-08, -7.93523e-09, 0.0], [-5.3404545e-08, 1.0, 3.0161985e-07, 0.0], [8.344501e-08, -2.7994247e-07, 0.99999994, 0.0], [-0.019539865, 2.8945506e-06, 1.1111479e-06, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.99999994, 1.7055115e-08, -7.93523e-09, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-5.3404545e-08, 1.0, 3.0161985e-07, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(8.344501e-08, -2.7994247e-07, 0.99999994, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.019539865, 2.8945506e-06, 1.1111479e-06, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 4 : 2 elements
       - key : thumbTip
       ▿ value : name: thumbTip, isTracked: true, position: SIMD3<Float>(0.58113176, -0.07159061, -0.810654)
         - name : thumbTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.58113176, -0.07159061, -0.810654, 0.0], [0.8017906, 0.22092882, 0.5552672, 0.0], [0.13934499, -0.9726586, 0.18578957, 0.0], [-0.102334894, -0.016525509, 0.09023795, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.58113176, -0.07159061, -0.810654, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.8017906, 0.22092882, 0.5552672, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.13934499, -0.9726586, 0.18578957, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.102334894, -0.016525509, 0.09023795, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[1.0000001, 2.3871763e-07, -2.0675786e-07, 0.0], [-3.1544823e-07, 1.0, -5.5363953e-09, 0.0], [1.9908407e-07, 6.7646766e-08, 1.0000001, 0.0], [-0.028431665, 3.1782366e-07, -3.580739e-06, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(1.0000001, 2.3871763e-07, -2.0675786e-07, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-3.1544823e-07, 1.0, -5.5363953e-09, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(1.9908407e-07, 6.7646766e-08, 1.0000001, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.028431665, 3.1782366e-07, -3.580739e-06, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 5 : 2 elements
       - key : littleFingerIntermediateTip
       ▿ value : name: littleFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(0.9029558, 0.16792679, 0.39556447)
         - name : littleFingerIntermediateTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.9029558, 0.16792679, 0.39556447, 0.0], [-0.19458158, 0.9804885, 0.027930394, 0.0], [-0.38315612, -0.102189496, 0.9180133, 0.0], [-0.11698536, -0.022926554, -0.053274244, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9029558, 0.16792679, 0.39556447, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.19458158, 0.9804885, 0.027930394, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.38315612, -0.102189496, 0.9180133, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.11698536, -0.022926554, -0.053274244, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.988101, -0.15380569, 7.148045e-05, 0.0], [0.15380566, 0.988101, 0.00027579168, 0.0], [-0.00011306721, -0.00026145758, 1.0, 0.0], [-0.017343735, 3.5332894e-07, -1.0260637e-06, 1.0000001]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.988101, -0.15380569, 7.148045e-05, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.15380566, 0.988101, 0.00027579168, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.00011306721, -0.00026145758, 1.0, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.017343735, 3.5332894e-07, -1.0260637e-06, 1.0000001)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 6 : 2 elements
       - key : littleFingerKnuckle
       ▿ value : name: littleFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.8015318, 0.45714515, 0.38544086)
         - name : littleFingerKnuckle
         - isTracked : true
         ▿ transform : simd_float4x4([[0.8015318, 0.45714515, 0.38544086, 0.0], [-0.45885265, 0.8835543, -0.09373081, 0.0], [-0.38340655, -0.10173236, 0.9179592, 0.0], [-0.076787725, -0.0030384362, -0.034280535, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.8015318, 0.45714515, 0.38544086, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.45885265, 0.8835543, -0.09373081, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.38340655, -0.10173236, 0.9179592, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.076787725, -0.0030384362, -0.034280535, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.8646732, 0.45687398, 0.20882004, 0.0], [-0.46736056, 0.8840659, 0.0009938546, 0.0], [-0.18415664, -0.09845363, 0.97795326, 0.0], [-0.052242026, 5.176291e-06, -8.938834e-06, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.8646732, 0.45687398, 0.20882004, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.46736056, 0.8840659, 0.0009938546, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.18415664, -0.09845363, 0.97795326, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.052242026, 5.176291e-06, -8.938834e-06, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 7 : 2 elements
       - key : middleFingerIntermediateBase
       ▿ value : name: middleFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(-0.99413276, 0.09666363, -0.048540063)
         - name : middleFingerIntermediateBase
         - isTracked : true
         ▿ transform : simd_float4x4([[-0.99413276, 0.09666363, -0.048540063, 0.0], [-0.090244144, -0.98860645, -0.12047038, 0.0], [-0.059632067, -0.11538315, 0.9915294, 0.0], [-0.103374615, -0.042476952, -0.00057396246, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(-0.99413276, 0.09666363, -0.048540063, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.090244144, -0.98860645, -0.12047038, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.059632067, -0.11538315, 0.9915294, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.103374615, -0.042476952, -0.00057396246, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[-0.21885553, 0.97574824, -0.0042159213, 0.0], [-0.97501516, -0.21885553, -0.038050976, 0.0], [-0.038050864, -0.004216989, 0.9992669, 0.0], [-0.04479779, 8.63957e-07, 1.5386231e-06, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(-0.21885553, 0.97574824, -0.0042159213, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.97501516, -0.21885553, -0.038050976, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.038050864, -0.004216989, 0.9992669, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.04479779, 8.63957e-07, 1.5386231e-06, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 8 : 2 elements
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
     ▿ 9 : 2 elements
       - key : ringFingerIntermediateBase
       ▿ value : name: ringFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(-0.9924118, 0.080848224, -0.092640854)
         - name : ringFingerIntermediateBase
         - isTracked : true
         ▿ transform : simd_float4x4([[-0.9924118, 0.080848224, -0.092640854, 0.0], [-0.08967011, -0.9913925, 0.095392734, 0.0], [-0.08413106, 0.10297594, 0.9911194, 0.0], [-0.09584141, -0.03965922, -0.017196298, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(-0.9924118, 0.080848224, -0.092640854, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.08967011, -0.9913925, 0.095392734, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.08413106, 0.10297594, 0.9911194, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.09584141, -0.03965922, -0.017196298, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[-0.16256681, 0.9866869, -0.00458378, 0.0], [-0.98658454, -0.16247603, 0.015897237, 0.0], [0.014940825, 0.007106641, 0.99986327, 0.0], [-0.039431915, -9.0152025e-07, -1.0444783e-06, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(-0.16256681, 0.9866869, -0.00458378, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.98658454, -0.16247603, 0.015897237, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.014940825, 0.007106641, 0.99986327, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.039431915, -9.0152025e-07, -1.0444783e-06, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 10 : 2 elements
       - key : middleFingerTip
       ▿ value : name: middleFingerTip, isTracked: true, position: SIMD3<Float>(-0.9876991, -0.14010224, -0.069435336)
         - name : middleFingerTip
         - isTracked : true
         ▿ transform : simd_float4x4([[-0.9876991, -0.14010224, -0.069435336, 0.0], [0.14702727, -0.9832819, -0.10741915, 0.0], [-0.053224806, -0.11630675, 0.99178576, 0.0], [-0.053833794, -0.04226787, 0.0022971332, 0.99999964]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(-0.9876991, -0.14010224, -0.069435336, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.14702727, -0.9832819, -0.10741915, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.053224806, -0.11630675, 0.99178576, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.053833794, -0.04226787, 0.0022971332, 0.99999964)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.99999976, -1.0485122e-07, 5.2104618e-08, 0.0], [1.4875263e-07, 0.9999998, -1.4627689e-07, 0.0], [-1.902183e-09, 1.3622106e-07, 0.9999997, 0.0], [-0.021299371, 1.7894118e-06, -1.8696987e-07, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.99999976, -1.0485122e-07, 5.2104618e-08, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(1.4875263e-07, 0.9999998, -1.4627689e-07, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-1.902183e-09, 1.3622106e-07, 0.9999997, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.021299371, 1.7894118e-06, -1.8696987e-07, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 11 : 2 elements
       - key : littleFingerIntermediateBase
       ▿ value : name: littleFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(0.8623273, 0.31674486, 0.3950498)
         - name : littleFingerIntermediateBase
         - isTracked : true
         ▿ transform : simd_float4x4([[0.8623273, 0.31674486, 0.3950498, 0.0], [-0.3310458, 0.9430203, -0.03348209, 0.0], [-0.38314515, -0.10190712, 0.91804916, 0.0], [-0.102029644, -0.01743345, -0.046421643, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.8623273, 0.31674486, 0.3950498, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.3310458, 0.9430203, -0.03348209, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.38314515, -0.10190712, 0.91804916, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.102029644, -0.01743345, -0.046421643, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9882499, -0.15284821, -0.00020553592, 0.0], [0.1528482, 0.9882498, 0.00025428282, 0.0], [0.00016427606, -0.00028277052, 1.0000001, 0.0], [-0.031492513, 1.5422702e-06, -2.687797e-06, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9882499, -0.15284821, -0.00020553592, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.1528482, 0.9882498, 0.00025428282, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.00016427606, -0.00028277052, 1.0000001, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.031492513, 1.5422702e-06, -2.687797e-06, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 12 : 2 elements
       - key : indexFingerMetacarpal
       ▿ value : name: indexFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.9861519, 0.00074442266, -0.16584264)
         - name : indexFingerMetacarpal
         - isTracked : true
         ▿ transform : simd_float4x4([[0.9861519, 0.00074442266, -0.16584264, 0.0], [-9.445756e-05, 0.9999921, 0.003927007, 0.0], [0.16584441, -0.0038569893, 0.9861442, 0.0], [-0.024701215, 1.296401e-06, 0.016812354, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9861519, 0.00074442266, -0.16584264, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-9.445756e-05, 0.9999921, 0.003927007, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.16584441, -0.0038569893, 0.9861442, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.024701215, 1.296401e-06, 0.016812354, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9861519, 0.00074442266, -0.16584264, 0.0], [-9.445756e-05, 0.9999921, 0.003927007, 0.0], [0.16584441, -0.0038569893, 0.9861442, 0.0], [-0.024701215, 1.296401e-06, 0.016812354, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9861519, 0.00074442266, -0.16584264, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-9.445756e-05, 0.9999921, 0.003927007, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.16584441, -0.0038569893, 0.9861442, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.024701215, 1.296401e-06, 0.016812354, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 13 : 2 elements
       - key : ringFingerIntermediateTip
       ▿ value : name: ringFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(-0.9898096, -0.12299491, -0.071758054)
         - name : ringFingerIntermediateTip
         - isTracked : true
         ▿ transform : simd_float4x4([[-0.9898096, -0.12299491, -0.071758054, 0.0], [0.11455806, -0.98711103, 0.11175009, 0.0], [-0.08457778, 0.1023908, 0.9911421, 0.0], [-0.07015896, -0.041754168, -0.014796346, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(-0.9898096, -0.12299491, -0.071758054, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.11455806, -0.98711103, 0.11175009, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.08457778, 0.1023908, 0.9911421, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.07015896, -0.041754168, -0.014796346, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9790026, 0.20384735, -0.0005125167, 0.0], [-0.20384765, 0.97900254, -0.0005289638, 0.0], [0.00039390917, 0.0006223175, 0.9999998, 0.0], [-0.025879275, 2.9057264e-06, 2.2148597e-06, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9790026, 0.20384735, -0.0005125167, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.20384765, 0.97900254, -0.0005289638, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.00039390917, 0.0006223175, 0.9999998, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.025879275, 2.9057264e-06, 2.2148597e-06, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 14 : 2 elements
       - key : forearmWrist
       ▿ value : name: forearmWrist, isTracked: true, position: SIMD3<Float>(-0.94585955, -0.31127673, 0.091957845)
         - name : forearmWrist
         - isTracked : true
         ▿ transform : simd_float4x4([[-0.94585955, -0.31127673, 0.091957845, 0.0], [-0.31271198, 0.9498469, -0.0012651789, 0.0], [-0.08695206, -0.029952977, -0.995762, 0.0], [-1.8626451e-08, 0.0, 5.9604645e-08, 1.0000001]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(-0.94585955, -0.31127673, 0.091957845, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.31271198, 0.9498469, -0.0012651789, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.08695206, -0.029952977, -0.995762, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-1.8626451e-08, 0.0, 5.9604645e-08, 1.0000001)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[-0.94585955, -0.31127673, 0.091957845, 0.0], [-0.31271198, 0.9498469, -0.0012651789, 0.0], [-0.08695206, -0.029952977, -0.995762, 0.0], [-1.8626451e-08, 0.0, 5.9604645e-08, 1.0000001]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(-0.94585955, -0.31127673, 0.091957845, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.31271198, 0.9498469, -0.0012651789, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.08695206, -0.029952977, -0.995762, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-1.8626451e-08, 0.0, 5.9604645e-08, 1.0000001)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 15 : 2 elements
       - key : thumbIntermediateBase
       ▿ value : name: thumbIntermediateBase, isTracked: true, position: SIMD3<Float>(0.8761131, 0.037868503, -0.4806159)
         - name : thumbIntermediateBase
         - isTracked : true
         ▿ transform : simd_float4x4([[0.8761131, 0.037868503, -0.4806159, 0.0], [0.4606295, 0.22847758, 0.85768193, 0.0], [0.14228916, -0.9728123, 0.18272887, 0.0], [-0.05899613, -0.017409194, 0.052482367, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.8761131, 0.037868503, -0.4806159, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.4606295, 0.22847758, 0.85768193, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.14228916, -0.9728123, 0.18272887, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.05899613, -0.017409194, 0.052482367, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.96552956, 0.2177919, 0.1425458, 0.0], [-0.21807942, 0.97583354, -0.013796194, 0.0], [-0.14210568, -0.017765636, 0.9896921, 0.0], [-0.049324136, -1.9208528e-06, -1.7741695e-06, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.96552956, 0.2177919, 0.1425458, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.21807942, 0.97583354, -0.013796194, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.14210568, -0.017765636, 0.9896921, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.049324136, -1.9208528e-06, -1.7741695e-06, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 16 : 2 elements
       - key : forearmArm
       ▿ value : name: forearmArm, isTracked: true, position: SIMD3<Float>(-0.94585955, -0.3112767, 0.09195787)
         - name : forearmArm
         - isTracked : true
         ▿ transform : simd_float4x4([[-0.94585955, -0.3112767, 0.09195787, 0.0], [-0.31271198, 0.9498469, -0.0012651861, 0.0], [-0.086952046, -0.029952975, -0.995762, 0.0], [0.25312164, 0.08314032, -0.024463814, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(-0.94585955, -0.3112767, 0.09195787, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.31271198, 0.9498469, -0.0012651861, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.086952046, -0.029952975, -0.995762, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(0.25312164, 0.08314032, -0.024463814, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[1.0, 2.5125715e-08, -2.0657343e-08, 0.0], [1.0286044e-08, 1.0, 8.196196e-09, 0.0], [-1.538628e-08, -3.6441676e-09, 1.0, 0.0], [-0.26754692, -0.0001526475, -0.00013956428, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(1.0, 2.5125715e-08, -2.0657343e-08, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(1.0286044e-08, 1.0, 8.196196e-09, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-1.538628e-08, -3.6441676e-09, 1.0, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.26754692, -0.0001526475, -0.00013956428, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 17 : 2 elements
       - key : middleFingerKnuckle
       ▿ value : name: middleFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.30782986, 0.9471412, 0.09035516)
         - name : middleFingerKnuckle
         - isTracked : true
         ▿ transform : simd_float4x4([[0.30782986, 0.9471412, 0.09035516, 0.0], [-0.9500213, 0.31116787, -0.025178628, 0.0], [-0.051963195, -0.07808866, 0.99559116, 0.0], [-0.08958363, -4.7266487e-05, 0.0034722388, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.30782986, 0.9471412, 0.09035516, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.9500213, 0.31116787, -0.025178628, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.051963195, -0.07808866, 0.99559116, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.08958363, -4.7266487e-05, 0.0034722388, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.30958533, 0.9471791, 0.0837173, 0.0], [-0.94996357, 0.31193542, -0.016291115, 0.0], [-0.041544955, -0.07448493, 0.99635625, 0.0], [-0.063049175, 5.53656e-06, -1.0147691e-05, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.30958533, 0.9471791, 0.0837173, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.94996357, 0.31193542, -0.016291115, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.041544955, -0.07448493, 0.99635625, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.063049175, 5.53656e-06, -1.0147691e-05, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 18 : 2 elements
       - key : indexFingerKnuckle
       ▿ value : name: indexFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.9258143, 0.26269335, 0.2717729)
         - name : indexFingerKnuckle
         - isTracked : true
         ▿ transform : simd_float4x4([[0.9258143, 0.26269335, 0.2717729, 0.0], [-0.2804449, 0.95946324, 0.027946813, 0.0], [-0.25341457, -0.10209087, 0.96195555, 0.0], [-0.090376034, -4.2065978e-05, 0.027846042, 1.0000001]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9258143, 0.26269335, 0.2717729, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.2804449, 0.95946324, 0.027946813, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.25341457, -0.10209087, 0.96195555, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.090376034, -4.2065978e-05, 0.027846042, 1.0000001)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.8681176, 0.2636712, 0.4205352, 0.0], [-0.28048182, 0.9595923, -0.022651207, 0.0], [-0.40951473, -0.098288536, 0.9069937, 0.0], [-0.06659524, 6.1709434e-06, -1.0819174e-05, 1.0000001]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.8681176, 0.2636712, 0.4205352, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.28048182, 0.9595923, -0.022651207, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.40951473, -0.098288536, 0.9069937, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.06659524, 6.1709434e-06, -1.0819174e-05, 1.0000001)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 19 : 2 elements
       - key : indexFingerIntermediateTip
       ▿ value : name: indexFingerIntermediateTip, isTracked: true, position: SIMD3<Float>(0.9664695, 0.01869845, 0.25609908)
         - name : indexFingerIntermediateTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.9664695, 0.01869845, 0.25609908, 0.0], [-0.044387434, 0.9944968, 0.094898894, 0.0], [-0.25291526, -0.10308447, 0.9619809, 0.0], [-0.15196612, -0.015118972, 0.010034628, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9664695, 0.01869845, 0.25609908, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.044387434, 0.9944968, 0.094898894, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.25291526, -0.10308447, 0.9619809, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.15196612, -0.015118972, 0.010034628, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.98832387, -0.15236665, 0.00025142985, 0.0], [0.15236636, 0.9883237, 0.0007254151, 0.0], [-0.00035907945, -0.00067859364, 0.99999964, 0.0], [-0.024190504, 3.3387914e-07, -8.3955274e-07, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.98832387, -0.15236665, 0.00025142985, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.15236636, 0.9883237, 0.0007254151, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.00035907945, -0.00067859364, 0.99999964, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.024190504, 3.3387914e-07, -8.3955274e-07, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 20 : 2 elements
       - key : indexFingerIntermediateBase
       ▿ value : name: indexFingerIntermediateBase, isTracked: true, position: SIMD3<Float>(0.9485129, 0.17004511, 0.26722294)
         - name : indexFingerIntermediateBase
         - isTracked : true
         ▿ transform : simd_float4x4([[0.9485129, 0.17004511, 0.26722294, 0.0], [-0.1909552, 0.9801059, 0.054117065, 0.0], [-0.25270435, -0.10235835, 0.96211386, 0.0], [-0.12902129, -0.011005912, 0.016499676, 1.0000001]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9485129, 0.17004511, 0.26722294, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.1909552, 0.9801059, 0.054117065, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.25270435, -0.10235835, 0.96211386, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.12902129, -0.011005912, 0.016499676, 1.0000001)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.99544007, -0.09538545, -0.0006704812, 0.0], [0.09538582, 0.9954403, 0.0003892093, 0.0], [0.0006303261, -0.0004514026, 0.9999996, 0.0], [-0.04174207, 1.3575035e-06, -2.1210774e-06, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.99544007, -0.09538545, -0.0006704812, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.09538582, 0.9954403, 0.0003892093, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.0006303261, -0.0004514026, 0.9999996, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.04174207, 1.3575035e-06, -2.1210774e-06, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 21 : 2 elements
       - key : littleFingerMetacarpal
       ▿ value : name: littleFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.9781202, 0.0010774009, 0.20803829)
         - name : littleFingerMetacarpal
         - isTracked : true
         ▿ transform : simd_float4x4([[0.9781202, 0.0010774009, 0.20803829, 0.0], [-0.0017092295, 0.9999944, 0.0028572243, 0.0], [-0.20803396, -0.0031503232, 0.97811645, 0.0], [-0.025690593, -0.002987355, -0.023403466, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9781202, 0.0010774009, 0.20803829, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.0017092295, 0.9999944, 0.0028572243, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.20803396, -0.0031503232, 0.97811645, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.025690593, -0.002987355, -0.023403466, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9781202, 0.0010774009, 0.20803829, 0.0], [-0.0017092295, 0.9999944, 0.0028572243, 0.0], [-0.20803396, -0.0031503232, 0.97811645, 0.0], [-0.025690593, -0.002987355, -0.023403466, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9781202, 0.0010774009, 0.20803829, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.0017092295, 0.9999944, 0.0028572243, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.20803396, -0.0031503232, 0.97811645, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.025690593, -0.002987355, -0.023403466, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 22 : 2 elements
       - key : thumbIntermediateTip
       ▿ value : name: thumbIntermediateTip, isTracked: true, position: SIMD3<Float>(0.5811316, -0.07159085, -0.81065404)
         - name : thumbIntermediateTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.5811316, -0.07159085, -0.81065404, 0.0], [0.80179083, 0.22092882, 0.555267, 0.0], [0.1393448, -0.97265846, 0.18578967, 0.0], [-0.08581211, -0.01856451, 0.06719019, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.5811316, -0.07159085, -0.81065404, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.80179083, 0.22092882, 0.555267, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.1393448, -0.97265846, 0.18578967, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.08581211, -0.01856451, 0.06719019, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.8960393, -0.443954, 0.004203284, 0.0], [0.44395554, 0.89604837, 0.0006271255, 0.0], [-0.004044848, 0.0013040766, 0.9999907, 0.0], [-0.030606404, -1.5543774e-06, -4.1704625e-06, 0.9999999]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.8960393, -0.443954, 0.004203284, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.44395554, 0.89604837, 0.0006271255, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.004044848, 0.0013040766, 0.9999907, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.030606404, -1.5543774e-06, -4.1704625e-06, 0.9999999)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 23 : 2 elements
       - key : ringFingerKnuckle
       ▿ value : name: ringFingerKnuckle, isTracked: true, position: SIMD3<Float>(0.24854329, 0.9664876, -0.064244494)
         - name : ringFingerKnuckle
         - isTracked : true
         ▿ transform : simd_float4x4([[0.24854329, 0.9664876, -0.064244494, 0.0], [-0.9652284, 0.24158125, -0.099863015, 0.0], [-0.08099605, 0.08683086, 0.9929247, 0.0], [-0.08604182, -0.0015484539, -0.019728635, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.24854329, 0.9664876, -0.064244494, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.9652284, 0.24158125, -0.099863015, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.08099605, 0.08683086, 0.9929247, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.08604182, -0.0015484539, -0.019728635, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.23364514, 0.9658771, -0.11176546, 0.0], [-0.96693, 0.2428983, 0.07776477, 0.0], [0.10225885, 0.08989994, 0.9906874, 0.0], [-0.060420193, 5.4457923e-06, -9.751646e-06, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.23364514, 0.9658771, -0.11176546, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.96693, 0.2428983, 0.07776477, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.10225885, 0.08989994, 0.9906874, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.060420193, 5.4457923e-06, -9.751646e-06, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 24 : 2 elements
       - key : indexFingerTip
       ▿ value : name: indexFingerTip, isTracked: true, position: SIMD3<Float>(0.96646947, 0.018698163, 0.25609913)
         - name : indexFingerTip
         - isTracked : true
         ▿ transform : simd_float4x4([[0.96646947, 0.018698163, 0.25609913, 0.0], [-0.04438715, 0.99449676, 0.09489884, 0.0], [-0.25291535, -0.103084326, 0.9619809, 0.0], [-0.17293015, -0.015524511, 0.0044786967, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.96646947, 0.018698163, 0.25609913, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.04438715, 0.99449676, 0.09489884, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.25291535, -0.103084326, 0.9619809, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.17293015, -0.015524511, 0.0044786967, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.99999994, -2.6142385e-07, 1.16675494e-07, 0.0], [2.8487457e-07, 0.99999994, -1.1897476e-07, 0.0], [-9.856231e-08, 1.4617609e-07, 1.0, 0.0], [-0.021691563, -1.7901643e-08, -7.7210916e-07, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.99999994, -2.6142385e-07, 1.16675494e-07, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(2.8487457e-07, 0.99999994, -1.1897476e-07, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-9.856231e-08, 1.4617609e-07, 1.0, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.021691563, -1.7901643e-08, -7.7210916e-07, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 25 : 2 elements
       - key : thumbKnuckle
       ▿ value : name: thumbKnuckle, isTracked: true, position: SIMD3<Float>(0.7252393, 0.12497907, -0.6770584)
         - name : thumbKnuckle
         - isTracked : true
         ▿ transform : simd_float4x4([[0.7252393, 0.12497907, -0.6770584, 0.0], [0.63778025, 0.24848619, 0.7290342, 0.0], [0.25935376, -0.9605387, 0.10050275, 0.0], [-0.02322264, -0.011245936, 0.019088626, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.7252393, 0.12497907, -0.6770584, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.63778025, 0.24848619, 0.7290342, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.25935376, -0.9605387, 0.10050275, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.02322264, -0.011245936, 0.019088626, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.7252393, 0.12497907, -0.6770584, 0.0], [0.63778025, 0.24848619, 0.7290342, 0.0], [0.25935376, -0.9605387, 0.10050275, 0.0], [-0.02322264, -0.011245936, 0.019088626, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.7252393, 0.12497907, -0.6770584, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(0.63778025, 0.24848619, 0.7290342, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(0.25935376, -0.9605387, 0.10050275, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.02322264, -0.011245936, 0.019088626, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
     ▿ 26 : 2 elements
       - key : ringFingerMetacarpal
       ▿ value : name: ringFingerMetacarpal, isTracked: true, position: SIMD3<Float>(0.9830961, 0.0011023046, 0.18308538)
         - name : ringFingerMetacarpal
         - isTracked : true
         ▿ transform : simd_float4x4([[0.9830961, 0.0011023046, 0.18308538, 0.0], [-0.0016715176, 0.99999386, 0.002955073, 0.0], [-0.18308103, -0.003211151, 0.9830921, 0.0], [-0.026644744, -0.0014873296, -0.008657008, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9830961, 0.0011023046, 0.18308538, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.0016715176, 0.99999386, 0.002955073, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.18308103, -0.003211151, 0.9830921, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.026644744, -0.0014873296, -0.008657008, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
         ▿ transformToParent : simd_float4x4([[0.9830961, 0.0011023046, 0.18308538, 0.0], [-0.0016715176, 0.99999386, 0.002955073, 0.0], [-0.18308103, -0.003211151, 0.9830921, 0.0], [-0.026644744, -0.0014873296, -0.008657008, 1.0]])
           ▿ columns : 4 elements
             ▿ .0 : SIMD4<Float>(0.9830961, 0.0011023046, 0.18308538, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .1 : SIMD4<Float>(-0.0016715176, 0.99999386, 0.002955073, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .2 : SIMD4<Float>(-0.18308103, -0.003211151, 0.9830921, 0.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
             ▿ .3 : SIMD4<Float>(-0.026644744, -0.0014873296, -0.008657008, 1.0)
               ▿ _storage : SIMD4Storage
                 - _value : (Opaque Value)
 */
