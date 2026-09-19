from fastapi import APIRouter, Depends, status

from app.repositories.menu_repository import MenuRepository
from app.repositories.order_repository import OrderRepository
from app.schemas.order import CreateOrderRequest, OrderResponse
from app.services.order_service import OrderService


router = APIRouter(prefix="/orders", tags=["Orders"])


menu_repository = MenuRepository()
order_repository = OrderRepository()


def get_order_service() -> OrderService:
    return OrderService(
        menu_repository=menu_repository,
        order_repository=order_repository,
    )


@router.post(
    "",
    response_model=OrderResponse,
    status_code=status.HTTP_201_CREATED,
)
def create_order(
    request: CreateOrderRequest,
    service: OrderService = Depends(get_order_service),
):
    return service.create_order(request)