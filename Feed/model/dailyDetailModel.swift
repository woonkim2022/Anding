//
//  dailyDetailModel.swift
//  Anding
//
//  Created by 이청준 on 2022/10/24.
//

import Foundation

// MARK: - DailyDetailModel
struct DailyDetailModel: Codable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: DailyDetailResult?
}

// MARK: - Result
struct DailyDetailResult: Codable {
    let nickname, contents: String?
    var dailyTitle: String?
    var qnaBackgroundColor, filterID, qnaQuestionID, qnaQuestion: String?
    var dailyImage, qnaQuestionMadeFromUser: String?
    var createdAt: String?

    enum CodingKeys: String, CodingKey {
        case nickname, contents, dailyTitle, qnaBackgroundColor
        case filterID = "filterId"
        case qnaQuestionID = "qnaQuestionId"
        case qnaQuestion, dailyImage, qnaQuestionMadeFromUser, createdAt
    }
}
