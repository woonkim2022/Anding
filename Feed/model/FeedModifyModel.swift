//
//  DailyModifyVC.swift
//  
//
//  Created by 이청준 on 2022/11/12.
//

import Foundation

// MARK: - DailyModifyVC
struct FeedModifyModel: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
}

class FeedModifyModelJSONNull: Codable, Hashable {

    public static func == (lhs: FeedModifyModelJSONNull, rhs: FeedModifyModelJSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(FeedModifyModelJSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
