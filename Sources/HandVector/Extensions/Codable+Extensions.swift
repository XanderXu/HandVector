//
//  Codable+Extensions.swift
//  HandVector
//
//  Created by 许同学 on 2023/11/30.
//

import Foundation


extension Encodable {
    func toJson(encoding: String.Encoding = .utf8) -> String? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return String(data: data, encoding: encoding)
    }
}
extension String {
    func toModel<T>(_ type: T.Type, using encoding: String.Encoding = .utf8) -> T? where T : Decodable {
        guard let data = self.data(using: encoding) else { return nil }
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print(error)
        }
        return nil
    }
}

//extension simd_float4x4: Codable {
//    public init(from decoder: any Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        
//        let cols = try container.decode([SIMD4<Float>].self)
//        self.init(columns: (cols[0], cols[1], cols[2], cols[3]))
//    }
//    public func encode(to encoder: any Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encode([columns.0, columns.1, columns.2, columns.3])
//    }
//}
