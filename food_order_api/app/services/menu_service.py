from app.repositories.menu_repository import MenuRepository


class MenuService:

    def __init__(self, repository: MenuRepository):
        self.repository = repository

    def get_menu(self):
        return self.repository.get_all()