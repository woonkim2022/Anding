//
//  IDDeleteModel.swift
//  Anding
//
//  Created by 이청준 on 2022/11/13.
//
import Foundation

// MARK: - IDDeleteModel
struct IDDeleteModel: Codable {
    let isSuccess: Bool?
    let code: Int?
    let message: String?
}
