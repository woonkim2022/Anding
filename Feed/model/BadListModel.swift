//
//  reportModel.swift
//  Anding
//
//  Created by 이청준 on 2022/11/11.
//

import Foundation

// MARK: - ReportModel
struct BadListModel: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
    let result: [BadListModelResult]?
}


// MARK: - Result
struct BadListModelResult: Codable {
    let reasonID: Int?
    let reasonContents: String?

    enum CodingKeys: String, CodingKey {
        case reasonID = "reasonId"
        case reasonContents
    }
}
