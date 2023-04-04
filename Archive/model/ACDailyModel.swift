//
//  ACDailyModel.swift
//  Anding
//
//  Created by 이청준 on 2022/11/08.
//

import Foundation

// MARK: - ACDailyModel
struct ACDailyModel: Codable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: [ACDailyModelResult]?
}

// MARK: - Result
struct ACDailyModelResult: Codable {
    var postID: Int?
    var dailyTitle: String?
    var dailyImage: String?

    enum CodingKeys: String, CodingKey {
        case postID = "postId"
        case dailyTitle, dailyImage
    }
}

