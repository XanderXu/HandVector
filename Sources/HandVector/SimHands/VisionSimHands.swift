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
    private struct Joint {
        let handPart: HandSkeleton.JointName
        //world position in 3D
        var position: SIMD3<Float>
        
        init(handPart: HandSkeleton.JointName, position: SIMD3<Float>) {
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
                handPart = .forearmWrist
            }
            self.position = position
        }
    }
    private static func fullFillLandmarksToJointsDict(_ landmarks: [Landmark]) -> [HandSkeleton.JointName: Joint] {
        var joints: [HandSkeleton.JointName: Joint] = [:]
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
    private static func calculateJointTransform(jointDict: [HandSkeleton.JointName: Joint], rootTransform: simd_float4x4, isLeft: Bool) -> [HandSkeleton.JointName: simd_float4x4] {
        var worldTransforms: [HandSkeleton.JointName: simd_float4x4] = [:]
        
        let rootZ = rootTransform.columns.2.xyz
        // wrist
        worldTransforms[.wrist] = rootTransform
        worldTransforms[.forearmWrist] = rootTransform
        worldTransforms[.forearmArm] = .init(rootTransform.columns.0, rootTransform.columns.1, rootTransform.columns.2, SIMD4(jointDict[.forearmArm]!.position, 1))

        // thumb transform need refer palm center
        let knukleCenter = (jointDict[.indexFingerKnuckle]!.position + jointDict[.middleFingerKnuckle]!.position + jointDict[.ringFingerKnuckle]!.position + jointDict[.littleFingerKnuckle]!.position) / 5.0
        let palmCenter = knukleCenter + jointDict[.wrist]!.position / 5.0
        let palmOffsetLeft = palmCenter + rootTransform.columns.1.xyz * 0.025
        
        // thumbIntermediateBase
        let thumbInterBaseX = normalize(jointDict[.thumbIntermediateTip]!.position - jointDict[.thumbIntermediateBase]!.position)
        let thumbInterBaseY = normalize(palmOffsetLeft - jointDict[.thumbIntermediateBase]!.position)
        let thumbInterBaseZ = cross(thumbInterBaseX, thumbInterBaseY)
        worldTransforms[.thumbIntermediateBase] = simd_float4x4(SIMD4(thumbInterBaseX, 0), SIMD4(thumbInterBaseY, 0), SIMD4(thumbInterBaseZ, 0), SIMD4(jointDict[.thumbIntermediateBase]!.position, 1))
        
        // thumbIntermediateTip
        let thumbInterTipX = normalize(jointDict[.thumbTip]!.position - jointDict[.thumbIntermediateTip]!.position)
        let thumbInterTipY = cross(thumbInterBaseZ, thumbInterTipX)
        let thumbInterTipZ = cross(thumbInterTipX, thumbInterTipY)
        worldTransforms[.thumbIntermediateTip] = simd_float4x4(SIMD4(thumbInterTipX, 0), SIMD4(thumbInterTipY, 0), SIMD4(thumbInterTipZ, 0), SIMD4(jointDict[.thumbIntermediateTip]!.position, 1))
        
        // thumbTip
        worldTransforms[.thumbTip] = simd_float4x4(SIMD4(thumbInterTipX, 0), SIMD4(thumbInterTipY, 0), SIMD4(thumbInterTipZ, 0), SIMD4(jointDict[.thumbTip]!.position, 1))
        
        // thumbKnuckle
        let thumbKnuckleX = normalize(jointDict[.thumbKnuckle]!.position - jointDict[.wrist]!.position)
        let thumbKnuckleY = cross(thumbInterBaseZ, thumbKnuckleX)
        let thumbKnuckleZ = cross(thumbKnuckleX, thumbKnuckleY)
        worldTransforms[.thumbKnuckle] = simd_float4x4(SIMD4(thumbKnuckleX, 0), SIMD4(thumbKnuckleY, 0), SIMD4(thumbKnuckleZ, 0), SIMD4(jointDict[.thumbKnuckle]!.position, 1))
        
        
        // indexFingerMetacarpal
        let indexMetaX = normalize(jointDict[.indexFingerMetacarpal]!.position - jointDict[.wrist]!.position)
        let indexMetaY = cross(rootZ, indexMetaX)
        let indexMetaZ = cross(indexMetaX, indexMetaY)
        worldTransforms[.indexFingerMetacarpal] = simd_float4x4(SIMD4(indexMetaX, 0), SIMD4(indexMetaY, 0), SIMD4(indexMetaZ, 0), SIMD4(jointDict[.indexFingerMetacarpal]!.position, 1))
        
        // indexFingerKnuckle
        let indexKnuckleX = normalize(jointDict[.indexFingerKnuckle]!.position - jointDict[.indexFingerMetacarpal]!.position)
        let indexKnuckleY = cross(indexMetaZ, indexKnuckleX)
        let indexKnuckleZ = cross(indexKnuckleX, indexKnuckleY)
        worldTransforms[.indexFingerKnuckle] = simd_float4x4(SIMD4(indexKnuckleX, 0), SIMD4(indexKnuckleY, 0), SIMD4(indexKnuckleZ, 0), SIMD4(jointDict[.indexFingerKnuckle]!.position, 1))
        
        // indexFingerIntermediateBase
        let indexInterBaseX = normalize(jointDict[.indexFingerIntermediateBase]!.position - jointDict[.indexFingerKnuckle]!.position)
        let indexInterBaseY = cross(indexKnuckleZ, indexInterBaseX)
        let indexInterBaseZ = cross(indexInterBaseX, indexInterBaseY)
        worldTransforms[.indexFingerIntermediateBase] = simd_float4x4(SIMD4(indexKnuckleX, 0), SIMD4(indexKnuckleY, 0), SIMD4(indexKnuckleZ, 0), SIMD4(jointDict[.indexFingerIntermediateBase]!.position, 1))
        
        // indexFingerIntermediateTip
        let indexInterTipX = normalize(jointDict[.indexFingerIntermediateTip]!.position - jointDict[.indexFingerIntermediateBase]!.position)
        let indexInterTipY = cross(indexInterBaseZ, indexInterTipX)
        let indexInterTipZ = cross(indexInterTipX, indexInterTipY)
        worldTransforms[.indexFingerIntermediateTip] = simd_float4x4(SIMD4(indexInterTipX, 0), SIMD4(indexInterTipY, 0), SIMD4(indexInterTipZ, 0), SIMD4(jointDict[.indexFingerIntermediateTip]!.position, 1))
        
        // indexFingerTip
        worldTransforms[.indexFingerTip] = simd_float4x4(SIMD4(indexInterTipX, 0), SIMD4(indexInterTipY, 0), SIMD4(indexInterTipZ, 0), SIMD4(jointDict[.indexFingerTip]!.position, 1))
        
        // middleFingerMetacarpal
        let middleMetaX = normalize(jointDict[.middleFingerMetacarpal]!.position - jointDict[.wrist]!.position)
        let middleMetaY = cross(rootZ, middleMetaX)
        let middleMetaZ = cross(middleMetaX, middleMetaY)
        worldTransforms[.middleFingerMetacarpal] = simd_float4x4(SIMD4(middleMetaX, 0), SIMD4(middleMetaY, 0), SIMD4(middleMetaZ, 0), SIMD4(jointDict[.middleFingerMetacarpal]!.position, 1))
        
        // middleFingerKnuckle
        let middleKnuckleX = normalize(jointDict[.middleFingerKnuckle]!.position - jointDict[.middleFingerMetacarpal]!.position)
        let middleKnuckleY = cross(middleMetaZ, middleKnuckleX)
        let middleKnuckleZ = cross(middleKnuckleX, middleKnuckleY)
        worldTransforms[.middleFingerKnuckle] = simd_float4x4(SIMD4(middleKnuckleX, 0), SIMD4(middleKnuckleY, 0), SIMD4(middleKnuckleZ, 0), SIMD4(jointDict[.middleFingerKnuckle]!.position, 1))
        
        // middleFingerIntermediateBase
        let middleInterBaseX = normalize(jointDict[.middleFingerIntermediateBase]!.position - jointDict[.middleFingerKnuckle]!.position)
        let middleInterBaseY = cross(middleKnuckleZ, middleInterBaseX)
        let middleInterBaseZ = cross(middleInterBaseX, middleInterBaseY)
        worldTransforms[.middleFingerIntermediateBase] = simd_float4x4(SIMD4(middleKnuckleX, 0), SIMD4(middleKnuckleY, 0), SIMD4(middleKnuckleZ, 0), SIMD4(jointDict[.middleFingerIntermediateBase]!.position, 1))
        
        // middleFingerIntermediateTip
        let middleInterTipX = normalize(jointDict[.middleFingerIntermediateTip]!.position - jointDict[.middleFingerIntermediateBase]!.position)
        let middleInterTipY = cross(middleInterBaseZ, middleInterTipX)
        let middleInterTipZ = cross(middleInterTipX, middleInterTipY)
        worldTransforms[.middleFingerIntermediateTip] = simd_float4x4(SIMD4(middleInterTipX, 0), SIMD4(middleInterTipY, 0), SIMD4(middleInterTipZ, 0), SIMD4(jointDict[.middleFingerIntermediateTip]!.position, 1))
        
        // middleFingerTip
        worldTransforms[.middleFingerTip] = simd_float4x4(SIMD4(middleInterTipX, 0), SIMD4(middleInterTipY, 0), SIMD4(middleInterTipZ, 0), SIMD4(jointDict[.middleFingerTip]!.position, 1))
        
        
        // ringFingerMetacarpal
        let ringMetaX = normalize(jointDict[.ringFingerMetacarpal]!.position - jointDict[.wrist]!.position)
        let ringMetaY = cross(rootZ, ringMetaX)
        let ringMetaZ = cross(ringMetaX, ringMetaY)
        worldTransforms[.ringFingerMetacarpal] = simd_float4x4(SIMD4(ringMetaX, 0), SIMD4(ringMetaY, 0), SIMD4(ringMetaZ, 0), SIMD4(jointDict[.ringFingerMetacarpal]!.position, 1))
        
        // ringFingerKnuckle
        let ringKnuckleX = normalize(jointDict[.ringFingerKnuckle]!.position - jointDict[.ringFingerMetacarpal]!.position)
        let ringKnuckleY = cross(ringMetaZ, ringKnuckleX)
        let ringKnuckleZ = cross(ringKnuckleX, ringKnuckleY)
        worldTransforms[.ringFingerKnuckle] = simd_float4x4(SIMD4(ringKnuckleX, 0), SIMD4(ringKnuckleY, 0), SIMD4(ringKnuckleZ, 0), SIMD4(jointDict[.ringFingerKnuckle]!.position, 1))
        
        // ringFingerIntermediateBase
        let ringInterBaseX = normalize(jointDict[.ringFingerIntermediateBase]!.position - jointDict[.ringFingerKnuckle]!.position)
        let ringInterBaseY = cross(ringKnuckleZ, ringInterBaseX)
        let ringInterBaseZ = cross(ringInterBaseX, ringInterBaseY)
        worldTransforms[.ringFingerIntermediateBase] = simd_float4x4(SIMD4(ringKnuckleX, 0), SIMD4(ringKnuckleY, 0), SIMD4(ringKnuckleZ, 0), SIMD4(jointDict[.ringFingerIntermediateBase]!.position, 1))
        
        // ringFingerIntermediateTip
        let ringInterTipX = normalize(jointDict[.ringFingerIntermediateTip]!.position - jointDict[.ringFingerIntermediateBase]!.position)
        let ringInterTipY = cross(ringInterBaseZ, ringInterTipX)
        let ringInterTipZ = cross(ringInterTipX, ringInterTipY)
        worldTransforms[.ringFingerIntermediateTip] = simd_float4x4(SIMD4(ringInterTipX, 0), SIMD4(ringInterTipY, 0), SIMD4(ringInterTipZ, 0), SIMD4(jointDict[.ringFingerIntermediateTip]!.position, 1))
        
        // ringFingerTip
        worldTransforms[.ringFingerTip] = simd_float4x4(SIMD4(ringInterTipX, 0), SIMD4(ringInterTipY, 0), SIMD4(ringInterTipZ, 0), SIMD4(jointDict[.ringFingerTip]!.position, 1))
        
        // littleFingerMetacarpal
        let littleMetaX = normalize(jointDict[.littleFingerMetacarpal]!.position - jointDict[.wrist]!.position)
        let littleMetaY = cross(rootZ, littleMetaX)
        let littleMetaZ = cross(littleMetaX, littleMetaY)
        worldTransforms[.littleFingerMetacarpal] = simd_float4x4(SIMD4(littleMetaX, 0), SIMD4(littleMetaY, 0), SIMD4(littleMetaZ, 0), SIMD4(jointDict[.littleFingerMetacarpal]!.position, 1))
        
        // littleFingerKnuckle
        let littleKnuckleX = normalize(jointDict[.littleFingerKnuckle]!.position - jointDict[.littleFingerMetacarpal]!.position)
        let littleKnuckleY = cross(littleMetaZ, littleKnuckleX)
        let littleKnuckleZ = cross(littleKnuckleX, littleKnuckleY)
        worldTransforms[.littleFingerKnuckle] = simd_float4x4(SIMD4(littleKnuckleX, 0), SIMD4(littleKnuckleY, 0), SIMD4(littleKnuckleZ, 0), SIMD4(jointDict[.littleFingerKnuckle]!.position, 1))
        
        // littleFingerIntermediateBase
        let littleInterBaseX = normalize(jointDict[.littleFingerIntermediateBase]!.position - jointDict[.littleFingerKnuckle]!.position)
        let littleInterBaseY = cross(littleKnuckleZ, littleInterBaseX)
        let littleInterBaseZ = cross(littleInterBaseX, littleInterBaseY)
        worldTransforms[.littleFingerIntermediateBase] = simd_float4x4(SIMD4(littleKnuckleX, 0), SIMD4(littleKnuckleY, 0), SIMD4(littleKnuckleZ, 0), SIMD4(jointDict[.littleFingerIntermediateBase]!.position, 1))
        
        // littleFingerIntermediateTip
        let littleInterTipX = normalize(jointDict[.littleFingerIntermediateTip]!.position - jointDict[.littleFingerIntermediateBase]!.position)
        let littleInterTipY = cross(littleInterBaseZ, littleInterTipX)
        let littleInterTipZ = cross(littleInterTipX, littleInterTipY)
        worldTransforms[.littleFingerIntermediateTip] = simd_float4x4(SIMD4(littleInterTipX, 0), SIMD4(littleInterTipY, 0), SIMD4(littleInterTipZ, 0), SIMD4(jointDict[.littleFingerIntermediateTip]!.position, 1))
        
        // littleFingerTip
        worldTransforms[.littleFingerTip] = simd_float4x4(SIMD4(littleInterTipX, 0), SIMD4(littleInterTipY, 0), SIMD4(littleInterTipZ, 0), SIMD4(jointDict[.littleFingerTip]!.position, 1))
        
        let rotation = simd_quatf(angle: isLeft ? 0 : .pi, axis: .init(0, 1, 0))
        let localTransforms = worldTransforms.reduce(into: [HandSkeleton.JointName: simd_float4x4]()) {
            $0[$1.key] = rootTransform.inverse * $1.value * .init(rotation)
        }
        return localTransforms
    }
    func convertToHandVector(offset: simd_float3) -> (left: HandVectorMatcher?, right: HandVectorMatcher?) {
        var leftVector: HandVectorMatcher?
        var rightVector: HandVectorMatcher?
        for (landmarks, handednesses) in zip(landmarks, handednesses) {
            var allJoints: [HVJointJsonModel] = []
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
                
                let localDict = Self.calculateJointTransform(jointDict: jointsDict, rootTransform: matrix, isLeft: true)
                for joint in jointsDict.values {
                    let jsonJoint = HVJointJsonModel(name: joint.handPart.codableName, isTracked: true, transform: localDict[joint.handPart]!)
                    allJoints.append(jsonJoint)
                }
                let transform = simd_float4x4([matrix.columns.0, matrix.columns.1, matrix.columns.2, matrix.columns.3 + simd_float4(offset, 0)])
                leftVector = HVHandJsonModel(name: "SimLeft", chirality: .left, transform: transform, joints: allJoints).convertToHandVectorMatcher()
                //HandVectorMatcher(chirality: .left, allJoints: allPositions, transform: transform)
            } else if handednesses.first?.categoryName == "Left" {
                let xAxis = -normalize(middleFingerKnuckle.position - wrist.position)
                let zAxis = -normalize(ringFingerKnuckle.position - indexFingerKnuckle.position)
                let yAxis = cross(zAxis, xAxis)
                let matrix = simd_float4x4(columns: (simd_float4(xAxis, 0), simd_float4(yAxis, 0), simd_float4(zAxis, 0), simd_float4(wrist.position, 1)))
                
                let localDict = Self.calculateJointTransform(jointDict: jointsDict, rootTransform: matrix, isLeft: false)
                for joint in jointsDict.values {
                    let jsonJoint = HVJointJsonModel(name: joint.handPart.codableName, isTracked: true, transform: localDict[joint.handPart]!)
                    allJoints.append(jsonJoint)
                }
                let transform = simd_float4x4([matrix.columns.0, matrix.columns.1, matrix.columns.2, matrix.columns.3 + simd_float4(offset, 0)])
                rightVector = HVHandJsonModel(name: "SimRight", chirality: .right, transform: transform, joints: allJoints).convertToHandVectorMatcher()
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
