//
//  AQcountModel.swift
//  Anding
//
//  Created by 이청준 on 2022/11/07.
//

import Foundation
import Foundation

// MARK: - AQcountModel
struct ARcountModel: Codable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: ARcountModelResult?
}

// MARK: - Result
struct ARcountModelResult: Codable {
    var dailyPostCount: Int?
}
