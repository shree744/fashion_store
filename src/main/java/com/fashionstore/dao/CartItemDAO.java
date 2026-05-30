package com.fashionstore.dao;

import com.fashionstore.model.CartItem;
import java.util.List;

public interface CartItemDAO {

    boolean addToCart(int userId, int productId, int quantity, String size);

    boolean updateQuantity(int userId, int productId, int quantity);

    boolean removeItem(int userId, int productId);

    List<CartItem> getCartItems(int userId);

    boolean clearCart(int userId);
}