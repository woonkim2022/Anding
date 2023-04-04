//
//  AQallModel.swift
//  Anding
//
//  Created by 이청준 on 2022/11/07.
//

import Foundation

// MARK: - AQallModel
struct AQallModel: Codable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: [AQallModelResult]?
}

// MARK: - Result
struct AQallModelResult: Codable {
    var postID: Int?
    var qnaBackgroundColor, filterID, qnaQuestionID, qnaQuestion: String?
    var qnaQuestionMadeFromUser: String?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case qnaBackgroundColor
        case filterID = "filterId"
        case qnaQuestionID = "qnaQuestionId"
        case qnaQuestion, qnaQuestionMadeFromUser
    }
}
//
//// MARK: - Encode/decode helpers
//
//class JSONNull4: Codable, Hashable {
//
//    public static func == (lhs: JSONNull4, rhs: JSONNull4) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull4.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
