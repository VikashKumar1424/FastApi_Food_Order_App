
import SwiftUI
import Observation

// MARK: - Content View

struct ContentView: View {

    @State private var store = FoodStore()

    var body: some View {

        NavigationStack {

            ZStack(alignment: .bottom) {

                Color(.systemGroupedBackground)
                    .ignoresSafeArea()

                content

                // Floating Cart
                if !store.cart.isEmpty {
                    CartBar(store: store)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 8)
                }
            }
            .navigationTitle("Food Order")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {

                    Image(systemName: "fork.knife.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.orange)
                }
            }
            .task {

                if case .idle = store.state {
                    await store.loadMenu()
                }
            }
            .alert(
                "Order Confirmed 🎉",
                isPresented: Binding(
                    get: {
                        store.lastOrder != nil
                    },
                    set: { value in
                        if !value {
                            store.clearOrderAlert()
                        }
                    }
                )
            ) {

                Button("Done", role: .cancel) {
                    store.clearOrderAlert()
                }

            } message: {

                if let order = store.lastOrder {

                    Text(
                        """
                        Order #\(order.order_id)

                        Total: $\(order.total_amount, specifier: "%.2f")

                        Status: \(order.status.capitalized)
                        """
                    )
                }
            }
        }
    }

    // MARK: - Content

    @ViewBuilder
    private var content: some View {

        switch store.state {

        case .idle:

            Color.clear

        case .loading:

            LoadingView()

        case .loaded(let menu):

            MenuView(
                menu: menu,
                store: store
            )

        case .error(let message):

            ErrorView(
                message: message
            ) {
                Task {
                    await store.loadMenu()
                }
            }
        }
    }
}


// MARK: - Menu View

private struct MenuView: View {

    let menu: [MenuItem]
    let store: FoodStore

    var body: some View {

        ScrollView {

            LazyVStack(
                alignment: .leading,
                spacing: 16
            ) {

                // MARK: Header

                VStack(
                    alignment: .leading,
                    spacing: 6
                ) {

                    Text("Good food.")
                        .font(.system(
                            size: 32,
                            weight: .bold,
                            design: .rounded
                        ))

                    Text("Made fresh, just for you.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                // MARK: Section Header

                HStack {

                    Text("Today's Menu")
                        .font(.title3)
                        .fontWeight(.bold)

                    Spacer()

                    Text("\(menu.count) items")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 20)

                // MARK: Menu Cards

                ForEach(menu) { item in

                    MenuCard(
                        item: item,
                        quantity: store.cart[item.id] ?? 0,
                        onAdd: {
                            store.addToCart(item: item)
                        },
                        onRemove: {
                            store.removeFromCart(item: item)
                        }
                    )
                    .padding(.horizontal, 16)
                }

                // Bottom spacing for floating cart

                Color.clear
                    .frame(height: 80)
            }
            .padding(.vertical, 12)
        }
        .scrollIndicators(.hidden)
    }
}


// MARK: - Menu Card

private struct MenuCard: View {

    let item: MenuItem
    let quantity: Int

    let onAdd: () -> Void
    let onRemove: () -> Void

    var body: some View {

        VStack(spacing: 0) {

            // MARK: Image

            AsyncImage(
                url: URL(string: item.imageUrl)
            ) { phase in

                switch phase {

                case .empty:

                    ZStack {

                        Color.gray.opacity(0.12)

                        ProgressView()
                    }

                case .success(let image):

                    image
                        .resizable()
                        .scaledToFill()

                case .failure:

                    ZStack {

                        Color.gray.opacity(0.12)

                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(.secondary)
                    }

                @unknown default:

                    Color.gray.opacity(0.12)
                }
            }
            .frame(height: 190)
            .frame(maxWidth: .infinity)
            .clipped()

            // MARK: Details

            VStack(
                alignment: .leading,
                spacing: 10
            ) {

                HStack(alignment: .top) {

                    VStack(
                        alignment: .leading,
                        spacing: 5
                    ) {

                        Text(item.name)
                            .font(.title3)
                            .fontWeight(.bold)

                        Text(item.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }

                    Spacer()

                    Text(
                        "$\(item.price, specifier: "%.2f")"
                    )
                    .font(.headline)
                    .fontWeight(.bold)
                }

                // MARK: Quantity Controls

                HStack {

                    if quantity > 0 {

                        HStack(spacing: 16) {

                            Button(action: onRemove) {

                                Image(systemName: "minus")
                                    .fontWeight(.bold)
                                    .frame(
                                        width: 34,
                                        height: 34
                                    )
                            }
                            .buttonStyle(.bordered)

                            Text("\(quantity)")
                                .font(.headline)
                                .frame(minWidth: 20)

                            Button(action: onAdd) {

                                Image(systemName: "plus")
                                    .fontWeight(.bold)
                                    .frame(
                                        width: 34,
                                        height: 34
                                    )
                            }
                            .buttonStyle(.borderedProminent)
                        }

                    } else {

                        Button(action: onAdd) {

                            Label(
                                "Add to Cart",
                                systemImage: "plus"
                            )
                            .fontWeight(.semibold)
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    Spacer()
                }
            }
            .padding(16)
        }
        .background(.background)
        .clipShape(
            RoundedRectangle(
                cornerRadius: 20,
                style: .continuous
            )
        )
        .shadow(
            color: .black.opacity(0.06),
            radius: 10,
            x: 0,
            y: 4
        )
    }
}


// MARK: - Cart Bar

private struct CartBar: View {

    let store: FoodStore

    private var totalItems: Int {

        store.cart.values.reduce(0, +)
    }

    var body: some View {

        HStack(spacing: 14) {

            // Cart Icon

            ZStack {

                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(
                        width: 44,
                        height: 44
                    )

                Image(systemName: "cart.fill")
                    .font(.headline)
            }

            // Cart Information

            VStack(
                alignment: .leading,
                spacing: 2
            ) {

                Text(
                    "\(totalItems) \(totalItems == 1 ? "item" : "items")"
                )
                .font(.headline)

                Text("Ready to order")
                    .font(.caption)
                    .opacity(0.85)
            }

            Spacer()

            // Order Button

            Button {

                Task {
                    await store.submitOrder()
                }

            } label: {

                if store.isPlacingOrder {

                    ProgressView()
                        .tint(.white)

                } else {

                    Text("Place Order")
                        .fontWeight(.bold)
                }
            }
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .padding(.vertical, 12)
            .background(.black.opacity(0.25))
            .clipShape(
                Capsule()
            )
            .disabled(store.isPlacingOrder)
        }
        .foregroundStyle(.white)
        .padding(10)
        .background(
            LinearGradient(
                colors: [
                    .orange,
                    .red
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 22,
                style: .continuous
            )
        )
        .shadow(
            color: .black.opacity(0.2),
            radius: 15,
            x: 0,
            y: 8
        )
    }
}


// MARK: - Loading View

private struct LoadingView: View {

    var body: some View {

        VStack(spacing: 18) {

            ZStack {

                Circle()
                    .fill(.orange.opacity(0.12))
                    .frame(
                        width: 90,
                        height: 90
                    )

                Image(systemName: "fork.knife")
                    .font(.system(size: 34))
                    .foregroundStyle(.orange)
            }

            ProgressView()

            Text("Preparing your menu...")
                .font(.headline)

            Text("Please wait a moment")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}


// MARK: - Error View

private struct ErrorView: View {

    let message: String
    let retry: () -> Void

    var body: some View {

        VStack(spacing: 18) {

            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 50))
                .foregroundStyle(.orange)

            Text("Something went wrong")
                .font(.title2)
                .fontWeight(.bold)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)

            Button(action: retry) {

                Label(
                    "Try Again",
                    systemImage: "arrow.clockwise"
                )
                .fontWeight(.semibold)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
}


// MARK: - Preview

#Preview {

    ContentView()
}

