//
//  MyCountModel.swift
//  Anding
//
//  Created by 이청준 on 2022/11/07.
//

import Foundation

// MARK: - MyCountModel
struct MyCountModel: Codable {
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    var result: MyCountModelResult?
}

// MARK: - Result
struct MyCountModelResult: Codable {
    var myPostOfClipCount: Int?
}
