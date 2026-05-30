package com.fashionstore.dao.impl;

import com.fashionstore.dao.CouponDAO;
import com.fashionstore.model.Coupon;
import com.fashionstore.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CouponDAOImpl implements CouponDAO {

    @Override
    public boolean addCoupon(Coupon coupon) {
        String sql = "INSERT INTO coupons (code, discount_type, discount_value, expiry_date, usage_limit) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, coupon.getCode());
            ps.setString(2, coupon.getDiscountType());
            ps.setDouble(3, coupon.getDiscountValue());
            ps.setDate(4, coupon.getExpiryDate());
            ps.setInt(5, coupon.getUsageLimit());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public Coupon getCouponByCode(String code) {
        String sql = "SELECT * FROM coupons WHERE code = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractCoupon(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public List<Coupon> getAllCoupons() {
        List<Coupon> list = new ArrayList<>();
        String sql = "SELECT * FROM coupons ORDER BY expiry_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractCoupon(rs));
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public boolean updateCouponUsage(int couponId) {
        String sql = "UPDATE coupons SET used_count = COALESCE(used_count, 0) + 1 WHERE coupon_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, couponId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean deleteCoupon(int couponId) {
        String sql = "DELETE FROM coupons WHERE coupon_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, couponId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean updateCoupon(Coupon coupon) {
        String sql = "UPDATE coupons SET code = ?, discount_type = ?, discount_value = ?, expiry_date = ?, usage_limit = ? WHERE coupon_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, coupon.getCode());
            ps.setString(2, coupon.getDiscountType());
            ps.setDouble(3, coupon.getDiscountValue());
            ps.setDate(4, coupon.getExpiryDate());
            ps.setInt(5, coupon.getUsageLimit());
            ps.setInt(6, coupon.getCouponId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Coupon extractCoupon(ResultSet rs) throws SQLException {
        Coupon c = new Coupon();
        c.setCouponId(rs.getInt("coupon_id"));
        c.setCode(rs.getString("code"));
        c.setDiscountType(rs.getString("discount_type"));
        c.setDiscountValue(rs.getDouble("discount_value"));
        c.setExpiryDate(rs.getDate("expiry_date"));
        c.setUsageLimit(rs.getInt("usage_limit"));
        c.setUsedCount(rs.getInt("used_count"));
        return c;
    }
}
