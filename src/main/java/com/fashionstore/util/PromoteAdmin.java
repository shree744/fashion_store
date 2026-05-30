package com.fashionstore.util;

import java.sql.*;

public class PromoteAdmin {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            
            int updated = stmt.executeUpdate("UPDATE users SET role = 'ADMIN' WHERE user_id = 27");
            System.out.println("Promoted user #27 to ADMIN. Rows affected: " + updated);
            
            ResultSet rs = stmt.executeQuery("SELECT user_id, email, role FROM users WHERE user_id = 27");
            if (rs.next()) {
                System.out.println("Verified: " + rs.getString("email") + " -> " + rs.getString("role"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
