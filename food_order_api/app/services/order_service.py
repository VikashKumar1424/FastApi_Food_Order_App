from uuid import uuid4

from app.core.exceptions import (
    EmptyOrderException,
    MenuItemNotFoundException,
)
from app.models.food import Order
from app.repositories.menu_repository import MenuRepository
from app.repositories.order_repository import OrderRepository
from app.schemas.order import CreateOrderRequest


class OrderService:

    def __init__(
        self,
        menu_repository: MenuRepository,
        order_repository: OrderRepository,
    ):
        self.menu_repository = menu_repository
        self.order_repository = order_repository

    def create_order(self, request: CreateOrderRequest) -> Order:

        if not request.items:
            raise EmptyOrderException(
                "Order must contain at least one item"
            )

        total = 0.0

        for order_item in request.items:

            menu_item = self.menu_repository.get_by_id(
                order_item.item_id
            )

            if menu_item is None:
                raise MenuItemNotFoundException(
                    f"Item {order_item.item_id} not found"
                )

            total += menu_item.price * order_item.quantity

        order = Order(
            order_id=str(uuid4())[:8],
            total_amount=round(total, 2),
            status="Confirmed",
        )

        return self.order_repository.save(order)