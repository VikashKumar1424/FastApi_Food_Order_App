from pydantic import BaseModel


class MenuItemResponse(BaseModel):
    id: str
    name: str
    description: str
    price: float
    image_url: str