//
//  UserData.swift
//  Anding
//
//  Created by woonKim on 2022/10/12.
//

import Foundation
import Alamofire

struct UserData: Codable {
    let code: Int?
    let message: String?
    let result: Result
}

struct Result: Codable {
    let authenticationNumber: String?
    let jwt: String?
    let nickname: String?
    let introduction: String?
    let profileImage: String?
    let postList: [PostList]?
    let id: Int?
    let title, detail, coverColor, titleColor: String?
    let objetColor: Int?
    let createdAt: String?
}

struct PostList: Codable {
    let postID: Int
    let filterID: String
    let qnaBackgroundColor, qnaQuestionID, qnaQuestion: String?
    let qnaQuestionMadeFromUser: JSONNull?
    let dailyTitle: String?
    let dailyImage: String?
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case filterID = "filterId"
        case qnaBackgroundColor
        case qnaQuestionID = "qnaQuestionId"
        case qnaQuestion, qnaQuestionMadeFromUser, dailyTitle, dailyImage, createdAt
    }
}

struct BookPage: Codable {
    let bookPage: BookPageGet?
    enum CodingKeys: String, CodingKey {
        case bookPage = "result"
    }
}

struct BookPageGet: Codable {
    let contents, createdAt: String?
    let currentPage: Int?
    let dailyImage: String?
    let dailyTitle, filterID: String?
    let lastPage: Int?
    let qnaBackgroundColor, qnaQuestion, qnaQuestionID, qnaQuestionMadeFromUser: String?

    enum CodingKeys: String, CodingKey {
        case contents, createdAt, currentPage, dailyImage, dailyTitle
        case filterID = "filterId"
        case lastPage, qnaBackgroundColor, qnaQuestion
        case qnaQuestionID = "qnaQuestionId"
        case qnaQuestionMadeFromUser
    }
}

struct SameIdNickName: Codable {
    let code: Int?
    let message: String?
    let nickname: String?
}

struct SignUp: Codable {
    let code: Int?
    let nickname: String?
    let password: String?
    let phone: String?
    let userId: String?
}

struct ModifyUserProfile: Codable {
    let code: Int?
}

struct MyPageProfile: Codable {
    let code: Int?
    let result: Result
}

struct MyPageWriteBookCount: Codable {
    let code: Int?
    let result: Int?
}

struct BookGet: Codable {
    let bookGetResult: [BookGetArray]?
    enum CodingKeys: String, CodingKey {
        case bookGetResult = "result"
    }
}

struct UserProfieEdit: Codable {
    let code: Int
    let message: String
}

struct BookGetArray: Codable {
      let id: Int?
      let title, detail, coverColor, titleColor: String?
      let objetColor: Int?
      let createdAt: String?
}

struct Login: Codable {
    let code: Int?
    let message: String?
    let result: Result?
}

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

