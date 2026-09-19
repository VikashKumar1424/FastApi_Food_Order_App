from pydantic import BaseModel, Field


class OrderItemRequest(BaseModel):
    item_id: str
    quantity: int = Field(gt=0)


class CreateOrderRequest(BaseModel):
    items: list[OrderItemRequest]


class OrderResponse(BaseModel):
    order_id: str
    total_amount: float
    status: str