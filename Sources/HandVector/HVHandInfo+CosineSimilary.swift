//
//  HandVectorMatcher+CosineSimilary.swift
//  HandVector
//
//  Created by 许同学 on 2024/8/20.
//

import ARKit

public extension HVHandInfo {
    /// Fingers  joint your selected
    func similarity(of joints: Set<HandSkeleton.JointName>, to vector: HVHandInfo) -> Float {
        var similarity: Float = 0
        similarity = joints.map { name in
            let dv = dot(vector.vectorEndTo(name).normalizedVector, self.vectorEndTo(name).normalizedVector)
            return dv
        }.reduce(0) { $0 + $1 }
        
        similarity /= Float(joints.count)
        return similarity
    }
    /// Fingers and wrist and forearm
    func similarity(to vector: HVHandInfo) -> Float {
        return similarity(of: .all, to: vector)
    }
    /// Finger your selected
    func similarity(of finger: HVJointOfFinger, to vector: HVHandInfo) -> Float {
        return similarity(of: [finger], to: vector)
    }
    /// Fingers your selected
    func similarity(of fingers: Set<HVJointOfFinger>, to vector: HVHandInfo) -> Float {
        var similarity: Float = 0
        let jointNames = fingers.jointGroupNames
        similarity = jointNames.map { name in
            let dv = dot(vector.vectorEndTo(name).normalizedVector, self.vectorEndTo(name).normalizedVector)
            return dv
        }.reduce(0) { $0 + $1 }
        
        similarity /= Float(jointNames.count)
        return similarity
    }
    /// all
    func similarities(to vector: HVHandInfo) -> (average: Float, each: [HVJointOfFinger: Float]) {
        return averageAndEachSimilarities(of: .all, to: vector)
    }
    func averageAndEachSimilarities(of fingers: Set<HVJointOfFinger>, to vector: HVHandInfo) -> (average: Float, each: [HVJointOfFinger: Float]) {
        
        let fingerTotal = fingers.reduce(into: [HVJointOfFinger: Float]()) { partialResult, finger in
            let fingerResult = finger.jointGroupNames.reduce(into: Float.zero) { partialResult, name in
                let dv = dot(vector.vectorEndTo(name).normalizedVector, self.vectorEndTo(name).normalizedVector)
                partialResult += dv
            }
            partialResult[finger] = fingerResult
        }
        let fingerScore = fingerTotal.reduce(into: [HVJointOfFinger: Float]()) { partialResult, ele in
            partialResult[ele.key]  = ele.value / Float(ele.key.jointGroupNames.count)
        }
        
        let jointTotal = fingerTotal.reduce(into: Float.zero) { partialResult, element in
            partialResult += element.value
        }
        let jointCount = fingers.jointGroupNames.count
        return (average: jointTotal / Float(jointCount), each: fingerScore)
    }
}
