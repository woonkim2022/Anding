//
//  ARcountModel.swift
//  Anding
//
//  Created by 이청준 on 2022/11/07.
//


import Foundation

// MARK: - ARcountModel
struct AQcountModel: Codable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: AQcountModelResult?
}

// MARK: - Result
struct AQcountModelResult: Codable {
    var qnaPostCount: Int?
}
