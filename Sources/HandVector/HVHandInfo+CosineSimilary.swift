//
//  HandVectorMatcher+CosineSimilary.swift
//  HandVector
//
//  Created by 许同学 on 2024/8/20.
//

import ARKit
import Accelerate


internal enum HVVectorMath {
    
    /// Batch vector dot product - optimized version selector
    /// Computes dot products for multiple vector pairs
    /// - Parameters:
    ///   - vectorsA: First array of vectors
    ///   - vectorsB: Second array of vectors (must have same length as vectorsA)
    /// - Returns: Array of dot product results for each vector pair
    static func batchDotProduct(_ vectorsA: [simd_float3], _ vectorsB: [simd_float3]) -> [Float] {
        precondition(vectorsA.count == vectorsB.count, "Vector arrays must have equal length")
        let count = vectorsA.count
        guard count > 0 else { return [] }
        
        // For typical hand tracking data (~27 joints), direct simd is fastest
        if count < 10 {
            var results = [Float](repeating: 0, count: count)
            for i in 0..<count {
                results[i] = simd_dot(vectorsA[i], vectorsB[i])
            }
            return results
        }
        
        // For larger datasets, use BLAS
        return batchDotProductBLAS(vectorsA, vectorsB)
    }
    
    /// BLAS-based batch dot product using cblas_sdot
    /// Most efficient for medium to large datasets
    /// - Parameters:
    ///   - vectorsA: First array of vectors
    ///   - vectorsB: Second array of vectors (must have same length as vectorsA)
    /// - Returns: Array of dot product results for each vector pair
    private static func batchDotProductBLAS(_ vectorsA: [simd_float3], _ vectorsB: [simd_float3]) -> [Float] {
        let count = vectorsA.count
        
        // Flatten simd_float3 into contiguous Float arrays
        var flatA = [Float](repeating: 0, count: count * 3)
        var flatB = [Float](repeating: 0, count: count * 3)
        
        for i in 0..<count {
            let offset = i * 3
            flatA[offset] = vectorsA[i].x
            flatA[offset + 1] = vectorsA[i].y
            flatA[offset + 2] = vectorsA[i].z
            flatB[offset] = vectorsB[i].x
            flatB[offset + 1] = vectorsB[i].y
            flatB[offset + 2] = vectorsB[i].z
        }
        
        // Compute dot products using BLAS cblas_sdot
        var results = [Float](repeating: 0, count: count)
        
        // Use withUnsafeMutableBufferPointer for safe pointer access
        flatA.withUnsafeMutableBufferPointer { bufferA in
            flatB.withUnsafeMutableBufferPointer { bufferB in
                for i in 0..<count {
                    let offset = i * 3
                    let ptrA = bufferA.baseAddress! + offset
                    let ptrB = bufferB.baseAddress! + offset
                    // cblas_sdot(N, X, incX, Y, incY)
                    // Computes: X[0]*Y[0] + X[1]*Y[1] + X[2]*Y[2]
                    results[i] = cblas_sdot(Int32(3), ptrA, 1, ptrB, 1)
                }
            }
        }
        
        return results
    }
    
    /// vDSP-based batch dot product (for comparison/fallback)
    /// Uses element-wise multiplication followed by summation
    private static func batchDotProductVDSP(_ vectorsA: [simd_float3], _ vectorsB: [simd_float3]) -> [Float] {
        let count = vectorsA.count
        
        // Flatten simd_float3 into contiguous Float arrays
        var flatA = [Float](repeating: 0, count: count * 3)
        var flatB = [Float](repeating: 0, count: count * 3)
        
        for i in 0..<count {
            flatA[i * 3] = vectorsA[i].x
            flatA[i * 3 + 1] = vectorsA[i].y
            flatA[i * 3 + 2] = vectorsA[i].z
            flatB[i * 3] = vectorsB[i].x
            flatB[i * 3 + 1] = vectorsB[i].y
            flatB[i * 3 + 2] = vectorsB[i].z
        }
        
        // Use vDSP to compute element-wise products
        var products = [Float](repeating: 0, count: count * 3)
        vDSP_vmul(flatA, 1, flatB, 1, &products, 1, vDSP_Length(count * 3))
        
        // Sum every 3 elements to get dot product results
        var results = [Float](repeating: 0, count: count)
        for i in 0..<count {
            let baseIdx = i * 3
            results[i] = products[baseIdx] + products[baseIdx + 1] + products[baseIdx + 2]
        }
        
        return results
    }
    
    /// Batch compute cosine similarity and return mean - optimized version
    /// - Parameters:
    ///   - vectorsA: First array of normalized vectors
    ///   - vectorsB: Second array of normalized vectors
    /// - Returns: Mean cosine similarity
    static func batchCosineSimilarityMean(_ vectorsA: [simd_float3], _ vectorsB: [simd_float3]) -> Float {
        let count = vectorsA.count
        guard count > 0 else { return 0 }
        
        // For small datasets, compute directly without intermediate array
        if count < 20 {
            var sum: Float = 0
            for i in 0..<count {
                sum += simd_dot(vectorsA[i], vectorsB[i])
            }
            return sum / Float(count)
        }
        
        // For larger datasets, use batch processing
        let dotProducts = batchDotProduct(vectorsA, vectorsB)
        
        // Use vDSP to compute mean
        var mean: Float = 0
        vDSP_meanv(dotProducts, 1, &mean, vDSP_Length(dotProducts.count))
        return mean
    }
    
    /// Compute sum of float array
    static func sum(_ values: [Float]) -> Float {
        guard !values.isEmpty else { return 0 }
        
        // For small arrays, direct sum is faster
        if values.count < 32 {
            return values.reduce(0, +)
        }
        
        // Use vDSP for larger arrays
        var result: Float = 0
        vDSP_sve(values, 1, &result, vDSP_Length(values.count))
        return result
    }
}

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
    func similarity(of finger: HVJointOfFinger, to vector: HVHandInfo) -> Float {
        return similarity(of: [finger], to: vector)
    }
    /// Fingers your selected
    func similarity(of fingers: Set<HVJointOfFinger>, to vector: HVHandInfo) -> Float {
        var similarity: Float = 0
        let jointNames = fingers.jointGroupNames
        similarity = jointNames.map { name in
            let dv = dot(vector.vectorEndTo(name), self.vectorEndTo(name))
            return dv
        }.reduce(0) { $0 + $1 }
        
        similarity /= Float(jointNames.count)
        return similarity
    }
    /// Fingers and wrist and forearm
    func similarity(to vector: HVHandInfo) -> Float {
        return similarity(of: .all, to: vector)
    }
    /// all
    func similarities(to vector: HVHandInfo) -> (average: Float, eachFinger: [HVJointOfFinger: Float]) {
        return averageAndEachSimilarities(of: .all, to: vector)
    }
    func averageAndEachSimilarities(of fingers: Set<HVJointOfFinger>, to vector: HVHandInfo) -> (average: Float, eachFinger: [HVJointOfFinger: Float]) {
        
        let fingerTotal = fingers.reduce(into: [HVJointOfFinger: Float]()) { partialResult, finger in
            let fingerResult = finger.jointGroupNames.reduce(into: Float.zero) { partialResult, name in
                let dv = dot(vector.vectorEndTo(name), self.vectorEndTo(name))
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
        return (average: jointTotal / Float(jointCount), eachFinger: fingerScore)
    }
    
    // MARK: - AMX-Optimized Batch Similarity Calculation Methods
    
    /// AMX-accelerated batch joint similarity calculation
    /// Suitable for scenarios requiring simultaneous calculation of multiple joint similarities
    func similarityAMX(of joints: Set<HandSkeleton.JointName>, to vector: HVHandInfo) -> Float {
        let jointArray = Array(joints)
        let vectorsA = jointArray.map { vector.vectorEndTo($0) }
        let vectorsB = jointArray.map { self.vectorEndTo($0) }
        return HVVectorMath.batchCosineSimilarityMean(vectorsA, vectorsB)
    }
    
    /// AMX-accelerated finger similarity calculation
    func similarityAMX(of fingers: Set<HVJointOfFinger>, to vector: HVHandInfo) -> Float {
        let jointNames = Array(fingers.jointGroupNames)
        let vectorsA = jointNames.map { vector.vectorEndTo($0) }
        let vectorsB = jointNames.map { self.vectorEndTo($0) }
        return HVVectorMath.batchCosineSimilarityMean(vectorsA, vectorsB)
    }
    
    /// AMX-accelerated full hand similarity calculation
    func similarityAMX(to vector: HVHandInfo) -> Float {
        return similarityAMX(of: .all, to: vector)
    }
    
    /// AMX-accelerated batch similarity calculation, returns average and per-finger scores
    func averageAndEachSimilaritiesAMX(of fingers: Set<HVJointOfFinger>, to vector: HVHandInfo) -> (average: Float, eachFinger: [HVJointOfFinger: Float]) {
        var fingerScores = [HVJointOfFinger: Float]()
        var allDotProducts = [Float]()
        
        for finger in fingers {
            let jointNames = Array(finger.jointGroupNames)
            let vectorsA = jointNames.map { vector.vectorEndTo($0) }
            let vectorsB = jointNames.map { self.vectorEndTo($0) }
            let dotProducts = HVVectorMath.batchDotProduct(vectorsA, vectorsB)
            
            allDotProducts.append(contentsOf: dotProducts)
            fingerScores[finger] = HVVectorMath.sum(dotProducts) / Float(jointNames.count)
        }
        
        let average = HVVectorMath.sum(allDotProducts) / Float(allDotProducts.count)
        return (average: average, eachFinger: fingerScores)
    }
    
    /// AMX-accelerated full hand similarity calculation, returns average and per-finger scores
    func similaritiesAMX(to vector: HVHandInfo) -> (average: Float, eachFinger: [HVJointOfFinger: Float]) {
        return averageAndEachSimilaritiesAMX(of: .all, to: vector)
    }
}

