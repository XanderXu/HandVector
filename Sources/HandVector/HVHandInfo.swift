//
//  File.swift
//  HandVector
//
//  Created by 许同学 on 2024/8/5.
//

import RealityFoundation
import ARKit

public struct HVHandInfo: Codable {
    public let name: String
    public let left: [HVJointInfo]?
    public let right: [HVJointInfo]?
    
    public static func loadBulitin(fileName: String?, bundle: Bundle = handAssetsBundle) -> HVHandInfo? {
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel(HVHandInfo.self)
        } catch {
            print(error)
        }
        return nil
    }
    public static func loadBuiltinDict(fileName: String?, bundle: Bundle = handAssetsBundle) -> [String: HVHandInfo]? {
        guard let path = bundle.path(forResource: fileName, ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel([String: HVHandInfo].self)
        } catch {
            print(error)
        }
        return nil
    }
}

public extension HVHandInfo {
    static func generateParameters(name: String, leftHandVector: HandVectorMatcher?, rightHandVector: HandVectorMatcher?) -> HVHandInfo? {
        if leftHandVector == nil, rightHandVector == nil {
            return nil
        }
        var left: [HVJointInfo]? = nil
        var right: [HVJointInfo]? = nil
        if let leftHandVector {
            left = HandSkeleton.JointName.allCases.map { jointName in
                leftHandVector.allJoints[jointName.codableName]!
            }
        }
        if let rightHandVector {
            right = HandSkeleton.JointName.allCases.map { jointName in
                rightHandVector.allJoints[jointName.codableName]!
            }
        }

        return HVHandInfo(name: name, left: left, right: right)
    }
    
    func convertToHandVectorMatcher() -> (left: HandVectorMatcher?, right: HandVectorMatcher?) {
        var leftVector: HandVectorMatcher?
        if let left {
            let all = left.reduce(into: [HandSkeleton.JointName.NameCodingKey: HVJointInfo]()) {
                $0[$1.name] = $1
            }
            
            leftVector = HandVectorMatcher(chirality: .left, allJoints: all, transform: .init(diagonal: .one))
        }
        var rightVector: HandVectorMatcher?
        if let right {
            let all = right.reduce(into: [HandSkeleton.JointName.NameCodingKey: HVJointInfo]()) {
                $0[$1.name] = $1
            }
            rightVector = HandVectorMatcher(chirality: .right, allJoints: all, transform: .init(diagonal: .one))
        }
        return (left: leftVector, right: rightVector)
    }
    
}
