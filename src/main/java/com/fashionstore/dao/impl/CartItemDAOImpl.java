package com.fashionstore.dao.impl;

import com.fashionstore.dao.CartItemDAO;
import com.fashionstore.model.CartItem;
import com.fashionstore.model.Product;
import com.fashionstore.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartItemDAOImpl implements CartItemDAO {

    @Override
    public boolean addToCart(int userId, int productId, int quantity, String size) {

        String sql = "INSERT INTO cart_items(user_id, product_id, quantity, size) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            ps.setString(4, size);

            int rows = ps.executeUpdate();

            System.out.println("INSERT SUCCESS: " + rows);

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace(); // VERY IMPORTANT
        }

        return false;
    }

    @Override
    public List<CartItem> getCartItems(int userId) {

        List<CartItem> list = new ArrayList<>();

        String sql = "SELECT c.*, p.* FROM cart_items c " +
                     "JOIN products p ON c.product_id = p.product_id " +
                     "WHERE c.user_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setPrice(rs.getDouble("price"));
                p.setImageUrl(rs.getString("image_url"));
                p.setBrand(rs.getString("brand"));

                CartItem item = new CartItem();
                item.setProduct(p);
                item.setQuantity(rs.getInt("quantity"));
                item.setSize(rs.getString("size"));

                list.add(item);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean removeFromCart1(int userId, int productId) {

        String sql = "DELETE ci FROM cart_items ci " +
                     "JOIN cart c ON ci.cart_id = c.cart_id " +
                     "WHERE c.user_id=? AND ci.product_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean updateQuantity(int userId, int productId, int qty) {

        String sql = "UPDATE cart_items ci " +
                     "JOIN cart c ON ci.cart_id = c.cart_id " +
                     "SET ci.quantity=? " +
                     "WHERE c.user_id=? AND ci.product_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, qty);
            ps.setInt(2, userId);
            ps.setInt(3, productId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

	@Override
	public boolean clearCart(int userId) {
		// TODO Auto-generated method stub
		return false;
	}

	public Object getTotal(int userId) {
		// TODO Auto-generated method stub
		return null;
	}

	public void removeFromCart(int userId, int pid) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public boolean removeItem(int userId, int productId) {
		// TODO Auto-generated method stub
		return false;
	}
}