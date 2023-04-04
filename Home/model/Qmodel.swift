//
//  Qmodel.swift
//  Anding
//
//  Created by 이청준 on 2022/10/17.
//
import Foundation

// MARK: - Qmodel
struct Qmodel: Codable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: QResult?
}

// MARK: - Result
struct QResult: Codable {
    var qnaQuestionID, contents: String?
    var remaningNumberOfFilter, remaningNumberOfAll: Int?

    enum CodingKeys: String, CodingKey {
        case qnaQuestionID = "qnaQuestionId"
        case contents, remaningNumberOfFilter, remaningNumberOfAll
    }
}
