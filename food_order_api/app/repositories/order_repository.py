from app.models.food import Order


class OrderRepository:

    def __init__(self):
        self._orders: dict[str, Order] = {}

    def save(self, order: Order) -> Order:
        self._orders[order.order_id] = order
        return order

    def get_by_id(self, order_id: str) -> Order | None:
        return self._orders.get(order_id)