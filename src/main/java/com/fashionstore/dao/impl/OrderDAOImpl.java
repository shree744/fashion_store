package com.fashionstore.dao.impl;

import com.fashionstore.dao.OrderDAO;
import com.fashionstore.model.Order;
import com.fashionstore.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAOImpl implements OrderDAO {

    @Override
    public int placeOrder(Order order) {
        String sql = "INSERT INTO orders (user_id, total_amount, payment_method, order_status, " +
                "delivery_name, delivery_phone, delivery_address_line1, delivery_address_line2, " +
                "delivery_city, delivery_state, delivery_pincode, delivery_country, tracking_status, estimated_delivery_date) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, order.getUserId());
            ps.setDouble(2, order.getTotalAmount());
            ps.setString(3, order.getPaymentMethod());
            ps.setString(4, order.getOrderStatus());

            ps.setString(5, order.getDeliveryName());
            ps.setString(6, order.getDeliveryPhone());
            ps.setString(7, order.getDeliveryAddressLine1());
            ps.setString(8, order.getDeliveryAddressLine2());
            ps.setString(9, order.getDeliveryCity());
            ps.setString(10, order.getDeliveryState());
            ps.setString(11, order.getDeliveryPincode());
            ps.setString(12, order.getDeliveryCountry());
            ps.setString(13, order.getTrackingStatus());
            ps.setString(14, order.getEstimatedDeliveryDate());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, r.status as refund_status FROM orders o " +
                     "LEFT JOIN refunds r ON o.order_id = r.order_id WHERE o.order_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractOrder(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<Order> getOrdersByUserId(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, r.status as refund_status FROM orders o " +
                     "LEFT JOIN refunds r ON o.order_id = r.order_id " +
                     "WHERE o.user_id=? ORDER BY o.order_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractOrder(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, r.status as refund_status FROM orders o " +
                     "LEFT JOIN refunds r ON o.order_id = r.order_id " +
                     "ORDER BY o.order_date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractOrder(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public boolean updateOrderStatus(int orderId, String status) {
        String sql = "UPDATE orders SET order_status=?, tracking_status=? WHERE order_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, status); // Update tracking status along with order status
            ps.setInt(3, orderId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteOrder(int orderId) {
        String sql = "DELETE FROM orders WHERE order_id=?";

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
    private Order extractOrder(ResultSet rs) throws SQLException {
        Order order = new Order();

        order.setOrderId(rs.getInt("order_id"));
        order.setUserId(rs.getInt("user_id"));
        order.setOrderDate(rs.getTimestamp("order_date"));
        order.setTotalAmount(rs.getDouble("total_amount"));
        order.setPaymentMethod(rs.getString("payment_method"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setTrackingStatus(rs.getString("tracking_status"));
        order.setEstimatedDeliveryDate(rs.getString("estimated_delivery_date"));

        order.setDeliveryName(rs.getString("delivery_name"));
        order.setDeliveryPhone(rs.getString("delivery_phone"));
        order.setDeliveryAddressLine1(rs.getString("delivery_address_line1"));
        order.setDeliveryAddressLine2(rs.getString("delivery_address_line2"));
        order.setDeliveryCity(rs.getString("delivery_city"));
        order.setDeliveryState(rs.getString("delivery_state"));
        order.setDeliveryPincode(rs.getString("delivery_pincode"));
        order.setDeliveryCountry(rs.getString("delivery_country"));

        // Fetch refund status if present
        order.setRefundStatus(rs.getString("refund_status"));

        return order;
    }
}