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


