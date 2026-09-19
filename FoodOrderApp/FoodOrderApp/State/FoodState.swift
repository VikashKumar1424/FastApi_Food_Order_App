//
//  FoodState.swift
//  FoodOrderApp
//
//  Created by Vikash on 19/09/26.
//

import Foundation
import Observation

// MARK: - Explicit View State

enum FoodViewState: Equatable {
    case idle
    case loading
    case loaded(menu: [MenuItem])
    case error(message: String)
}

// MARK: - Store / State Manager

@MainActor
@Observable
final class FoodStore {

    // MARK: - Screen State

    private(set) var state: FoodViewState = .idle

    // MARK: - Cart State

    // Item ID : Quantity
    private(set) var cart: [String: Int] = [:]

    // MARK: - Order State

    private(set) var lastOrder: OrderResponse?

    private(set) var isPlacingOrder = false

    // MARK: - Services

    private let service = FoodAPIService()

    // MARK: - Actions

    func loadMenu() async {

        state = .loading

        do {
            let items = try await service.fetchMenu()

            state = .loaded(menu: items)

        } catch {
            state = .error(
                message: error.localizedDescription
            )
        }
    }

    // MARK: - Cart

    func addToCart(item: MenuItem) {

        cart[item.id, default: 0] += 1
    }

    func removeFromCart(item: MenuItem) {

        if let count = cart[item.id], count > 1 {
            cart[item.id] = count - 1
        } else {
            cart.removeValue(forKey: item.id)
        }
    }

    // MARK: - Submit Order

    func submitOrder() async {

        guard !cart.isEmpty else {
            return
        }

        isPlacingOrder = true

        defer {
            isPlacingOrder = false
        }

        let payload = cart.map {
            OrderItemRequest(
                item_id: $0.key,
                quantity: $0.value
            )
        }

        do {

            let response = try await service.placeOrder(
                items: payload
            )

            lastOrder = response

            cart.removeAll()

        } catch {

            state = .error(
                message: "Order failed: \(error.localizedDescription)"
            )
        }
    }

    // MARK: - Clear Order

    func clearOrderAlert() {

        lastOrder = nil
    }
}
