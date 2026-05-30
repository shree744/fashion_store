package com.fashionstore.util;

import java.sql.*;

public class SetupRewardHistory {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            System.out.println("=== Setting Up Reward History Table ===");

            stmt.execute("CREATE TABLE IF NOT EXISTS reward_history (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "order_id INT DEFAULT 0, " +
                    "points INT NOT NULL, " +
                    "reward_type ENUM('ORDER', 'DAILY') DEFAULT 'ORDER', " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE)");
            System.out.println("[OK] Created reward_history table.");

            System.out.println("=== Done ===");

        } catch (Exception e) { e.printStackTrace(); }
    }
}
