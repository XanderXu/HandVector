/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
Extensions and utilities.
*/

import ARKit

extension HandSkeleton.Joint {
    var localPosition: simd_float3 {
        return anchorFromJointTransform.columns.3.xyz
    }
}
extension simd_float4x4 {
    var float4Array: [SIMD4<Float>] {
        [columns.0, columns.1, columns.2, columns.3]
    }
    var positionReversed: simd_float4x4 {
        simd_float4x4(
            [columns.0,
             columns.1,
             columns.2,
             SIMD4<Float>(-columns.3.xyz, 1)]
        )
    }
}
extension SIMD4 {
    var xyz: SIMD3<Scalar> {
        self[SIMD3(0, 1, 2)]
    }
}

