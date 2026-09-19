//
//  Menus.swift
//  FoodOrderApp
//
//  Created by Vikash on 19/09/26.
//

import Foundation

// MARK: - Domain Models
struct MenuItem: Identifiable, Codable, Equatable {
    let id: String
    let name: String
    let description: String
    let price: Double
    let imageUrl: String

    enum CodingKeys: String, CodingKey {
        case id, name, description, price
        case imageUrl = "image_url"
    }
}

struct OrderItemRequest: Encodable {
    let item_id: String
    let quantity: Int
}

struct CreateOrderRequest: Encodable {
    let items: [OrderItemRequest]
}

struct OrderResponse: Decodable, Equatable {
    let order_id: String
    let total_amount: Double
    let status: String
}
