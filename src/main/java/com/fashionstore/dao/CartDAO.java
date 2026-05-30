package com.fashionstore.dao;

import com.fashionstore.model.CartItem;
import java.util.List;

public interface CartDAO {

    boolean addToCart(int userId, int productId, int qty, String size);

    boolean updateQuantity(int userId, int productId, int qty);

    boolean removeFromCart(int userId, int productId);

    boolean clearCart(int userId); // ✅ ADDED

    List<CartItem> getCartItemsByUserId(int userId);
}