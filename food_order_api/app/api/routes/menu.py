from fastapi import APIRouter, Depends

from app.repositories.menu_repository import MenuRepository
from app.schemas.menu import MenuItemResponse
from app.services.menu_service import MenuService


router = APIRouter(prefix="/menu", tags=["Menu"])


menu_repository = MenuRepository()


def get_menu_service() -> MenuService:
    return MenuService(menu_repository)


@router.get("", response_model=list[MenuItemResponse])
def get_menu(
    service: MenuService = Depends(get_menu_service),
):
    return service.get_menu()