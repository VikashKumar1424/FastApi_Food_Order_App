from dataclasses import dataclass


@dataclass
class MenuItem:
    id: str
    name: str
    description: str
    price: float
    image_url: str


@dataclass
class OrderItem:
    item_id: str
    quantity: int


@dataclass
class Order:
    order_id: str
    total_amount: float
    status: str