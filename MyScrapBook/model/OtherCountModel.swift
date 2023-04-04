//
//  OtherCountModel.swift
//  Anding
//
//  Created by 이청준 on 2022/11/07.
//

import Foundation

// MARK: - OtherCountModel
struct OtherCountModel: Codable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: OtherCountModelResult?
}

// MARK: - Result
struct OtherCountModelResult: Codable {
    var otherPostOfClipCount: Int?
}
