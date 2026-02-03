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
            let dv = dot(vector.vectorEndTo(name), self.vectorEndTo(name))
            return dv
        }.reduce(0) { $0 + $1 }
        
        similarity /= Float(joints.count)
        return similarity
    }
    
    /// Finger your selected
    func similarity(of finger: HVJointOfFinger, to vector: HVHandInfo, flexibleJointOnly: Bool = true) -> Float {
        return similarity(of: [finger], to: vector, flexibleJointOnly: flexibleJointOnly)
    }
    /// Fingers your selected
    func similarity(of fingers: Set<HVJointOfFinger>, to vector: HVHandInfo, flexibleJointOnly: Bool = true) -> Float {
        var similarity: Float = 0
        let jointNames = flexibleJointOnly ? fingers.flexibleJointGroupNames : fingers.jointGroupNames
        similarity = jointNames.map { name in
            let dv = dot(vector.vectorEndTo(name), self.vectorEndTo(name))
            return dv
        }.reduce(0) { $0 + $1 }
        
        similarity /= Float(jointNames.count)
        return similarity
    }
    /// Fingers and wrist and forearm
    func similarity(to vector: HVHandInfo, flexibleJointOnly: Bool = true) -> Float {
        return similarity(of: .all, to: vector, flexibleJointOnly: flexibleJointOnly)
    }
    /// all
    func similarities(to vector: HVHandInfo, flexibleJointOnly: Bool = true) -> (average: Float, eachFinger: [HVJointOfFinger: Float]) {
        return averageAndEachSimilarities(of: .all, to: vector, flexibleJointOnly: flexibleJointOnly)
    }
    func averageAndEachSimilarities(of fingers: Set<HVJointOfFinger>, to vector: HVHandInfo, flexibleJointOnly: Bool = true) -> (average: Float, eachFinger: [HVJointOfFinger: Float]) {
        let fingerTotal = fingers.reduce(into: [HVJointOfFinger: Float]()) { partialResult, finger in
            let jointNames = flexibleJointOnly ? finger.flexibleJointGroupNames : finger.jointGroupNames
            let fingerResult = jointNames.reduce(into: Float.zero) { partialResult, name in
                let dv = dot(vector.vectorEndTo(name), self.vectorEndTo(name))
                partialResult += dv
            }
            partialResult[finger] = fingerResult
        }
        let fingerScore = fingerTotal.reduce(into: [HVJointOfFinger: Float]()) { partialResult, ele in
            let jointNames = flexibleJointOnly ? ele.key.flexibleJointGroupNames : ele.key.jointGroupNames
            partialResult[ele.key]  = ele.value / Float(jointNames.count)
        }
        
        let jointTotal = fingerTotal.reduce(into: Float.zero) { partialResult, element in
            partialResult += element.value
        }
        let jointCount = flexibleJointOnly ? fingers.flexibleJointGroupNames.count : fingers.jointGroupNames.count
        return (average: jointTotal / Float(jointCount), eachFinger: fingerScore)
    }
    
}

