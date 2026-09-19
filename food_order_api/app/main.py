from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse

from app.api.routes.menu import router as menu_router
from app.api.routes.orders import router as order_router
from app.core.exceptions import (
    EmptyOrderException,
    MenuItemNotFoundException,
)


app = FastAPI(
    title="Food Order API",
    version="1.0.0",
)


@app.exception_handler(EmptyOrderException)
async def empty_order_exception_handler(
    request: Request,
    exc: EmptyOrderException,
):
    return JSONResponse(
        status_code=400,
        content={
            "error": "EMPTY_ORDER",
            "message": str(exc),
        },
    )


@app.exception_handler(MenuItemNotFoundException)
async def menu_item_not_found_exception_handler(
    request: Request,
    exc: MenuItemNotFoundException,
):
    return JSONResponse(
        status_code=404,
        content={
            "error": "MENU_ITEM_NOT_FOUND",
            "message": str(exc),
        },
    )


app.include_router(menu_router)
app.include_router(order_router)


@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "service": "food-order-api",
    }