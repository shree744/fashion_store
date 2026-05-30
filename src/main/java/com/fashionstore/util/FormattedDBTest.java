package com.fashionstore.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public class FormattedDBTest {

    public static void main(String[] args) {

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            // ================= CATEGORY TEST =================
            System.out.println("========== CATEGORY TEST ==========");

            String categoryQuery = "SELECT * FROM categories ORDER BY category_id";
            ResultSet rs1 = stmt.executeQuery(categoryQuery);

            while (rs1.next()) {
                System.out.println(
                        rs1.getInt("category_id") + " | " +
                        rs1.getString("category_name") + " | " +
                        rs1.getString("description")
                );
            }

            // ================= PRODUCT TEST =================
            System.out.println("\n========== PRODUCT TEST ==========");

            String productQuery = "SELECT * FROM products ORDER BY product_id DESC";
            ResultSet rs2 = stmt.executeQuery(productQuery);

            while (rs2.next()) {
                System.out.println(
                        rs2.getInt("product_id") + " | " +
                        rs2.getString("product_name") + " | " +
                        rs2.getString("brand") + " | " +
                        rs2.getDouble("price") + " | " +
                        rs2.getInt("category_id")
                );
            }

            // ================= PRODUCT BY CATEGORY =================
            System.out.println("\n========== PRODUCT BY CATEGORY TEST (MEN = 1) ==========");

            String filterQuery = "SELECT product_name, price FROM products WHERE category_id = 1";
            ResultSet rs3 = stmt.executeQuery(filterQuery);

            while (rs3.next()) {
                System.out.println(
                        rs3.getString("product_name") + " | " +
                        rs3.getDouble("price")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}