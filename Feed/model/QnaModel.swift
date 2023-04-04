//
//  QnaModel.swift
//  Anding
//
//  Created by 이청준 on 2022/10/24.
//

import Foundation

// MARK: - QnaModel
struct QnaModel: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
    let result: QnaResult?
}


// MARK: - Result
struct QnaResult: Codable {
    let nickname, contents: String?
    let dailyTitle: String?
    let qnaBackgroundColor, filterID, qnaQuestionID, qnaQuestion: String?
    let dailyImage, qnaQuestionMadeFromUser: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {
        case nickname, contents, dailyTitle, qnaBackgroundColor
        case filterID = "filterId"
        case qnaQuestionID = "qnaQuestionId"
        case qnaQuestion, dailyImage, qnaQuestionMadeFromUser, createdAt
    }
}

