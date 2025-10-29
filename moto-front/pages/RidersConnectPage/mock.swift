//
//  mock.swift
//  moto-front
//
//  Created by Алексей on 28.10.2025.
//


import Foundation

struct User: Identifiable {
    let id: UUID
    let name: String
//    let surname: String
//    let username: String
//    let bikeModel: String
//    let avatar: String
//    let isOnline: Bool
//    let city: String
//    let rating: Double
//    let ridesCount: Int
}

let mockUsers: [User] = [
    User(
        id: UUID(),
        name: "Александр"
    ),
    User(
        id: UUID(),
        name: "Света"
    )
]

