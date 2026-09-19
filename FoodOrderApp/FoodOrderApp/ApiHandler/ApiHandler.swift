//
//  ApiHandler.swift
//  FoodOrderApp
//
//  Created by Vikash on 19/09/26.
//

import Foundation

actor FoodAPIService {

    private let baseURL = "http://localhost:8000"

    // MARK: - GET Menu

    func fetchMenu() async throws -> [MenuItem] {

        guard let url = URL(string: "\(baseURL)/menu") else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        // Check HTTP response
        if let httpResponse = response as? HTTPURLResponse {
            guard 200..<300 ~= httpResponse.statusCode else {
                throw URLError(.badServerResponse)
            }
        }

        // Debug response
        print("Menu Response:")
        print(String(data: data, encoding: .utf8) ?? "Invalid response")

        return try JSONDecoder().decode(
            [MenuItem].self,
            from: data
        )
    }

    // MARK: - POST Order

    func placeOrder(
        items: [OrderItemRequest]
    ) async throws -> OrderResponse {

        guard let url = URL(string: "\(baseURL)/orders") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)

        request.httpMethod = "POST"

        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )

        request.httpBody = try JSONEncoder().encode(
            CreateOrderRequest(items: items)
        )

        let (data, response) = try await URLSession.shared.data(
            for: request
        )

        // Check HTTP response
        if let httpResponse = response as? HTTPURLResponse {
            guard 200..<300 ~= httpResponse.statusCode else {

                print(
                    "Server Error:",
                    String(data: data, encoding: .utf8) ?? ""
                )

                throw URLError(.badServerResponse)
            }
        }

        // Debug response
        print("Order Response:")
        print(String(data: data, encoding: .utf8) ?? "Invalid response")

        return try JSONDecoder().decode(
            OrderResponse.self,
            from: data
        )
    }
}
