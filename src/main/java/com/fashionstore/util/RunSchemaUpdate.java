package com.fashionstore.util;

import java.sql.*;

public class RunSchemaUpdate {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("=== Running Schema Updates ===");
            
            // 1. Add role to users
            try {
                stmt.execute("ALTER TABLE users ADD COLUMN role VARCHAR(20) DEFAULT 'CUSTOMER'");
                System.out.println("[OK] Added role to users.");
            } catch (Exception e) { System.out.println("[SKIP] role: " + e.getMessage()); }
            
            // 2. Add image_url to product_variants
            try {
                stmt.execute("ALTER TABLE product_variants ADD COLUMN image_url VARCHAR(255)");
                System.out.println("[OK] Added image_url to product_variants.");
            } catch (Exception e) { System.out.println("[SKIP] image_url: " + e.getMessage()); }

            // 3. Add color to product_variants  
            try {
                stmt.execute("ALTER TABLE product_variants ADD COLUMN color VARCHAR(50)");
                System.out.println("[OK] Added color to product_variants.");
            } catch (Exception e) { System.out.println("[SKIP] color: " + e.getMessage()); }
            
            // 4. Add average_rating to products
            try {
                stmt.execute("ALTER TABLE products ADD COLUMN average_rating DECIMAL(3,2) DEFAULT 0.00");
                System.out.println("[OK] Added average_rating to products.");
            } catch (Exception e) { System.out.println("[SKIP] average_rating: " + e.getMessage()); }

            // 5. Add tracking columns to orders
            try {
                stmt.execute("ALTER TABLE orders ADD COLUMN estimated_delivery_date DATE");
                System.out.println("[OK] Added estimated_delivery_date to orders.");
            } catch (Exception e) { System.out.println("[SKIP] estimated_delivery_date: " + e.getMessage()); }
            try {
                stmt.execute("ALTER TABLE orders ADD COLUMN tracking_status VARCHAR(50) DEFAULT 'Ordered'");
                System.out.println("[OK] Added tracking_status to orders.");
            } catch (Exception e) { System.out.println("[SKIP] tracking_status: " + e.getMessage()); }

            // 6. Create reviews table
            stmt.execute("CREATE TABLE IF NOT EXISTS reviews (" +
                    "review_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "product_id INT NOT NULL, " +
                    "user_id INT NOT NULL, " +
                    "rating INT NOT NULL, " +
                    "comment TEXT, " +
                    "review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "UNIQUE KEY (product_id, user_id), " +
                    "FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE)");
            System.out.println("[OK] Created/verified reviews table.");

            // 7. Create rewards table
            stmt.execute("CREATE TABLE IF NOT EXISTS rewards (" +
                    "reward_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "points INT DEFAULT 0, " +
                    "claim_date DATE NOT NULL, " +
                    "streak_count INT DEFAULT 0, " +
                    "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE)");
            System.out.println("[OK] Created/verified rewards table.");

            // 8. Create coupons table
            stmt.execute("CREATE TABLE IF NOT EXISTS coupons (" +
                    "coupon_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "code VARCHAR(50) UNIQUE NOT NULL, " +
                    "discount_type ENUM('PERCENTAGE', 'FLAT') NOT NULL, " +
                    "discount_value DECIMAL(10,2) NOT NULL, " +
                    "expiry_date DATE NOT NULL, " +
                    "usage_limit INT DEFAULT 1, " +
                    "used_count INT DEFAULT 0)");
            System.out.println("[OK] Created/verified coupons table.");

            // 9. Create refunds table
            stmt.execute("CREATE TABLE IF NOT EXISTS refunds (" +
                    "refund_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "order_id INT NOT NULL, " +
                    "status ENUM('Requested', 'Approved', 'Processing', 'Refunded') DEFAULT 'Requested', " +
                    "reason TEXT, " +
                    "request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "processed_date TIMESTAMP, " +
                    "FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE)");
            System.out.println("[OK] Created/verified refunds table.");

            // 10. Create product_images table
            stmt.execute("CREATE TABLE IF NOT EXISTS product_images (" +
                    "image_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "product_id INT NOT NULL, " +
                    "image_url VARCHAR(255) NOT NULL, " +
                    "FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE)");
            System.out.println("[OK] Created/verified product_images table.");

            // 11. Ensure all users have role set
            int updated = stmt.executeUpdate("UPDATE users SET role = 'CUSTOMER' WHERE role IS NULL");
            System.out.println("[OK] Fixed " + updated + " users with NULL role.");

            // 12. List current users
            System.out.println("\n=== Current Users ===");
            ResultSet rs = stmt.executeQuery("SELECT user_id, email, role FROM users");
            while (rs.next()) {
                System.out.println("  User #" + rs.getInt("user_id") + " | " + rs.getString("email") + " | Role: " + rs.getString("role"));
            }

            System.out.println("\n=== Schema Update Complete ===");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
