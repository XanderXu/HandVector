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
extension SIMD4 {
    var xyz: SIMD3<Scalar> {
        self[SIMD3(0, 1, 2)]
    }
}

