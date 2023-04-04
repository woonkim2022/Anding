//
//  FeedUploadModel.swift
//  Anding
//
//  Created by 이청준 on 2022/10/18.
//


import Foundation

// MARK: - FeedUploadModel
struct FeedUploadModel: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
}
