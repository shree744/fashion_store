package com.fashionstore.dao.impl;

import com.fashionstore.dao.OrderItemDAO;
import com.fashionstore.model.OrderItem;
import com.fashionstore.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDAOImpl implements OrderItemDAO {

    @Override
    public boolean addOrderItem(OrderItem item) {
        String sql = "INSERT INTO order_items (order_id, variant_id, quantity, price) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getVariantId());
            ps.setInt(3, item.getQuantity());
            ps.setDouble(4, item.getPrice());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean addOrderItems(List<OrderItem> items) {
        String sql = "INSERT INTO order_items (order_id, variant_id, quantity, price) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (OrderItem item : items) {
                ps.setInt(1, item.getOrderId());
                ps.setInt(2, item.getVariantId());
                ps.setInt(3, item.getQuantity());
                ps.setDouble(4, item.getPrice());
                ps.addBatch();
            }

            int[] result = ps.executeBatch();

            for (int r : result) {
                if (r == 0) return false;
            }

            return true;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractOrderItem(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public boolean deleteOrderItemsByOrderId(int orderId) {
        String sql = "DELETE FROM order_items WHERE order_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // 🔥 Helper method
    private OrderItem extractOrderItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();

        item.setOrderItemId(rs.getInt("order_item_id"));
        item.setOrderId(rs.getInt("order_id"));
        item.setVariantId(rs.getInt("variant_id"));
        item.setQuantity(rs.getInt("quantity"));
        item.setPrice(rs.getDouble("price"));

        return item;
    }
}