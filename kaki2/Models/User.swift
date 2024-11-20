//
//  User.swift
//  kaki2
//
//  Created by 林　一貴 on 2024/09/29.
//

import Foundation

struct User :Identifiable, Codable{
    let id: String
    let name: String
    let email: String
    let age: Int
    var photoUrl: String?
    var message: String?
}

extension User {
    static let MOCK_USER1 = User(id: "1", name: "ブルー", email: "test1@example.com", age: 30, photoUrl: "user01", message: "紹介メッセージ1")
    static let MOCK_USER2 = User(id: "2", name: "パープル", email: "test2@example.com", age: 28, photoUrl: "user02", message: "紹介メッセージ2")
    static let MOCK_USER3 = User(id: "3", name: "ピンク", email: "test3@example.com", age: 37, photoUrl: "user03", message: "紹介メッセージ3")
    static let MOCK_USER4 = User(id: "4", name: "グリーン", email: "test4@example.com", age: 25, photoUrl: "user04", message: "紹介メッセージ4")
    static let MOCK_USER5 = User(id: "5", name: "イエロー", email: "test5@example.com", age: 34, photoUrl: "user05")
    static let MOCK_USER6 = User(id: "6", name: "オレンジ", email: "test6@example.com", age: 24, message: "紹介メッセージ6")
    static let MOCK_USER7 = User(id: "7", name: "レッド", email: "test7@example.com", age: 36)
}


