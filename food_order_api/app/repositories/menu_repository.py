from app.models.food import MenuItem


class MenuRepository:

    def __init__(self):
        self._menu: list[MenuItem] = [
            MenuItem(
                id="1",
                name="Margherita Pizza",
                description="Classic tomato, mozzarella, and basil",
                price=12.99,
                image_url=(
                    "https://images.unsplash.com/"
                    "photo-1574071318508-1cdbab80d002?w=500"
                ),
            ),
            MenuItem(
                id="2",
                name="Veggie Burger",
                description=(
                    "Plant-based patty with fresh lettuce, "
                    "tomato, and avocado"
                ),
                price=10.49,
                image_url=(
                    "https://images.unsplash.com/"
                    "photo-1520072959219-c595dc870360?w=500"
                ),
            ),
            MenuItem(
                id="3",
                name="Pasta Primavera",
                description=(
                    "Penne with seasonal vegetables "
                    "in garlic olive oil"
                ),
                price=14.00,
                image_url=(
                    "https://images.unsplash.com/"
                    "photo-1621996346565-e3d5d6281313?w=500"
                ),
            ),
        ]

    def get_all(self) -> list[MenuItem]:
        return self._menu

    def get_by_id(self, item_id: str) -> MenuItem | None:
        for item in self._menu:
            if item.id == item_id:
                return item

        return None