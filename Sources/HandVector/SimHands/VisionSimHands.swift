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
        
        // wrist
        worldTransforms[.wrist] = rootTransform
        worldTransforms[.forearmWrist] = rootTransform
        worldTransforms[.forearmArm] = .init(rootTransform.columns.0, rootTransform.columns.1, rootTransform.columns.2, SIMD4(jointDict[.forearmArm]!.position, 1))

        // thumb transform need refer palm center
        let knukleCenter = (jointDict[.indexFingerKnuckle]!.position + jointDict[.middleFingerKnuckle]!.position + jointDict[.ringFingerKnuckle]!.position + jointDict[.littleFingerKnuckle]!.position) / 5.0
        let palmCenter = knukleCenter + jointDict[.wrist]!.position / 5.0
        let palmOffset = palmCenter + rootTransform.columns.1.xyz * (isLeft ? 0.025 : -0.025)
        
        // thumbIntermediateBase
        let thumbInterBaseX = normalize(jointDict[.thumbIntermediateTip]!.position - jointDict[.thumbIntermediateBase]!.position) * (isLeft ? 1 : -1)
        let thumbInterBaseY = normalize(palmOffset - jointDict[.thumbIntermediateBase]!.position) * (isLeft ? 1 : -1)
        let thumbInterBaseZ = cross(thumbInterBaseX, thumbInterBaseY)
        worldTransforms[.thumbIntermediateBase] = simd_float4x4(SIMD4(thumbInterBaseX, 0), SIMD4(thumbInterBaseY, 0), SIMD4(thumbInterBaseZ, 0), SIMD4(jointDict[.thumbIntermediateBase]!.position, 1))
        
        // thumbIntermediateTip
        let thumbInterTipX = normalize(jointDict[.thumbTip]!.position - jointDict[.thumbIntermediateTip]!.position) * (isLeft ? 1 : -1)
        let thumbInterTipY = cross(thumbInterBaseZ, thumbInterTipX)
        let thumbInterTipZ = cross(thumbInterTipX, thumbInterTipY)
        worldTransforms[.thumbIntermediateTip] = simd_float4x4(SIMD4(thumbInterTipX, 0), SIMD4(thumbInterTipY, 0), SIMD4(thumbInterTipZ, 0), SIMD4(jointDict[.thumbIntermediateTip]!.position, 1))
        
        // thumbTip
        worldTransforms[.thumbTip] = simd_float4x4(SIMD4(thumbInterTipX, 0), SIMD4(thumbInterTipY, 0), SIMD4(thumbInterTipZ, 0), SIMD4(jointDict[.thumbTip]!.position, 1))
        
        // thumbKnuckle
        let thumbKnuckleX = normalize(jointDict[.thumbKnuckle]!.position - jointDict[.wrist]!.position) * (isLeft ? 1 : -1)
        let thumbKnuckleY = cross(thumbInterBaseZ, thumbKnuckleX)
        let thumbKnuckleZ = cross(thumbKnuckleX, thumbKnuckleY)
        worldTransforms[.thumbKnuckle] = simd_float4x4(SIMD4(thumbKnuckleX, 0), SIMD4(thumbKnuckleY, 0), SIMD4(thumbKnuckleZ, 0), SIMD4(jointDict[.thumbKnuckle]!.position, 1))
        
        let rootZ = rootTransform.columns.2.xyz * (isLeft ? 1 : -1)
        
        // indexFingerMetacarpal
        let indexMetaX = normalize(jointDict[.indexFingerMetacarpal]!.position - jointDict[.wrist]!.position) * (isLeft ? 1 : -1)
        let indexMetaY = cross(rootZ, indexMetaX)
        let indexMetaZ = cross(indexMetaX, indexMetaY)
        worldTransforms[.indexFingerMetacarpal] = simd_float4x4(SIMD4(indexMetaX, 0), SIMD4(indexMetaY, 0), SIMD4(indexMetaZ, 0), SIMD4(jointDict[.indexFingerMetacarpal]!.position, 1))
        
        // indexFingerKnuckle
        let indexKnuckleX = normalize(jointDict[.indexFingerKnuckle]!.position - jointDict[.indexFingerMetacarpal]!.position) * (isLeft ? 1 : -1)
        let indexKnuckleY = cross(indexMetaZ, indexKnuckleX)
        let indexKnuckleZ = cross(indexKnuckleX, indexKnuckleY)
        worldTransforms[.indexFingerKnuckle] = simd_float4x4(SIMD4(indexKnuckleX, 0), SIMD4(indexKnuckleY, 0), SIMD4(indexKnuckleZ, 0), SIMD4(jointDict[.indexFingerKnuckle]!.position, 1))
        
        // indexFingerIntermediateBase
        let indexInterBaseX = normalize(jointDict[.indexFingerIntermediateBase]!.position - jointDict[.indexFingerKnuckle]!.position) * (isLeft ? 1 : -1)
        let indexInterBaseY = cross(indexKnuckleZ, indexInterBaseX)
        let indexInterBaseZ = cross(indexInterBaseX, indexInterBaseY)
        worldTransforms[.indexFingerIntermediateBase] = simd_float4x4(SIMD4(indexKnuckleX, 0), SIMD4(indexKnuckleY, 0), SIMD4(indexKnuckleZ, 0), SIMD4(jointDict[.indexFingerIntermediateBase]!.position, 1))
        
        // indexFingerIntermediateTip
        let indexInterTipX = normalize(jointDict[.indexFingerIntermediateTip]!.position - jointDict[.indexFingerIntermediateBase]!.position) * (isLeft ? 1 : -1)
        let indexInterTipY = cross(indexInterBaseZ, indexInterTipX)
        let indexInterTipZ = cross(indexInterTipX, indexInterTipY)
        worldTransforms[.indexFingerIntermediateTip] = simd_float4x4(SIMD4(indexInterTipX, 0), SIMD4(indexInterTipY, 0), SIMD4(indexInterTipZ, 0), SIMD4(jointDict[.indexFingerIntermediateTip]!.position, 1))
        
        // indexFingerTip
        worldTransforms[.indexFingerTip] = simd_float4x4(SIMD4(indexInterTipX, 0), SIMD4(indexInterTipY, 0), SIMD4(indexInterTipZ, 0), SIMD4(jointDict[.indexFingerTip]!.position, 1))
        
        // middleFingerMetacarpal
        let middleMetaX = normalize(jointDict[.middleFingerMetacarpal]!.position - jointDict[.wrist]!.position) * (isLeft ? 1 : -1)
        let middleMetaY = cross(rootZ, middleMetaX)
        let middleMetaZ = cross(middleMetaX, middleMetaY)
        worldTransforms[.middleFingerMetacarpal] = simd_float4x4(SIMD4(middleMetaX, 0), SIMD4(middleMetaY, 0), SIMD4(middleMetaZ, 0), SIMD4(jointDict[.middleFingerMetacarpal]!.position, 1))
        
        // middleFingerKnuckle
        let middleKnuckleX = normalize(jointDict[.middleFingerKnuckle]!.position - jointDict[.middleFingerMetacarpal]!.position) * (isLeft ? 1 : -1)
        let middleKnuckleY = cross(middleMetaZ, middleKnuckleX)
        let middleKnuckleZ = cross(middleKnuckleX, middleKnuckleY)
        worldTransforms[.middleFingerKnuckle] = simd_float4x4(SIMD4(middleKnuckleX, 0), SIMD4(middleKnuckleY, 0), SIMD4(middleKnuckleZ, 0), SIMD4(jointDict[.middleFingerKnuckle]!.position, 1))
        
        // middleFingerIntermediateBase
        let middleInterBaseX = normalize(jointDict[.middleFingerIntermediateBase]!.position - jointDict[.middleFingerKnuckle]!.position) * (isLeft ? 1 : -1)
        let middleInterBaseY = cross(middleKnuckleZ, middleInterBaseX)
        let middleInterBaseZ = cross(middleInterBaseX, middleInterBaseY)
        worldTransforms[.middleFingerIntermediateBase] = simd_float4x4(SIMD4(middleKnuckleX, 0), SIMD4(middleKnuckleY, 0), SIMD4(middleKnuckleZ, 0), SIMD4(jointDict[.middleFingerIntermediateBase]!.position, 1))
        
        // middleFingerIntermediateTip
        let middleInterTipX = normalize(jointDict[.middleFingerIntermediateTip]!.position - jointDict[.middleFingerIntermediateBase]!.position) * (isLeft ? 1 : -1)
        let middleInterTipY = cross(middleInterBaseZ, middleInterTipX)
        let middleInterTipZ = cross(middleInterTipX, middleInterTipY)
        worldTransforms[.middleFingerIntermediateTip] = simd_float4x4(SIMD4(middleInterTipX, 0), SIMD4(middleInterTipY, 0), SIMD4(middleInterTipZ, 0), SIMD4(jointDict[.middleFingerIntermediateTip]!.position, 1))
        
        // middleFingerTip
        worldTransforms[.middleFingerTip] = simd_float4x4(SIMD4(middleInterTipX, 0), SIMD4(middleInterTipY, 0), SIMD4(middleInterTipZ, 0), SIMD4(jointDict[.middleFingerTip]!.position, 1))
        
        
        // ringFingerMetacarpal
        let ringMetaX = normalize(jointDict[.ringFingerMetacarpal]!.position - jointDict[.wrist]!.position) * (isLeft ? 1 : -1)
        let ringMetaY = cross(rootZ, ringMetaX)
        let ringMetaZ = cross(ringMetaX, ringMetaY)
        worldTransforms[.ringFingerMetacarpal] = simd_float4x4(SIMD4(ringMetaX, 0), SIMD4(ringMetaY, 0), SIMD4(ringMetaZ, 0), SIMD4(jointDict[.ringFingerMetacarpal]!.position, 1))
        
        // ringFingerKnuckle
        let ringKnuckleX = normalize(jointDict[.ringFingerKnuckle]!.position - jointDict[.ringFingerMetacarpal]!.position) * (isLeft ? 1 : -1)
        let ringKnuckleY = cross(ringMetaZ, ringKnuckleX)
        let ringKnuckleZ = cross(ringKnuckleX, ringKnuckleY)
        worldTransforms[.ringFingerKnuckle] = simd_float4x4(SIMD4(ringKnuckleX, 0), SIMD4(ringKnuckleY, 0), SIMD4(ringKnuckleZ, 0), SIMD4(jointDict[.ringFingerKnuckle]!.position, 1))
        
        // ringFingerIntermediateBase
        let ringInterBaseX = normalize(jointDict[.ringFingerIntermediateBase]!.position - jointDict[.ringFingerKnuckle]!.position) * (isLeft ? 1 : -1)
        let ringInterBaseY = cross(ringKnuckleZ, ringInterBaseX)
        let ringInterBaseZ = cross(ringInterBaseX, ringInterBaseY)
        worldTransforms[.ringFingerIntermediateBase] = simd_float4x4(SIMD4(ringKnuckleX, 0), SIMD4(ringKnuckleY, 0), SIMD4(ringKnuckleZ, 0), SIMD4(jointDict[.ringFingerIntermediateBase]!.position, 1))
        
        // ringFingerIntermediateTip
        let ringInterTipX = normalize(jointDict[.ringFingerIntermediateTip]!.position - jointDict[.ringFingerIntermediateBase]!.position) * (isLeft ? 1 : -1)
        let ringInterTipY = cross(ringInterBaseZ, ringInterTipX)
        let ringInterTipZ = cross(ringInterTipX, ringInterTipY)
        worldTransforms[.ringFingerIntermediateTip] = simd_float4x4(SIMD4(ringInterTipX, 0), SIMD4(ringInterTipY, 0), SIMD4(ringInterTipZ, 0), SIMD4(jointDict[.ringFingerIntermediateTip]!.position, 1))
        
        // ringFingerTip
        worldTransforms[.ringFingerTip] = simd_float4x4(SIMD4(ringInterTipX, 0), SIMD4(ringInterTipY, 0), SIMD4(ringInterTipZ, 0), SIMD4(jointDict[.ringFingerTip]!.position, 1))
        
        // littleFingerMetacarpal
        let littleMetaX = normalize(jointDict[.littleFingerMetacarpal]!.position - jointDict[.wrist]!.position) * (isLeft ? 1 : -1)
        let littleMetaY = cross(rootZ, littleMetaX)
        let littleMetaZ = cross(littleMetaX, littleMetaY)
        worldTransforms[.littleFingerMetacarpal] = simd_float4x4(SIMD4(littleMetaX, 0), SIMD4(littleMetaY, 0), SIMD4(littleMetaZ, 0), SIMD4(jointDict[.littleFingerMetacarpal]!.position, 1))
        
        // littleFingerKnuckle
        let littleKnuckleX = normalize(jointDict[.littleFingerKnuckle]!.position - jointDict[.littleFingerMetacarpal]!.position) * (isLeft ? 1 : -1)
        let littleKnuckleY = cross(littleMetaZ, littleKnuckleX)
        let littleKnuckleZ = cross(littleKnuckleX, littleKnuckleY)
        worldTransforms[.littleFingerKnuckle] = simd_float4x4(SIMD4(littleKnuckleX, 0), SIMD4(littleKnuckleY, 0), SIMD4(littleKnuckleZ, 0), SIMD4(jointDict[.littleFingerKnuckle]!.position, 1))
        
        // littleFingerIntermediateBase
        let littleInterBaseX = normalize(jointDict[.littleFingerIntermediateBase]!.position - jointDict[.littleFingerKnuckle]!.position) * (isLeft ? 1 : -1)
        let littleInterBaseY = cross(littleKnuckleZ, littleInterBaseX)
        let littleInterBaseZ = cross(littleInterBaseX, littleInterBaseY)
        worldTransforms[.littleFingerIntermediateBase] = simd_float4x4(SIMD4(littleKnuckleX, 0), SIMD4(littleKnuckleY, 0), SIMD4(littleKnuckleZ, 0), SIMD4(jointDict[.littleFingerIntermediateBase]!.position, 1))
        
        // littleFingerIntermediateTip
        let littleInterTipX = normalize(jointDict[.littleFingerIntermediateTip]!.position - jointDict[.littleFingerIntermediateBase]!.position) * (isLeft ? 1 : -1)
        let littleInterTipY = cross(littleInterBaseZ, littleInterTipX)
        let littleInterTipZ = cross(littleInterTipX, littleInterTipY)
        worldTransforms[.littleFingerIntermediateTip] = simd_float4x4(SIMD4(littleInterTipX, 0), SIMD4(littleInterTipY, 0), SIMD4(littleInterTipZ, 0), SIMD4(jointDict[.littleFingerIntermediateTip]!.position, 1))
        
        // littleFingerTip
        worldTransforms[.littleFingerTip] = simd_float4x4(SIMD4(littleInterTipX, 0), SIMD4(littleInterTipY, 0), SIMD4(littleInterTipZ, 0), SIMD4(jointDict[.littleFingerTip]!.position, 1))
        
        let localTransforms = worldTransforms.reduce(into: [HandSkeleton.JointName: simd_float4x4]()) {
            $0[$1.key] = rootTransform.inverse * $1.value
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
/*
 27 elements
   
   
   ▿ 2 : 2 elements
     - key : wrist
     ▿ value : simd_float4x4([[-1.0, 2.9736347e-09, 7.036074e-09, 0.0], [9.3505435e-09, 1.0, 1.8542927e-09, 0.0], [2.7364923e-08, -1.1591531e-08, -0.99999994, 0.0], [0.0, -5.9604645e-08, 2.9802322e-08, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(-1.0, 2.9736347e-09, 7.036074e-09, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(9.3505435e-09, 1.0, 1.8542927e-09, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(2.7364923e-08, -1.1591531e-08, -0.99999994, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(0.0, -5.9604645e-08, 2.9802322e-08, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 3 : 2 elements
     - key : thumbIntermediateTip
     ▿ value : simd_float4x4([[1.0230734, 0.26177305, -0.30091757, 0.0], [-0.024173602, -0.02449466, 0.96615714, 0.0], [0.25158575, -0.9811756, -0.097941376, 0.0], [-0.08263512, -0.029640555, 0.051854372, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0230734, 0.26177305, -0.30091757, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(-0.024173602, -0.02449466, 0.96615714, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.25158575, -0.9811756, -0.097941376, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.08263512, -0.029640555, 0.051854372, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 4 : 2 elements
     - key : ringFingerTip
     ▿ value : simd_float4x4([[0.98518574, 0.21404435, -0.018870324, 0.0], [0.16753441, -0.8937117, 0.02460188, 0.0], [0.28400004, -0.027398847, -0.91259015, 0.0], [-0.1731233, -0.016076624, -0.02088666, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.98518574, 0.21404435, -0.018870324, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.16753441, -0.8937117, 0.02460188, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.28400004, -0.027398847, -0.91259015, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.1731233, -0.016076624, -0.02088666, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 5 : 2 elements
     - key : forearmArm
     ▿ value : simd_float4x4([[-1.0, 2.9736347e-09, 7.036074e-09, 0.0], [9.3505435e-09, 1.0, 1.8542927e-09, 0.0], [2.7364923e-08, -1.1591531e-08, -0.99999994, 0.0], [0.20047921, -5.9604645e-08, 1.4901161e-08, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(-1.0, 2.9736347e-09, 7.036074e-09, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(9.3505435e-09, 1.0, 1.8542927e-09, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(2.7364923e-08, -1.1591531e-08, -0.99999994, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(0.20047921, -5.9604645e-08, 1.4901161e-08, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 6 : 2 elements
     - key : middleFingerIntermediateTip
     ▿ value : simd_float4x4([[1.0025498, 0.32707313, -0.2630399, 0.0], [0.29106346, -0.91217947, 0.003218373, 0.0], [0.08683274, -0.079787895, -0.93264204, 0.0], [-0.1592448, -0.013880968, 0.005204305, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0025498, 0.32707313, -0.2630399, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.29106346, -0.91217947, 0.003218373, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.08683274, -0.079787895, -0.93264204, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.1592448, -0.013880968, 0.005204305, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 7 : 2 elements
     - key : middleFingerTip
     ▿ value : simd_float4x4([[1.0025498, 0.32707313, -0.2630399, 0.0], [0.29106346, -0.91217947, 0.003218373, 0.0], [0.08683274, -0.079787895, -0.93264204, 0.0], [-0.17758265, -0.01919806, 0.012088716, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0025498, 0.32707313, -0.2630399, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.29106346, -0.91217947, 0.003218373, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.08683274, -0.079787895, -0.93264204, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.17758265, -0.01919806, 0.012088716, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 8 : 2 elements
     - key : littleFingerKnuckle
     ▿ value : simd_float4x4([[0.8148362, 0.037941266, 0.37263143, 0.0], [0.037941888, -0.81483614, -0.012240385, 0.0], [0.5178192, 0.024112256, -0.7631967, 0.0], [-0.08334042, -0.0038806796, -0.038112238, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.8148362, 0.037941266, 0.37263143, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.037941888, -0.81483614, -0.012240385, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.5178192, 0.024112256, -0.7631967, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.08334042, -0.0038806796, -0.038112238, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 9 : 2 elements
     - key : ringFingerMetacarpal
     ▿ value : simd_float4x4([[0.9258774, 0.014445185, 0.18274944, 0.0], [0.014445172, -0.9258774, -0.0046598576, 0.0], [0.44574282, 0.0069543025, -0.91201925, 0.0], [-0.031610996, -0.00049322844, -0.0062393397, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.9258774, 0.014445185, 0.18274944, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.014445172, -0.9258774, -0.0046598576, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.44574282, 0.0069543025, -0.91201925, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.031610996, -0.00049322844, -0.0062393397, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 10 : 2 elements
     - key : ringFingerIntermediateTip
     ▿ value : simd_float4x4([[0.98518574, 0.21404435, -0.018870324, 0.0], [0.16753441, -0.8937117, 0.02460188, 0.0], [0.28400004, -0.027398847, -0.91259015, 0.0], [-0.1539093, -0.012729406, -0.024279669, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.98518574, 0.21404435, -0.018870324, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.16753441, -0.8937117, 0.02460188, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.28400004, -0.027398847, -0.91259015, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.1539093, -0.012729406, -0.024279669, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 11 : 2 elements
     - key : indexFingerMetacarpal
     ▿ value : simd_float4x4([[1.0468488, 0.016331738, -0.20386967, 0.0], [0.01633174, -1.0468488, -0.0052684476, 0.0], [0.14010239, 0.002185716, -1.0272843, 0.0], [-0.031610996, -0.00049322844, 0.0061561465, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0468488, 0.016331738, -0.20386967, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.01633174, -1.0468488, -0.0052684476, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.14010239, 0.002185716, -1.0272843, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.031610996, -0.00049322844, 0.0061561465, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   
   ▿
   ▿ 14 : 2 elements
     - key : thumbIntermediateBase
     ▿ value : simd_float4x4([[1.013523, 0.2976249, -0.34443474, 0.0], [0.3073053, 0.07281572, 0.85514134, 0.0], [0.28528896, -0.9725521, -0.10785454, 0.0], [-0.05679615, -0.022052824, 0.04307328, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.013523, 0.2976249, -0.34443474, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.3073053, 0.07281572, 0.85514134, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.28528896, -0.9725521, -0.10785454, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.05679615, -0.022052824, 0.04307328, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 15 : 2 elements
     - key : thumbKnuckle
     ▿ value : simd_float4x4([[0.74584174, 0.43592486, -0.81623346, 0.0], [0.5667309, 0.15242, 0.57848674, 0.0], [0.4196111, -0.8940443, -0.2548538, 0.0], [-0.023581147, -0.01378262, 0.025806725, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.74584174, 0.43592486, -0.81623346, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.5667309, 0.15242, 0.57848674, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.4196111, -0.8940443, -0.2548538, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.023581147, -0.01378262, 0.025806725, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 16 : 2 elements
     - key : littleFingerIntermediateTip
     ▿ value : simd_float4x4([[0.78985167, -0.007688148, 0.40928298, 0.0], [0.01615763, -0.8110557, -0.030842746, 0.0], [0.5388034, 0.030974243, -0.74764985, 0.0], [-0.122990794, -0.006669283, -0.060757622, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.78985167, -0.007688148, 0.40928298, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.01615763, -0.8110557, -0.030842746, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.5388034, 0.030974243, -0.74764985, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.122990794, -0.006669283, -0.060757622, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 17 : 2 elements
     - key : indexFingerTip
     ▿ value : simd_float4x4([[-0.0025706834, 0.8079938, -0.6434366, 0.0], [0.7976897, 0.084997006, -0.16467328, 0.0], [0.12962356, -0.51368606, -0.61946726, 0.0], [-0.113367856, -0.037646115, 0.046742216, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(-0.0025706834, 0.8079938, -0.6434366, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.7976897, 0.084997006, -0.16467328, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.12962356, -0.51368606, -0.61946726, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.113367856, -0.037646115, 0.046742216, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 18 : 2 elements
     - key : ringFingerKnuckle
     ▿ value : simd_float4x4([[0.92587763, 0.014444176, 0.18274917, 0.0], [0.014444381, -0.9258773, -0.0046599917, 0.0], [0.4457426, 0.0069542876, -0.9120192, 0.0], [-0.09579092, -0.0014944673, -0.018907145, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.92587763, 0.014444176, 0.18274917, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.014444381, -0.9258773, -0.0046599917, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.4457426, 0.0069542876, -0.9120192, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.09579092, -0.0014944673, -0.018907145, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 19 : 2 elements
     - key : forearmWrist
     ▿ value : simd_float4x4([[-1.0, 2.9736347e-09, 7.036074e-09, 0.0], [9.3505435e-09, 1.0, 1.8542927e-09, 0.0], [2.7364923e-08, -1.1591531e-08, -0.99999994, 0.0], [0.0, -5.9604645e-08, 2.9802322e-08, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(-1.0, 2.9736347e-09, 7.036074e-09, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(9.3505435e-09, 1.0, 1.8542927e-09, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(2.7364923e-08, -1.1591531e-08, -0.99999994, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(0.0, -5.9604645e-08, 2.9802322e-08, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 20 : 2 elements
     - key : indexFingerIntermediateBase
     ▿ value : simd_float4x4([[1.0468488, 0.016331777, -0.20386945, 0.0], [0.016331762, -1.0468487, -0.0052684774, 0.0], [0.1401025, 0.0021857168, -1.0272841, 0.0], [-0.122145586, -0.016576648, 0.02414848, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0468488, 0.016331777, -0.20386945, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.016331762, -1.0468487, -0.0052684774, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.1401025, 0.0021857168, -1.0272841, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.122145586, -0.016576648, 0.02414848, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 21 : 2 elements
     - key : indexFingerIntermediateTip
     ▿ value : simd_float4x4([[-0.0025706834, 0.8079938, -0.6434366, 0.0], [0.7976897, 0.084997006, -0.16467328, 0.0], [0.12962356, -0.51368606, -0.61946726, 0.0], [-0.12210166, -0.030382633, 0.035142705, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(-0.0025706834, 0.8079938, -0.6434366, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.7976897, 0.084997006, -0.16467328, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.12962356, -0.51368606, -0.61946726, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.12210166, -0.030382633, 0.035142705, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 22 : 2 elements
     - key : thumbTip
     ▿ value : simd_float4x4([[1.0230734, 0.26177305, -0.30091757, 0.0], [-0.024173602, -0.02449466, 0.96615714, 0.0], [0.25158575, -0.9811756, -0.097941376, 0.0], [-0.10422623, -0.035165012, 0.058204994, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0230734, 0.26177305, -0.30091757, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(-0.024173602, -0.02449466, 0.96615714, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.25158575, -0.9811756, -0.097941376, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.10422623, -0.035165012, 0.058204994, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 23 : 2 elements
     - key : littleFingerMetacarpal
     ▿ value : simd_float4x4([[0.81483614, 0.03794287, 0.3726316, 0.0], [0.03794285, -0.81483614, -0.012239953, 0.0], [0.5178194, 0.024112256, -0.76319677, 0.0], [-0.027502343, -0.001280725, -0.012577042, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.81483614, 0.03794287, 0.3726316, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.03794285, -0.81483614, -0.012239953, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.5178194, 0.024112256, -0.76319677, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.027502343, -0.001280725, -0.012577042, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 24 : 2 elements
     - key : middleFingerMetacarpal
     ▿ value : simd_float4x4([[0.99999994, 7.951778e-07, 1.6138613e-07, 0.0], [7.8017774e-07, -0.9999999, -2.5518534e-07, 0.0], [0.32258937, 2.3756108e-07, -0.9999999, 0.0], [-0.033079088, -5.9604645e-08, 1.4901161e-08, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.99999994, 7.951778e-07, 1.6138613e-07, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(7.8017774e-07, -0.9999999, -2.5518534e-07, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.32258937, 2.3756108e-07, -0.9999999, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.033079088, -5.9604645e-08, 1.4901161e-08, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 25 : 2 elements
     - key : littleFingerIntermediateBase
     ▿ value : simd_float4x4([[0.8148362, 0.037941266, 0.37263143, 0.0], [0.037941888, -0.81483614, -0.012240385, 0.0], [0.5178192, 0.024112256, -0.7631967, 0.0], [-0.10596717, -0.006834984, -0.051936373, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.8148362, 0.037941266, 0.37263143, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.037941888, -0.81483614, -0.012240385, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.5178192, 0.024112256, -0.7631967, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.10596717, -0.006834984, -0.051936373, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 26 : 2 elements
     - key : ringFingerIntermediateBase
     ▿ value : simd_float4x4([[0.92587763, 0.014444176, 0.18274917, 0.0], [0.014444381, -0.9258773, -0.0046599917, 0.0], [0.4457426, 0.0069542876, -0.9120192, 0.0], [-0.13024041, -0.0075870156, -0.024733022, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.92587763, 0.014444176, 0.18274917, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.014444381, -0.9258773, -0.0046599917, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.4457426, 0.0069542876, -0.9120192, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.13024041, -0.0075870156, -0.024733022, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
 */

/*
 27 elements
   
   
   ▿ 2 : 2 elements
     - key : littleFingerIntermediateBase
     ▿ value : simd_float4x4([[0.8148362, 0.037941266, 0.37263143, 0.0], [0.037941888, -0.81483614, -0.012240385, 0.0], [0.5178192, 0.024112256, -0.7631967, 0.0], [-0.10596717, -0.006834984, -0.051936373, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.8148362, 0.037941266, 0.37263143, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.037941888, -0.81483614, -0.012240385, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.5178192, 0.024112256, -0.7631967, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.10596717, -0.006834984, -0.051936373, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 3 : 2 elements
     - key : littleFingerIntermediateTip
     ▿ value : simd_float4x4([[0.78985167, -0.007688148, 0.40928298, 0.0], [0.01615763, -0.8110557, -0.030842746, 0.0], [0.5388034, 0.030974243, -0.74764985, 0.0], [-0.122990794, -0.006669283, -0.060757622, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.78985167, -0.007688148, 0.40928298, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.01615763, -0.8110557, -0.030842746, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.5388034, 0.030974243, -0.74764985, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.122990794, -0.006669283, -0.060757622, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 4 : 2 elements
     - key : middleFingerIntermediateTip
     ▿ value : simd_float4x4([[1.0025498, 0.32707313, -0.2630399, 0.0], [0.29106346, -0.91217947, 0.003218373, 0.0], [0.08683274, -0.079787895, -0.93264204, 0.0], [-0.1592448, -0.013880968, 0.005204305, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0025498, 0.32707313, -0.2630399, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.29106346, -0.91217947, 0.003218373, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.08683274, -0.079787895, -0.93264204, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.1592448, -0.013880968, 0.005204305, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   
   ▿ 6 : 2 elements
     - key : littleFingerMetacarpal
     ▿ value : simd_float4x4([[0.81483614, 0.03794287, 0.3726316, 0.0], [0.03794285, -0.81483614, -0.012239953, 0.0], [0.5178194, 0.024112256, -0.76319677, 0.0], [-0.027502343, -0.001280725, -0.012577042, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.81483614, 0.03794287, 0.3726316, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.03794285, -0.81483614, -0.012239953, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.5178194, 0.024112256, -0.76319677, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.027502343, -0.001280725, -0.012577042, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 7 : 2 elements
     - key : thumbIntermediateBase
     ▿ value : simd_float4x4([[1.013523, 0.2976249, -0.34443474, 0.0], [0.3073053, 0.07281572, 0.85514134, 0.0], [0.28528896, -0.9725521, -0.10785454, 0.0], [-0.05679615, -0.022052824, 0.04307328, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.013523, 0.2976249, -0.34443474, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.3073053, 0.07281572, 0.85514134, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.28528896, -0.9725521, -0.10785454, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.05679615, -0.022052824, 0.04307328, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   
   ▿ 9 : 2 elements
     - key : thumbTip
     ▿ value : simd_float4x4([[1.0230734, 0.26177305, -0.30091757, 0.0], [-0.024173602, -0.02449466, 0.96615714, 0.0], [0.25158575, -0.9811756, -0.097941376, 0.0], [-0.10422623, -0.035165012, 0.058204994, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0230734, 0.26177305, -0.30091757, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(-0.024173602, -0.02449466, 0.96615714, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.25158575, -0.9811756, -0.097941376, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.10422623, -0.035165012, 0.058204994, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 10 : 2 elements
     - key : indexFingerIntermediateBase
     ▿ value : simd_float4x4([[1.0468488, 0.016331777, -0.20386945, 0.0], [0.016331762, -1.0468487, -0.0052684774, 0.0], [0.1401025, 0.0021857168, -1.0272841, 0.0], [-0.122145586, -0.016576648, 0.02414848, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0468488, 0.016331777, -0.20386945, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.016331762, -1.0468487, -0.0052684774, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.1401025, 0.0021857168, -1.0272841, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.122145586, -0.016576648, 0.02414848, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 11 : 2 elements
     - key : thumbIntermediateTip
     ▿ value : simd_float4x4([[1.0230734, 0.26177305, -0.30091757, 0.0], [-0.024173602, -0.02449466, 0.96615714, 0.0], [0.25158575, -0.9811756, -0.097941376, 0.0], [-0.08263512, -0.029640555, 0.051854372, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0230734, 0.26177305, -0.30091757, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(-0.024173602, -0.02449466, 0.96615714, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.25158575, -0.9811756, -0.097941376, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.08263512, -0.029640555, 0.051854372, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 12 : 2 elements
     - key : ringFingerKnuckle
     ▿ value : simd_float4x4([[0.92587763, 0.014444176, 0.18274917, 0.0], [0.014444381, -0.9258773, -0.0046599917, 0.0], [0.4457426, 0.0069542876, -0.9120192, 0.0], [-0.09579092, -0.0014944673, -0.018907145, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.92587763, 0.014444176, 0.18274917, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.014444381, -0.9258773, -0.0046599917, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.4457426, 0.0069542876, -0.9120192, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.09579092, -0.0014944673, -0.018907145, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 13 : 2 elements
     - key : ringFingerTip
     ▿ value : simd_float4x4([[0.98518574, 0.21404435, -0.018870324, 0.0], [0.16753441, -0.8937117, 0.02460188, 0.0], [0.28400004, -0.027398847, -0.91259015, 0.0], [-0.1731233, -0.016076624, -0.02088666, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.98518574, 0.21404435, -0.018870324, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.16753441, -0.8937117, 0.02460188, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.28400004, -0.027398847, -0.91259015, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.1731233, -0.016076624, -0.02088666, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 14 : 2 elements
     - key : wrist
     ▿ value : simd_float4x4([[1.0, -2.9736347e-09, -7.036074e-09, 0.0], [9.3505435e-09, 1.0, 1.8542927e-09, 0.0], [-2.7364923e-08, 1.1591531e-08, 0.99999994, 0.0], [0.0, -5.9604645e-08, 2.9802322e-08, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0, -2.9736347e-09, -7.036074e-09, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(9.3505435e-09, 1.0, 1.8542927e-09, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(-2.7364923e-08, 1.1591531e-08, 0.99999994, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(0.0, -5.9604645e-08, 2.9802322e-08, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 15 : 2 elements
     - key : ringFingerMetacarpal
     ▿ value : simd_float4x4([[0.9258774, 0.014445185, 0.18274944, 0.0], [0.014445172, -0.9258774, -0.0046598576, 0.0], [0.44574282, 0.0069543025, -0.91201925, 0.0], [-0.031610996, -0.00049322844, -0.0062393397, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.9258774, 0.014445185, 0.18274944, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.014445172, -0.9258774, -0.0046598576, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.44574282, 0.0069543025, -0.91201925, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.031610996, -0.00049322844, -0.0062393397, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 16 : 2 elements
     - key : ringFingerIntermediateTip
     ▿ value : simd_float4x4([[0.98518574, 0.21404435, -0.018870324, 0.0], [0.16753441, -0.8937117, 0.02460188, 0.0], [0.28400004, -0.027398847, -0.91259015, 0.0], [-0.1539093, -0.012729406, -0.024279669, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.98518574, 0.21404435, -0.018870324, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.16753441, -0.8937117, 0.02460188, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.28400004, -0.027398847, -0.91259015, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.1539093, -0.012729406, -0.024279669, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 17 : 2 elements
     - key : indexFingerIntermediateTip
     ▿ value : simd_float4x4([[-0.0025706834, 0.8079938, -0.6434366, 0.0], [0.7976897, 0.084997006, -0.16467328, 0.0], [0.12962356, -0.51368606, -0.61946726, 0.0], [-0.12210166, -0.030382633, 0.035142705, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(-0.0025706834, 0.8079938, -0.6434366, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.7976897, 0.084997006, -0.16467328, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.12962356, -0.51368606, -0.61946726, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.12210166, -0.030382633, 0.035142705, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 18 : 2 elements
     - key : indexFingerMetacarpal
     ▿ value : simd_float4x4([[1.0468488, 0.016331738, -0.20386967, 0.0], [0.01633174, -1.0468488, -0.0052684476, 0.0], [0.14010239, 0.002185716, -1.0272843, 0.0], [-0.031610996, -0.00049322844, 0.0061561465, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0468488, 0.016331738, -0.20386967, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.01633174, -1.0468488, -0.0052684476, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.14010239, 0.002185716, -1.0272843, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.031610996, -0.00049322844, 0.0061561465, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 19 : 2 elements
     - key : littleFingerKnuckle
     ▿ value : simd_float4x4([[0.8148362, 0.037941266, 0.37263143, 0.0], [0.037941888, -0.81483614, -0.012240385, 0.0], [0.5178192, 0.024112256, -0.7631967, 0.0], [-0.08334042, -0.0038806796, -0.038112238, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.8148362, 0.037941266, 0.37263143, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.037941888, -0.81483614, -0.012240385, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.5178192, 0.024112256, -0.7631967, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.08334042, -0.0038806796, -0.038112238, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 20 : 2 elements
     - key : middleFingerMetacarpal
     ▿ value : simd_float4x4([[0.99999994, 7.951778e-07, 1.6138613e-07, 0.0], [7.8017774e-07, -0.9999999, -2.5518534e-07, 0.0], [0.32258937, 2.3756108e-07, -0.9999999, 0.0], [-0.033079088, -5.9604645e-08, 1.4901161e-08, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.99999994, 7.951778e-07, 1.6138613e-07, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(7.8017774e-07, -0.9999999, -2.5518534e-07, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.32258937, 2.3756108e-07, -0.9999999, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.033079088, -5.9604645e-08, 1.4901161e-08, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 21 : 2 elements
     - key : indexFingerTip
     ▿ value : simd_float4x4([[-0.0025706834, 0.8079938, -0.6434366, 0.0], [0.7976897, 0.084997006, -0.16467328, 0.0], [0.12962356, -0.51368606, -0.61946726, 0.0], [-0.113367856, -0.037646115, 0.046742216, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(-0.0025706834, 0.8079938, -0.6434366, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.7976897, 0.084997006, -0.16467328, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.12962356, -0.51368606, -0.61946726, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.113367856, -0.037646115, 0.046742216, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 22 : 2 elements
     - key : ringFingerIntermediateBase
     ▿ value : simd_float4x4([[0.92587763, 0.014444176, 0.18274917, 0.0], [0.014444381, -0.9258773, -0.0046599917, 0.0], [0.4457426, 0.0069542876, -0.9120192, 0.0], [-0.13024041, -0.0075870156, -0.024733022, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.92587763, 0.014444176, 0.18274917, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.014444381, -0.9258773, -0.0046599917, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.4457426, 0.0069542876, -0.9120192, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.13024041, -0.0075870156, -0.024733022, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 23 : 2 elements
     - key : thumbKnuckle
     ▿ value : simd_float4x4([[0.74584174, 0.43592486, -0.81623346, 0.0], [0.5667309, 0.15242, 0.57848674, 0.0], [0.4196111, -0.8940443, -0.2548538, 0.0], [-0.023581147, -0.01378262, 0.025806725, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(0.74584174, 0.43592486, -0.81623346, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.5667309, 0.15242, 0.57848674, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.4196111, -0.8940443, -0.2548538, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.023581147, -0.01378262, 0.025806725, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 24 : 2 elements
     - key : middleFingerTip
     ▿ value : simd_float4x4([[1.0025498, 0.32707313, -0.2630399, 0.0], [0.29106346, -0.91217947, 0.003218373, 0.0], [0.08683274, -0.079787895, -0.93264204, 0.0], [-0.17758265, -0.01919806, 0.012088716, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0025498, 0.32707313, -0.2630399, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(0.29106346, -0.91217947, 0.003218373, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(0.08683274, -0.079787895, -0.93264204, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(-0.17758265, -0.01919806, 0.012088716, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 25 : 2 elements
     - key : forearmArm
     ▿ value : simd_float4x4([[1.0, -2.9736347e-09, -7.036074e-09, 0.0], [9.3505435e-09, 1.0, 1.8542927e-09, 0.0], [-2.7364923e-08, 1.1591531e-08, 0.99999994, 0.0], [0.20047921, -5.9604645e-08, 1.4901161e-08, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0, -2.9736347e-09, -7.036074e-09, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(9.3505435e-09, 1.0, 1.8542927e-09, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(-2.7364923e-08, 1.1591531e-08, 0.99999994, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(0.20047921, -5.9604645e-08, 1.4901161e-08, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
   ▿ 26 : 2 elements
     - key : forearmWrist
     ▿ value : simd_float4x4([[1.0, -2.9736347e-09, -7.036074e-09, 0.0], [9.3505435e-09, 1.0, 1.8542927e-09, 0.0], [-2.7364923e-08, 1.1591531e-08, 0.99999994, 0.0], [0.0, -5.9604645e-08, 2.9802322e-08, 1.0]])
       ▿ columns : 4 elements
         ▿ .0 : SIMD4<Float>(1.0, -2.9736347e-09, -7.036074e-09, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .1 : SIMD4<Float>(9.3505435e-09, 1.0, 1.8542927e-09, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .2 : SIMD4<Float>(-2.7364923e-08, 1.1591531e-08, 0.99999994, 0.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
         ▿ .3 : SIMD4<Float>(0.0, -5.9604645e-08, 2.9802322e-08, 1.0)
           ▿ _storage : SIMD4Storage
             - _value : (Opaque Value)
 */
