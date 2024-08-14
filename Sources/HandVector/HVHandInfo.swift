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
    public let chirality: HandAnchor.Chirality.NameCodingKey
    public let joints: [HVJointInfo]
    
    public static func loadBulitin() -> HVHandInfo? {
        guard let path = handAssetsBundle.path(forResource: "BuiltinHand", ofType: "json") else {return nil}
        do {
            let jsonStr = try String(contentsOfFile: path, encoding: .utf8)
            return jsonStr.toModel(HVHandInfo.self)
        } catch {
            print(error)
        }
        return nil
    }
    public static func loadBuiltinDict() -> [String: HVHandInfo]? {
        guard let path = handAssetsBundle.path(forResource: "BuiltinHand", ofType: "json") else {return nil}
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
        var joints: [HVJointInfo] = []
        if let leftHandVector {
            joints = HandSkeleton.JointName.allCases.map { jointName in
                leftHandVector.allJoints[jointName.codableName]!
            }
            return HVHandInfo(name: name, chirality: .left, joints: joints)
        }
        if let rightHandVector {
            joints = HandSkeleton.JointName.allCases.map { jointName in
                rightHandVector.allJoints[jointName.codableName]!
            }
            return HVHandInfo(name: name, chirality: .right, joints: joints)
        }
    }
    
    func convertToHandVectorMatcher() -> (left: HandVectorMatcher?, right: HandVectorMatcher?) {
        if chirality == .left {
            let all = joints.reduce(into: [HandSkeleton.JointName.NameCodingKey: HVJointInfo]()) {
                $0[$1.name] = $1
            }
            
            let leftVector = HandVectorMatcher(chirality: .left, allJoints: all, transform: .init(diagonal: .one))
            
            return (left: leftVector, right: nil)
        } else {
            let all = joints.reduce(into: [HandSkeleton.JointName.NameCodingKey: HVJointInfo]()) {
                $0[$1.name] = $1
            }
            let rightVector = HandVectorMatcher(chirality: .right, allJoints: all, transform: .init(diagonal: .one))
            
            return (left: nil, right: rightVector)
        }
    }
    
}
