//
//  FeedMainModel.swift
//  Anding
//
//  Created by 이청준 on 2022/10/25.
//

import Foundation

// MARK: - FeedMainModel
struct FeedMainModel: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
    let result: [FeedMainModelResult]?
}

// MARK: - Result
struct FeedMainModelResult: Codable {
    let postID: Int?
    let dailyTitle, qnaBackgroundColor: String?
    let filterID: String?
    let qnaQuestionID, qnaQuestion: String?
    let dailyImage: String?
    let qnaQuestionMadeFromUser: String?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case dailyTitle, qnaBackgroundColor
        case filterID = "filterId"
        case qnaQuestionID = "qnaQuestionId"
        case qnaQuestion, dailyImage, qnaQuestionMadeFromUser
    }
}

enum FilterID: String, Codable {
    case b = "b"
    case d = "d"
    case e = "e"
    case f = "f"
    case m = "m"
    case r = "r"
    case s = "s"
    case u = "u"
}
