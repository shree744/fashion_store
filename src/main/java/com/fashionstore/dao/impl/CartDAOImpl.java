package com.fashionstore.dao.impl;

import com.fashionstore.dao.CartDAO;
import com.fashionstore.model.CartItem;
import com.fashionstore.model.Product;
import com.fashionstore.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CartDAOImpl implements CartDAO {

    // 🔹 GET OR CREATE CART
    private int getOrCreateCart(int userId) throws Exception {

        String select = "SELECT cart_id FROM cart WHERE user_id=?";
        Connection con = DBConnection.getConnection();

        PreparedStatement ps = con.prepareStatement(select);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) return rs.getInt("cart_id");

        String insert = "INSERT INTO cart(user_id) VALUES(?)";

        PreparedStatement ps2 = con.prepareStatement(insert, Statement.RETURN_GENERATED_KEYS);
        ps2.setInt(1, userId);
        ps2.executeUpdate();

        ResultSet rs2 = ps2.getGeneratedKeys();
        if (rs2.next()) return rs2.getInt(1);

        return 0;
    }

    // 🔹 ADD TO CART
    @Override
    public boolean addToCart(int userId, int productId, int qty, String size) {

        try {
            int cartId = getOrCreateCart(userId);

            String check = "SELECT * FROM cart_items WHERE cart_id=? AND variant_id=?";
            String insert = "INSERT INTO cart_items(cart_id, variant_id, quantity) VALUES(?,?,?)";
            String update = "UPDATE cart_items SET quantity=quantity+? WHERE cart_id=? AND variant_id=?";

            Connection con = DBConnection.getConnection();

            PreparedStatement ps1 = con.prepareStatement(check);
            ps1.setInt(1, cartId);
            ps1.setInt(2, productId);

            ResultSet rs = ps1.executeQuery();

            if (rs.next()) {
                PreparedStatement ps2 = con.prepareStatement(update);
                ps2.setInt(1, qty);
                ps2.setInt(2, cartId);
                ps2.setInt(3, productId);
                ps2.executeUpdate();
            } else {
                PreparedStatement ps3 = con.prepareStatement(insert);
                ps3.setInt(1, cartId);
                ps3.setInt(2, productId);
                ps3.setInt(3, qty);
                ps3.executeUpdate();
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 🔹 UPDATE
    @Override
    public boolean updateQuantity(int userId, int productId, int qty) {

        String sql = "UPDATE cart_items SET quantity=? WHERE cart_id=(SELECT cart_id FROM cart WHERE user_id=?) AND variant_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, qty);
            ps.setInt(2, userId);
            ps.setInt(3, productId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // 🔹 REMOVE
    @Override
    public boolean removeFromCart(int userId, int productId) {

        String sql = "DELETE FROM cart_items WHERE cart_id=(SELECT cart_id FROM cart WHERE user_id=?) AND variant_id=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean clearCart(int userId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = (SELECT cart_id FROM cart WHERE user_id = ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 🔹 GET ITEMS
   
    @Override
    public List<CartItem> getCartItemsByUserId(int userId) {

        List<CartItem> list = new ArrayList<>();

        String sql =
            "SELECT ci.quantity, ci.variant_id, pv.size, p.product_id, p.product_name, p.price, p.image_url " +
            "FROM cart_items ci " +
            "JOIN cart c ON ci.cart_id = c.cart_id " +
            "JOIN product_variants pv ON ci.variant_id = pv.variant_id " +
            "JOIN products p ON pv.product_id = p.product_id " +
            "WHERE c.user_id = ?";


        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Product p = new Product();
                p.setProductId(rs.getInt("product_id"));
                p.setProductName(rs.getString("product_name"));
                p.setPrice(rs.getDouble("price"));
                p.setImageUrl(rs.getString("image_url"));

                CartItem item = new CartItem();
                item.setProduct(p);
                item.setQuantity(rs.getInt("quantity"));
                item.setVariantId(rs.getInt("variant_id")); // ✅ ADDED
                item.setSize(rs.getString("size"));

                list.add(item);
            }


        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    
    
}