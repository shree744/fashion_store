package com.fashionstore.util;

import java.sql.Connection;
import java.sql.Statement;

public class SetupDatabase {

    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            System.out.println("Updating database schema...");

            // Update existing tables
            try {
                stmt.execute("ALTER TABLE products ADD COLUMN average_rating DECIMAL(3,2) DEFAULT 0.00");
                System.out.println("Added average_rating to products.");
            } catch (Exception e) { System.out.println("average_rating already exists or error: " + e.getMessage()); }

            try {
                stmt.execute("ALTER TABLE product_variants ADD COLUMN color VARCHAR(50)");
                stmt.execute("ALTER TABLE product_variants ADD COLUMN image_url VARCHAR(255)");
                System.out.println("Added color and image_url to product_variants.");
            } catch (Exception e) { System.out.println("columns already exist or error: " + e.getMessage()); }

            try {
                stmt.execute("ALTER TABLE orders ADD COLUMN estimated_delivery_date DATE");
                stmt.execute("ALTER TABLE orders ADD COLUMN tracking_status VARCHAR(50) DEFAULT 'Ordered'");
                System.out.println("Added tracking columns to orders.");
            } catch (Exception e) { System.out.println("tracking columns already exist or error: " + e.getMessage()); }
            try {
                stmt.execute("ALTER TABLE users ADD COLUMN role VARCHAR(20) DEFAULT 'CUSTOMER'");
                System.out.println("Added role to users.");
            } catch (Exception e) { System.out.println("role already exists or error: " + e.getMessage()); }

            // New tables
            stmt.execute("CREATE TABLE IF NOT EXISTS product_images (" +
                    "image_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "product_id INT NOT NULL, " +
                    "image_url VARCHAR(255) NOT NULL, " +
                    "FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE)");
            System.out.println("Created product_images table.");

            stmt.execute("CREATE TABLE IF NOT EXISTS reviews (" +
                    "review_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "product_id INT NOT NULL, " +
                    "user_id INT NOT NULL, " +
                    "rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5), " +
                    "comment TEXT, " +
                    "review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "UNIQUE KEY (product_id, user_id), " +
                    "FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE, " +
                    "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE)");
            System.out.println("Created reviews table.");

            stmt.execute("CREATE TABLE IF NOT EXISTS rewards (" +
                    "reward_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "user_id INT NOT NULL, " +
                    "points INT DEFAULT 0, " +
                    "claim_date DATE NOT NULL, " +
                    "streak_count INT DEFAULT 0, " +
                    "FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE)");
            System.out.println("Created rewards table.");

            stmt.execute("CREATE TABLE IF NOT EXISTS coupons (" +
                    "coupon_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "code VARCHAR(50) UNIQUE NOT NULL, " +
                    "discount_type ENUM('PERCENTAGE', 'FLAT') NOT NULL, " +
                    "discount_value DECIMAL(10,2) NOT NULL, " +
                    "expiry_date DATE NOT NULL, " +
                    "usage_limit INT DEFAULT 1, " +
                    "used_count INT DEFAULT 0)");
            System.out.println("Created coupons table.");

            stmt.execute("CREATE TABLE IF NOT EXISTS refunds (" +
                    "refund_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "order_id INT NOT NULL, " +
                    "status ENUM('Requested', 'Approved', 'Processing', 'Refunded') DEFAULT 'Requested', " +
                    "reason TEXT, " +
                    "request_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "processed_date TIMESTAMP, " +
                    "FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE)");
            System.out.println("Created refunds table.");

            System.out.println("Database schema update completed successfully.");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
