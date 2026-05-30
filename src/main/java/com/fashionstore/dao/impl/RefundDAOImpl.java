package com.fashionstore.dao.impl;

import com.fashionstore.dao.RefundDAO;
import com.fashionstore.model.Refund;
import com.fashionstore.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RefundDAOImpl implements RefundDAO {

    @Override
    public boolean requestRefund(Refund refund) {
        String sql = "INSERT INTO refunds (order_id, reason, status, request_date) VALUES (?, ?, 'Requested', NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, refund.getOrderId());
            ps.setString(2, refund.getReason());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { 
            System.err.println("ERROR: Failed to request refund for order " + refund.getOrderId());
            e.printStackTrace(); 
        }
        return false;
    }

    @Override
    public boolean updateRefundStatus(int refundId, String status) {
        String sql = "UPDATE refunds SET status = ?, processed_date = ? WHERE refund_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setInt(3, refundId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public List<Refund> getAllRefunds() {
        List<Refund> list = new ArrayList<>();
        String sql = "SELECT * FROM refunds ORDER BY request_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractRefund(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<Refund> getRefundsByOrderId(int orderId) {
        List<Refund> list = new ArrayList<>();
        String sql = "SELECT * FROM refunds WHERE order_id = ? ORDER BY request_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractRefund(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<Refund> getRefundsByUserId(int userId) {
        List<Refund> list = new ArrayList<>();
        String sql = "SELECT r.* FROM refunds r JOIN orders o ON r.order_id = o.order_id WHERE o.user_id = ? ORDER BY r.request_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractRefund(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public Refund getRefundById(int refundId) {
        String sql = "SELECT * FROM refunds WHERE refund_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, refundId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractRefund(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    private Refund extractRefund(ResultSet rs) throws SQLException {
        Refund r = new Refund();
        r.setRefundId(rs.getInt("refund_id"));
        r.setOrderId(rs.getInt("order_id"));
        r.setStatus(rs.getString("status"));
        r.setReason(rs.getString("reason"));
        r.setRequestDate(rs.getTimestamp("request_date"));
        r.setProcessedDate(rs.getTimestamp("processed_date"));
        return r;
    }
}
