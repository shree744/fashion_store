package com.fashionstore.dao.impl;

import com.fashionstore.dao.ReviewDAO;
import com.fashionstore.model.Review;
import com.fashionstore.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAOImpl implements ReviewDAO {

    @Override
    public boolean addReview(Review review) {
        String sql = "INSERT INTO reviews (product_id, user_id, rating, comment) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, review.getProductId());
            ps.setInt(2, review.getUserId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());
            int result = ps.executeUpdate();
            
            if (result > 0) {
                updateProductAverageRating(review.getProductId());
                return true;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public List<Review> getReviewsByProductId(int productId) {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT r.*, u.full_name FROM reviews r JOIN users u ON r.user_id = u.user_id WHERE r.product_id = ? ORDER BY r.review_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Review r = new Review();
                r.setReviewId(rs.getInt("review_id"));
                r.setProductId(rs.getInt("product_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setRating(rs.getInt("rating"));
                r.setComment(rs.getString("comment"));
                r.setReviewDate(rs.getTimestamp("review_date"));
                r.setUserName(rs.getString("full_name"));
                list.add(r);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public double getAverageRating(int productId) {
        String sql = "SELECT AVG(rating) FROM reviews WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0.0;
    }

    @Override
    public int getReviewCount(int productId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public boolean hasUserReviewed(int userId, int productId) {
        String sql = "SELECT 1 FROM reviews WHERE user_id = ? AND product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeQuery().next();
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    private void updateProductAverageRating(int productId) {
        double avg = getAverageRating(productId);
        String sql = "UPDATE products SET average_rating = ? WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, avg);
            ps.setInt(2, productId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
