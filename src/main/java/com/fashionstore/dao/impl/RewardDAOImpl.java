package com.fashionstore.dao.impl;

import com.fashionstore.dao.RewardDAO;
import com.fashionstore.model.Reward;
import com.fashionstore.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RewardDAOImpl implements RewardDAO {

    @Override
    public Reward getRewardByUserId(int userId) {
        String sql = "SELECT * FROM rewards WHERE user_id = ? ORDER BY reward_id DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Reward r = new Reward();
                r.setRewardId(rs.getInt("reward_id"));
                r.setUserId(rs.getInt("user_id"));
                r.setPoints(rs.getInt("points"));
                r.setClaimDate(rs.getDate("claim_date"));
                r.setStreakCount(rs.getInt("streak_count"));
                System.out.println("DEBUG: Reward found for user " + userId + ": " + r.getPoints() + " points");
                return r;
            } else {
                System.out.println("DEBUG: No reward entry found for user " + userId);
            }
        } catch (SQLException e) { 
            System.err.println("ERROR: Failed to get reward for user " + userId);
            e.printStackTrace(); 
        }
        return null;
    }

    @Override
    public boolean claimDailyReward(int userId) {
        Reward r = getRewardByUserId(userId);
        LocalDate today = LocalDate.now();

        if (r == null) {
            // First time claiming — create rewards row
            String sql = "INSERT INTO rewards (user_id, points, claim_date, streak_count) VALUES (?, 10, ?, 1)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setDate(2, Date.valueOf(today));
                if (ps.executeUpdate() > 0) {
                    insertRewardHistory(userId, 0, 10, "DAILY");
                    System.out.println("DEBUG: First daily claim for user " + userId + ", +10 pts");
                    return true;
                }
            } catch (SQLException e) {
                System.err.println("ERROR: claimDailyReward (new user) failed for " + userId);
                e.printStackTrace();
            }
        } else {
            LocalDate lastClaim = r.getClaimDate().toLocalDate();
            if (lastClaim.equals(today)) {
                System.out.println("DEBUG: Daily reward already claimed today for user " + userId);
                return false;
            }

            int newStreak = lastClaim.equals(today.minusDays(1)) ? r.getStreakCount() + 1 : 1;
            int pointsToAdd = 10 + (newStreak > 5 ? 20 : 0);

            String sql = "UPDATE rewards SET points = points + ?, claim_date = ?, streak_count = ? WHERE reward_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, pointsToAdd);
                ps.setDate(2, Date.valueOf(today));
                ps.setInt(3, newStreak);
                ps.setInt(4, r.getRewardId());
                if (ps.executeUpdate() > 0) {
                    insertRewardHistory(userId, 0, pointsToAdd, "DAILY");
                    System.out.println("DEBUG: Daily claim for user " + userId + ", +" + pointsToAdd + " pts, streak=" + newStreak);
                    return true;
                }
            } catch (SQLException e) {
                System.err.println("ERROR: claimDailyReward (update) failed for " + userId);
                e.printStackTrace();
            }
        }
        return false;
    }

    @Override
    public int getPoints(int userId) {
        // Sum all reward points for this user
        String sql = "SELECT COALESCE(SUM(points), 0) FROM rewards WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public boolean addOrderReward(int userId, int orderId, double orderAmount) {
        // Prevent duplicate rewards for same order
        if (isOrderRewarded(orderId)) return false;

        // Calculate reward points: ₹100 = 1 point, minimum 5 points per order
        int points = Math.max(5, (int) (orderAmount / 100));

        // Bonus for high-value orders
        if (orderAmount >= 5000) points += 25;
        else if (orderAmount >= 2000) points += 10;
        else if (orderAmount >= 1000) points += 5;

        String sql = "INSERT INTO reward_history (user_id, order_id, points, reward_type, created_at) VALUES (?, ?, ?, 'ORDER', NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, orderId);
            ps.setInt(3, points);
            int result = ps.executeUpdate();
            System.out.println("DEBUG: reward_history insert result: " + result);

            if (result > 0) {
                // Also update total points in rewards table
                updateTotalPoints(userId, points);
                System.out.println("DEBUG: Order reward added successfully for order " + orderId);
                return true;
            }
        } catch (SQLException e) { 
            System.err.println("ERROR: Failed to add order reward for user " + userId + ", order " + orderId);
            e.printStackTrace(); 
        }
        return false;
    }

    @Override
    public boolean removeOrderReward(int userId, int orderId) {
        String sqlSelect = "SELECT points FROM reward_history WHERE order_id = ? AND user_id = ? AND reward_type = 'ORDER'";
        String sqlDelete = "DELETE FROM reward_history WHERE order_id = ? AND user_id = ? AND reward_type = 'ORDER'";
        
        try (Connection conn = DBConnection.getConnection()) {
            int pointsToDeduct = 0;
            try (PreparedStatement ps = conn.prepareStatement(sqlSelect)) {
                ps.setInt(1, orderId);
                ps.setInt(2, userId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    pointsToDeduct = rs.getInt("points");
                }
            }
            
            if (pointsToDeduct > 0) {
                try (PreparedStatement ps = conn.prepareStatement(sqlDelete)) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, userId);
                    if (ps.executeUpdate() > 0) {
                        updateTotalPoints(userId, -pointsToDeduct);
                        System.out.println("DEBUG: Removed " + pointsToDeduct + " reward points for refunded order " + orderId);
                        return true;
                    }
                }
            }
        } catch (SQLException e) { 
            System.err.println("ERROR: Failed to remove reward for order " + orderId);
            e.printStackTrace(); 
        }
        return false;
    }

    @Override
    public boolean isOrderRewarded(int orderId) {
        String sql = "SELECT 1 FROM reward_history WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public int syncMissingOrderRewards(int userId) {
        // Find all delivered orders for this user that have no reward_history entry
        String findSql = "SELECT o.order_id, o.total_amount FROM orders o " +
                         "WHERE o.user_id = ? AND o.order_status = 'Delivered' " +
                         "AND o.order_id NOT IN (SELECT order_id FROM reward_history WHERE user_id = ? AND reward_type = 'ORDER')";
        int synced = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(findSql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int orderId = rs.getInt("order_id");
                double amount = rs.getDouble("total_amount");
                System.out.println("DEBUG: Syncing missing reward for order " + orderId);
                if (addOrderReward(userId, orderId, amount)) {
                    synced++;
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR: Failed to sync missing order rewards for user " + userId);
            e.printStackTrace();
        }
        if (synced > 0) {
            System.out.println("DEBUG: Synced " + synced + " missing reward(s) for user " + userId);
        }
        return synced;
    }

    @Override
    public List<Map<String, Object>> getRewardHistory(int userId) {
        List<Map<String, Object>> history = new ArrayList<>();
        String sql = "SELECT * FROM reward_history WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Map<String, Object> entry = new HashMap<>();
                entry.put("id", rs.getInt("id"));
                entry.put("orderId", rs.getInt("order_id"));
                entry.put("points", rs.getInt("points"));
                entry.put("rewardType", rs.getString("reward_type"));
                entry.put("createdAt", rs.getTimestamp("created_at"));
                history.add(entry);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return history;
    }

    private void updateTotalPoints(int userId, int pointsToAdd) {
        // Check if user has a reward entry
        Reward r = getRewardByUserId(userId);
        if (r != null) {
            String sql = "UPDATE rewards SET points = points + ? WHERE reward_id = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, pointsToAdd);
                ps.setInt(2, r.getRewardId());
                int updated = ps.executeUpdate();
                System.out.println("DEBUG: Updated existing reward points. Rows affected: " + updated);
            } catch (SQLException e) { 
                System.err.println("ERROR: Failed to update total points for user " + userId);
                e.printStackTrace(); 
            }
        } else {
            String sql = "INSERT INTO rewards (user_id, points, claim_date, streak_count) VALUES (?, ?, ?, 0)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, userId);
                ps.setInt(2, pointsToAdd);
                ps.setDate(3, Date.valueOf(LocalDate.now()));
                int inserted = ps.executeUpdate();
                System.out.println("DEBUG: Inserted new reward entry. Rows affected: " + inserted);
            } catch (SQLException e) { 
                System.err.println("ERROR: Failed to insert new reward entry for user " + userId);
                e.printStackTrace(); 
            }
        }
    }

    /**
     * Central helper: insert one row into reward_history.
     * orderId should be 0 for non-order events (e.g. DAILY).
     * Duplicate prevention: for ORDER type, skip if an entry for that order already exists.
     */
    private void insertRewardHistory(int userId, int orderId, int points, String rewardType) {
        // For ORDER rewards, check for duplicates
        if ("ORDER".equalsIgnoreCase(rewardType) && orderId > 0) {
            String check = "SELECT 1 FROM reward_history WHERE order_id = ? AND user_id = ? AND reward_type = 'ORDER'";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(check)) {
                ps.setInt(1, orderId);
                ps.setInt(2, userId);
                if (ps.executeQuery().next()) {
                    System.out.println("DEBUG: Skipping duplicate ORDER history for order " + orderId);
                    return;
                }
            } catch (SQLException e) {
                System.err.println("ERROR: Duplicate check failed: " + e.getMessage());
            }
        }

        String sql = "INSERT INTO reward_history (user_id, order_id, points, reward_type, created_at) VALUES (?, ?, ?, ?, NOW())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, orderId);
            ps.setInt(3, points);
            ps.setString(4, rewardType);
            int rows = ps.executeUpdate();
            System.out.println("DEBUG: insertRewardHistory(" + rewardType + ") → " + rows + " row(s) inserted for user " + userId);
        } catch (SQLException e) {
            System.err.println("ERROR: insertRewardHistory failed for user " + userId + ": " + e.getMessage());
            e.printStackTrace();
        }
    }
}
