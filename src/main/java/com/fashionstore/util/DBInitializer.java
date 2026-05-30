package com.fashionstore.util;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

/**
 * Runs on application startup.
 * Ensures required tables exist and schema is up to date.
 */
@WebListener
public class DBInitializer implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("DBInitializer: Checking/creating required tables...");

        // Create reward_history if it doesn't already exist
        String createRewardHistory =
            "CREATE TABLE IF NOT EXISTS reward_history (" +
            "  id INT AUTO_INCREMENT PRIMARY KEY," +
            "  user_id INT NOT NULL," +
            "  order_id INT NOT NULL DEFAULT 0," +
            "  points INT NOT NULL DEFAULT 0," +
            "  reward_type VARCHAR(50) NOT NULL DEFAULT 'ORDER'," +
            "  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP," +
            "  INDEX idx_user_id (user_id)," +
            "  INDEX idx_order_id (order_id)" +
            ")";

        // Ensure refunds table has status and request_date columns with defaults
        String alterRefunds1 =
            "ALTER TABLE refunds " +
            "MODIFY COLUMN status VARCHAR(50) NOT NULL DEFAULT 'Requested'";

        try (Connection conn = DBConnection.getConnection()) {

            String createFaqTable =
                "CREATE TABLE IF NOT EXISTS faq (" +
                "  question_id INT AUTO_INCREMENT PRIMARY KEY," +
                "  user_id INT NOT NULL," +
                "  question_text TEXT NOT NULL," +
                "  answer_text TEXT DEFAULT NULL," +
                "  status VARCHAR(50) NOT NULL DEFAULT 'Pending'," +
                "  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP," +
                "  INDEX idx_faq_user_id (user_id)," +
                "  INDEX idx_faq_status (status)" +
                ")";

            String createSitePolicy =
                "CREATE TABLE IF NOT EXISTS site_policy (" +
                "  policy_key VARCHAR(100) PRIMARY KEY," +
                "  policy_value TEXT NOT NULL," +
                "  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP" +
                ")";

            try (PreparedStatement ps = conn.prepareStatement(createRewardHistory)) {
                ps.executeUpdate();
                System.out.println("DBInitializer: reward_history table OK.");
            } catch (SQLException e) {
                System.err.println("DBInitializer: Could not create reward_history: " + e.getMessage());
            }

            try (PreparedStatement ps = conn.prepareStatement(createFaqTable)) {
                ps.executeUpdate();
                System.out.println("DBInitializer: faq table OK.");
            } catch (SQLException e) {
                System.err.println("DBInitializer: Could not create faq table: " + e.getMessage());
            }

            try (PreparedStatement ps = conn.prepareStatement(createSitePolicy)) {
                ps.executeUpdate();
                System.out.println("DBInitializer: site_policy table OK.");
            } catch (SQLException e) {
                System.err.println("DBInitializer: Could not create site_policy table: " + e.getMessage());
            }

            try (PreparedStatement ps = conn.prepareStatement(alterRefunds1)) {
                ps.executeUpdate();
                System.out.println("DBInitializer: refunds.status column OK.");
            } catch (SQLException e) {
                // Column may already have correct type - not fatal
                System.out.println("DBInitializer: refunds alter skipped (may already be OK): " + e.getMessage());
            }

        } catch (SQLException e) {
            System.err.println("DBInitializer: DB connection failed: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("DBInitializer: Schema check complete.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // nothing to clean up
    }
}
