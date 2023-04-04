//
//  MyScrapModel.swift
//  Anding
//
//  Created by 이청준 on 2022/11/06.
//

import Foundation

// MARK: - MyScrapModel
struct OtherScrapModel: Codable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: [OtherScrapModelResult]?
}

// MARK: - Result
struct OtherScrapModelResult: Codable {
    var postID: Int?
    var dailyTitle, qnaBackgroundColor: String?
    var filterID: String?
    var qnaQuestionID, qnaQuestion: String?
    var dailyImage: String?
    var qnaQuestionMadeFromUser: String?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case dailyTitle, qnaBackgroundColor
        case filterID = "filterId"
        case qnaQuestionID = "qnaQuestionId"
        case qnaQuestion, dailyImage, qnaQuestionMadeFromUser
    }
}

// MARK: - Encode/decode helpers
//
//class JSONNull3: Codable, Hashable {
//
//    public static func == (lhs: JSONNull3, rhs: JSONNull3) -> Bool {
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
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
