package com.fashionstore.util;

import java.sql.*;

public class FixUserRole {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            System.out.println("Checking users...");
            ResultSet rs = stmt.executeQuery("SELECT user_id, email, role FROM users");
            while (rs.next()) {
                System.out.println("User ID: " + rs.getInt("user_id") + " | Email: " + rs.getString("email") + " | Role: " + rs.getString("role"));
            }
            
            // Ensure all users have at least 'CUSTOMER' role
            int updated = stmt.executeUpdate("UPDATE users SET role = 'CUSTOMER' WHERE role IS NULL");
            System.out.println("Updated " + updated + " users with NULL role.");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
