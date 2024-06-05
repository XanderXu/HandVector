//
//  VisionSimHands.swift
//  HandsTest
//
//  Created by Ben Harraway on 17/12/2023.
//

import Foundation
import RealityKit
#if canImport(ARKit)
import ARKit


public struct SimHand: Codable {
    public let landmarks: [[Landmark]]
    public let worldLandmarks: [[Landmark]]
    public let handednesses: [[Handedness]]
    
    // MARK: - Handedness
    public struct Handedness: Codable {
        let score: Double
        let index: Int
        let categoryName: String
        let displayName: String
    }

    // MARK: - Landmark
    public struct Landmark: Codable {
        let x: Double
        let y: Double
        let z: Double
        
        var position: simd_float3 {
            return simd_float3(Float(x), Float(y), Float(z))
        }
    }
    struct Joint {
        var position: SIMD3<Float>
        let handPart: HandSkeleton.JointName.NameCodingKey
        
        init(handPart: HandSkeleton.JointName.NameCodingKey, position: SIMD3<Float>) {
            self.handPart = handPart
            self.position = position
        }
        init(jointIndex : Int, position: SIMD3<Float>) {
            switch jointIndex {
            case 0:
                handPart = .wrist
            case 1:
                handPart = .thumbKnuckle
            case 2:
                handPart = .thumbIntermediateBase
            case 3:
                handPart = .thumbIntermediateTip
            case 4:
                handPart = .thumbTip
                
            case 5:
                handPart = .indexFingerKnuckle
            case 6:
                handPart = .indexFingerIntermediateBase
            case 7:
                handPart = .indexFingerIntermediateTip
            case 8:
                handPart = .indexFingerTip
                
            case 9:
                handPart = .middleFingerKnuckle
            case 10:
                handPart = .middleFingerIntermediateBase
            case 11:
                handPart = .middleFingerIntermediateTip
            case 12:
                handPart = .middleFingerTip
                
            case 13:
                handPart = .ringFingerKnuckle
            case 14:
                handPart = .ringFingerIntermediateBase
            case 15:
                handPart = .ringFingerIntermediateTip
            case 16:
                handPart = .ringFingerTip
                
            case 17:
                handPart = .littleFingerKnuckle
            case 18:
                handPart = .littleFingerIntermediateBase
            case 19:
                handPart = .littleFingerIntermediateTip
            case 20:
                handPart = .littleFingerTip
                
            default:
                handPart = .unknown
            }
            self.position = position
        }
    }
    private static func fullFillLandmarksToJointsDict(_ landmarks: [Landmark]) -> [HandSkeleton.JointName.NameCodingKey :Joint] {
        var joints: [HandSkeleton.JointName.NameCodingKey :Joint] = [:]
        for (i, landmark) in landmarks.enumerated() {
            let joint = Joint(jointIndex: i, position: landmark.position)
            joints[joint.handPart] = joint
        }
        let wrist = joints[.wrist]!
        let indexFingerKnuckle = joints[.indexFingerKnuckle]!
        let middleFingerKnuckle = joints[.middleFingerKnuckle]!
        let ringFingerKnuckle = joints[.ringFingerKnuckle]!
        let littleFingerKnuckle = joints[.littleFingerKnuckle]!
        
        joints[.forearmWrist] = Joint(handPart: .forearmWrist, position: wrist.position)
        joints[.indexFingerMetacarpal] = Joint(handPart: .indexFingerMetacarpal, position: 0.67 * wrist.position + 0.33 * indexFingerKnuckle.position)
        joints[.middleFingerMetacarpal] = Joint(handPart: .middleFingerMetacarpal, position: 0.67 * wrist.position + 0.33 * middleFingerKnuckle.position)
        joints[.ringFingerMetacarpal] = Joint(handPart: .ringFingerMetacarpal, position: 0.67 * wrist.position + 0.33 * ringFingerKnuckle.position)
        joints[.littleFingerMetacarpal] = Joint(handPart: .littleFingerMetacarpal, position: 0.67 * wrist.position + 0.33 * littleFingerKnuckle.position)
        joints[.forearmArm] = Joint(handPart: .forearmArm, position: 3 * wrist.position - 2 * middleFingerKnuckle.position)
        
        let referenceLength = simd_length(simd_float3(0.10013892, 0.0014904594, -0.0042377603))
        let currentLength = simd_length(middleFingerKnuckle.position - wrist.position)
        let scale = currentLength / referenceLength
//        debugPrint("scale:\(scale)")
        for (key, value) in joints {
            let scalePosition = value.position/scale
            let p = simd_float3(0.5/scale - scalePosition.x, 0.5/scale - scalePosition.y, scalePosition.z + 1/scale - 1)
            joints[key] = .init(handPart: key, position: p)
        }
        
        return joints
    }

    func convertToHandVector(offset: simd_float3) -> (left: HandVectorMatcher?, right: HandVectorMatcher?) {
        var leftVector: HandVectorMatcher?
        var rightVector: HandVectorMatcher?
        for (landmarks, handednesses) in zip(landmarks, handednesses) {
            var allPositions: [HandSkeleton.JointName.NameCodingKey : HVJointInfo] = [:]
            let jointsDict = Self.fullFillLandmarksToJointsDict(landmarks)
            let wrist = jointsDict[.wrist]!
            let indexFingerKnuckle = jointsDict[.indexFingerKnuckle]!
            let middleFingerKnuckle = jointsDict[.middleFingerKnuckle]!
            let ringFingerKnuckle = jointsDict[.ringFingerKnuckle]!
            
            if handednesses.first?.categoryName == "Right" {
                let xAxis = normalize(middleFingerKnuckle.position - wrist.position)
                let zAxis = normalize(ringFingerKnuckle.position - indexFingerKnuckle.position)
                let yAxis = cross(zAxis, xAxis)
                let matrix = simd_float4x4(columns: (simd_float4(xAxis, 0), simd_float4(yAxis, 0), simd_float4(zAxis, 0), simd_float4(wrist.position, 1)))
                
                for joint in jointsDict.values {
                    let inversedPosition = matrix.inverse * simd_float4(joint.position, 1)
                    allPositions[joint.handPart] = HVJointInfo(name: joint.handPart, isTracked: true, position: inversedPosition.xyz)
                }
                let transform = simd_float4x4([matrix.columns.0, matrix.columns.1, matrix.columns.2, matrix.columns.3 + simd_float4(offset, 0)])
                leftVector = HandVectorMatcher(chirality: .left, allPositions: allPositions, transform: transform)
            } else if handednesses.first?.categoryName == "Left" {
                let xAxis = -normalize(middleFingerKnuckle.position - wrist.position)
                let zAxis = -normalize(ringFingerKnuckle.position - indexFingerKnuckle.position)
                let yAxis = cross(zAxis, xAxis)
                let matrix = simd_float4x4(columns: (simd_float4(xAxis, 0), simd_float4(yAxis, 0), simd_float4(zAxis, 0), simd_float4(wrist.position, 1)))
                for joint in jointsDict.values {
                    let inversedPosition = matrix.inverse * simd_float4(joint.position, 1)
                    allPositions[joint.handPart] = HVJointInfo(name: joint.handPart, isTracked: true, position: inversedPosition.xyz)
                }
                let transform = simd_float4x4([matrix.columns.0, matrix.columns.1, matrix.columns.2, matrix.columns.3 + simd_float4(offset, 0)])
                rightVector = HandVectorMatcher(chirality: .right, allPositions: allPositions, transform: transform)
            }
        }
        return (left: leftVector, right: rightVector)
    }
}


@available(visionOS 1.0, *)
@available(macOS, unavailable)
@available(iOS, unavailable)
@Observable
public class SimulatorHandTrackingProvider {
    private let bonjour = BonjourSession(configuration: .default)
    private var task: Task<(), Error>?
    public var simdHandHandler: ((SimHand) -> Void)?
    public init() {
        
    }
    
    public var simHands: AsyncStream<SimHand> {
        AsyncStream { continuation in
            ///  配置一个终止回调，以了解你的流的生命周期。
            continuation.onTermination = {@Sendable [weak self] status in
                print("Stream terminated with status \(status)")
                self?.bonjour.stop()
            }
            bonjour.start()
            bonjour.onReceive = { data, peer in
                do {
                    let simdHand = try JSONDecoder().decode(SimHand.self, from: data)
//                    debugPrint(simdHand)
                    continuation.yield(simdHand)
                } catch {
                    print("Oh no, bonjour or data error in VisionSimHands")
                }
            }
        }
    }
    public func start() {
        print("Starting Sim Hands")
        
        // Start the Bonjour service which looks for data from the macOS Helper App
        bonjour.start()
        bonjour.onReceive = {[weak self] data, peer in
            do {
                let simdHand = try JSONDecoder().decode(SimHand.self, from: data)
                self?.simdHandHandler?(simdHand)
            } catch {
                print("Oh no, bonjour or data error in VisionSimHands")
            }
        }
    }
    public func stop() {
        bonjour.stop()
    }
    
}
#endif
