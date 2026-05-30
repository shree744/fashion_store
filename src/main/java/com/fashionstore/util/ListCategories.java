package com.fashionstore.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class ListCategories {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM categories")) {
            System.out.println("Categories:");
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("category_id") + ", Name: " + rs.getString("category_name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
