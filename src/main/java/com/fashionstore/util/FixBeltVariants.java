package com.fashionstore.util;

import java.sql.*;

public class FixBeltVariants {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            // Check belt variants
            System.out.println("=== Leather Belt Variants ===");
            ResultSet rs = stmt.executeQuery("SELECT variant_id, product_id, size, color, image_url FROM product_variants WHERE product_id = 7");
            while (rs.next()) {
                System.out.println("  ID:" + rs.getInt("variant_id") + " | Size:'" + rs.getString("size") + "' | Color:" + rs.getString("color") + " | Img:" + rs.getString("image_url"));
            }

            // Check all product_ids
            System.out.println("\n=== All Products ===");
            rs = stmt.executeQuery("SELECT product_id, product_name FROM products");
            while (rs.next()) {
                System.out.println("  ID:" + rs.getInt("product_id") + " | " + rs.getString("product_name"));
            }

            // Check belt variants by name
            System.out.println("\n=== Belt by name ===");
            rs = stmt.executeQuery("SELECT pv.variant_id, pv.product_id, pv.size, pv.color, pv.image_url " +
                    "FROM product_variants pv JOIN products p ON pv.product_id = p.product_id " +
                    "WHERE p.product_name LIKE '%Belt%'");
            while (rs.next()) {
                int vid = rs.getInt("variant_id");
                int pid = rs.getInt("product_id");
                String size = rs.getString("size");
                System.out.println("  VID:" + vid + " PID:" + pid + " Size:'" + size + "' Color:" + rs.getString("color"));
                
                // Update color and image
                String color = "Brown";
                String imgUrl = "https://images.unsplash.com/photo-1624222247344-550fb60583dc?w=400&h=500&fit=crop";
                if ("M".equals(size.trim()) || "32".equals(size.trim())) {
                    color = "Black";
                    imgUrl = "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&h=500&fit=crop";
                } else if ("L".equals(size.trim()) || "34".equals(size.trim())) {
                    color = "Tan";
                    imgUrl = "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&h=500&fit=crop";
                }
                
                PreparedStatement ps = conn.prepareStatement("UPDATE product_variants SET color = ?, image_url = ? WHERE variant_id = ?");
                ps.setString(1, color);
                ps.setString(2, imgUrl);
                ps.setInt(3, vid);
                int updated = ps.executeUpdate();
                System.out.println("    -> Updated to " + color + " (" + updated + " rows)");
                ps.close();
            }

        } catch (Exception e) { e.printStackTrace(); }
    }
}
