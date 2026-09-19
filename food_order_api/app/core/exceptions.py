class OrderException(Exception):
    """Base exception for order-related errors."""


class EmptyOrderException(OrderException):
    """Raised when an order has no items."""


class MenuItemNotFoundException(OrderException):
    """Raised when a menu item does not exist."""