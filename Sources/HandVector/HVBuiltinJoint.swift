//
//  HVBuiltinJoint.swift
//  HandVector
//
//  Created by 许同学 on 2024/8/5.
//

import ARKit
import simd

public struct HVBuiltinJoint: Sendable, Hashable, Codable {
    public let name: HandSkeleton.JointName.NameCodingKey
    public let isTracked: Bool
    public let anchorFromJointTransform: [SIMD4<Float>]
    
    /// The position of the joint to the hand anchor coordinate system.
    public var position: simd_float3 {
        return anchorFromJointTransform[3].xyz
    }
    /// The transform from the joint to the hand anchor coordinate system.
    public var transfrom: simd_float4x4 {
        return simd_float4x4.init(anchorFromJointTransform[0], anchorFromJointTransform[1], anchorFromJointTransform[2], anchorFromJointTransform[3])
    }
    public init(joint: HandSkeleton.Joint) {
        self.name = joint.name.codableName
        self.isTracked = joint.isTracked
        self.anchorFromJointTransform = [joint.anchorFromJointTransform.columns.0,
                                         joint.anchorFromJointTransform.columns.1,
                                         joint.anchorFromJointTransform.columns.2,
                                         joint.anchorFromJointTransform.columns.3]
    }
    public init(name: HandSkeleton.JointName.NameCodingKey, isTracked: Bool, anchorFromJointTransform: [SIMD4<Float>]) {
        self.name = name
        self.isTracked = isTracked
        self.anchorFromJointTransform = anchorFromJointTransform
    }
    
    public func reversedChirality() -> HVBuiltinJoint {
        let anchorTransfrom = [anchorFromJointTransform[0],
                               anchorFromJointTransform[1],
                               anchorFromJointTransform[2],
                               SIMD4<Float>(-anchorFromJointTransform[3].xyz, 1)]
        return HVBuiltinJoint(name: name, isTracked: isTracked, anchorFromJointTransform: anchorTransfrom)
    }
}

extension HVBuiltinJoint: CustomStringConvertible {
    public var description: String {
        return "name: \(name), isTracked: \(isTracked), position: \(position)"
    }
}
/*
 left:
 handAnchor.handSkeleton?.joint(.indexFingerIntermediateTip).parentFromJointTransform
 [[0.6656309, 0.746277, -0.002461793, 0.0],
 [-0.7462773, 0.6656343, 0.000990374, 0.0],
 [0.0023777161, 0.0011779641, 0.99999636, 0.0],
 [0.021942226, 1.3411045e-07, 4.9312075e-07, 1.0]]
 
 [[0.5986931, 0.8009064, -0.010774563, 0.0],
 [-0.8009584, 0.5987197, -0.0009092177, 0.0],
 [0.0057227705, 0.009174363, 0.9999418, 0.0],
 [0.022379857, -3.674615e-07, 3.014479e-07, 1.0]]
 
 handAnchor.handSkeleton?.joint(.indexFingerIntermediateTip).anchorFromJointTransform
 [[-0.6825175, 0.73084384, 0.006049945, 0.0],
 [-0.73058575, -0.68246007, 0.02217979, 0.0],
 [0.020338876, 0.010718084, 0.9997355, 0.0],
 [0.13273448, 0.013194998, -0.026966885, 1.0]]
 
 [[-0.78236026, 0.6197203, 0.062125813, 0.0],
 [-0.61789876, -0.7848222, 0.047493555, 0.0],
 [0.07819039, -0.001230381, 0.9969379, 0.0],
 [0.1314337, 0.013073427, -0.030047745, 0.9999998]]
 
 right:
 handAnchor.handSkeleton?.joint(.indexFingerIntermediateTip).parentFromJointTransform
 [[0.39271164, 0.91963494, -0.007025939, 0.0],
 [-0.9196497, 0.39273414, 0.0021145425, 0.0],
 [0.0047038808, 0.0056310724, 0.99997306, 0.0],
 [-0.023212196, 1.539677e-07, -6.5555224e-07, 1.0000001]]
 
 [[0.57699746, 0.8167459, 0.00044969306, 0.0],
 [-0.8167012, 0.5769716, -0.010130433, 0.0],
 [-0.008533456, 0.005478037, 0.9999485, 0.0],
 [-0.023570342, -2.2176653e-05, -6.288831e-05, 1.0]]
 
 handAnchor.handSkeleton?.joint(.indexFingerIntermediateTip).anchorFromJointTransform
 [[-0.99139166, 0.1237376, -0.042798396, 0.0],
 [-0.1239336, -0.99228877, 0.0019457763, 0.0],
 [-0.04222765, 0.007233185, 0.99908173, 0.0],
 [-0.12922701, -0.021457857, 0.023165166, 1.0000001]]
 
 [[-0.8466053, 0.5308479, -0.038206067, 0.0],
 [-0.5307958, -0.8474098, -0.012328863, 0.0],
 [-0.038920946, 0.009842006, 0.99919355, 0.0],
 [-0.1391792, -0.020037428, 0.028238086, 0.9999999]]
 */
