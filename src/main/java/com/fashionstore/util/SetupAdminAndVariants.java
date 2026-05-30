package com.fashionstore.util;

import java.sql.*;

public class SetupAdminAndVariants {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            System.out.println("=== Setting Up Admin Portal & Color Variants ===\n");

            // 1. Create admins table
            stmt.execute("CREATE TABLE IF NOT EXISTS admins (" +
                    "admin_id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "full_name VARCHAR(100) NOT NULL, " +
                    "email VARCHAR(100) UNIQUE NOT NULL, " +
                    "password VARCHAR(255) NOT NULL, " +
                    "phone VARCHAR(20), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)");
            System.out.println("[OK] Created admins table.");

            // 2. Add image_url column to product_variants if not exists
            try {
                stmt.execute("ALTER TABLE product_variants ADD COLUMN image_url VARCHAR(255)");
                System.out.println("[OK] Added image_url to product_variants.");
            } catch (Exception e) { System.out.println("[SKIP] image_url already exists."); }

            // 3. Update existing variants with colors and images
            System.out.println("\n--- Updating Product Variants ---");

            // Men T-Shirt (ID 1) - Colors: Black, White, Navy
            updateVariantColor(conn, 1, "S", "Black", "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=500&fit=crop");
            updateVariantColor(conn, 1, "M", "White", "https://images.unsplash.com/photo-1622445275463-afa2ab738c34?w=400&h=500&fit=crop");
            updateVariantColor(conn, 1, "L", "Navy", "https://images.unsplash.com/photo-1618354691373-d851c5c3a990?w=400&h=500&fit=crop");
            updateVariantColor(conn, 1, "XL", "Black", "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=500&fit=crop");

            // Men Jeans (ID 2) - Colors: Dark Blue, Light Blue
            updateVariantColor(conn, 2, "30", "Dark Blue", "https://images.unsplash.com/photo-1542272454315-4c01d7abdf4a?w=400&h=500&fit=crop");
            updateVariantColor(conn, 2, "32", "Light Blue", "https://images.unsplash.com/photo-1604176354204-9268737828e4?w=400&h=500&fit=crop");
            updateVariantColor(conn, 2, "34", "Dark Blue", "https://images.unsplash.com/photo-1542272454315-4c01d7abdf4a?w=400&h=500&fit=crop");
            updateVariantColor(conn, 2, "36", "Black", "https://images.unsplash.com/photo-1624378439575-d8705ad7ae80?w=400&h=500&fit=crop");

            // Women Dress (ID 3) - Colors: Red, Pink, Black
            updateVariantColor(conn, 3, "S", "Red", "https://images.unsplash.com/photo-1595777457583-95e059d581b8?w=400&h=500&fit=crop");
            updateVariantColor(conn, 3, "M", "Pink", "https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?w=400&h=500&fit=crop");
            updateVariantColor(conn, 3, "L", "Black", "https://images.unsplash.com/photo-1612336307429-8a898d10e223?w=400&h=500&fit=crop");

            // Women Kurti (ID 4) - Colors: Yellow, Green, Maroon
            updateVariantColor(conn, 4, "S", "Yellow", "https://images.unsplash.com/photo-1583391733956-6c78276477e2?w=400&h=500&fit=crop");
            updateVariantColor(conn, 4, "M", "Green", "https://images.unsplash.com/photo-1610030469983-98e550d6193c?w=400&h=500&fit=crop");
            updateVariantColor(conn, 4, "L", "Maroon", "https://images.unsplash.com/photo-1614093302611-8efc4de12964?w=400&h=500&fit=crop");
            updateVariantColor(conn, 4, "XL", "Yellow", "https://images.unsplash.com/photo-1583391733956-6c78276477e2?w=400&h=500&fit=crop");

            // Kids Shirt (ID 5) - Colors: Blue, Orange, Green
            updateVariantColor(conn, 5, "XS", "Blue", "https://images.unsplash.com/photo-1519238263530-99bdd11df2ea?w=400&h=500&fit=crop");
            updateVariantColor(conn, 5, "S", "Orange", "https://images.unsplash.com/photo-1543269664-56d93c1b41a6?w=400&h=500&fit=crop");
            updateVariantColor(conn, 5, "M", "Green", "https://images.unsplash.com/photo-1518831959646-742c3a14ebf7?w=400&h=500&fit=crop");

            // Running Shoes (ID 6) - Colors: Black, White, Red
            updateVariantColor(conn, 6, "6", "Black", "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=500&fit=crop");
            updateVariantColor(conn, 6, "7", "White", "https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=400&h=500&fit=crop");
            updateVariantColor(conn, 6, "8", "Red", "https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400&h=500&fit=crop");
            updateVariantColor(conn, 6, "9", "Black", "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&h=500&fit=crop");
            updateVariantColor(conn, 6, "10", "White", "https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=400&h=500&fit=crop");
            updateVariantColor(conn, 6, "11", "Red", "https://images.unsplash.com/photo-1608231387042-66d1773070a5?w=400&h=500&fit=crop");

            // Leather Belt (ID 7) - Colors: Brown, Black, Tan
            updateVariantColor(conn, 7, "S", "Brown", "https://images.unsplash.com/photo-1624222247344-550fb60583dc?w=400&h=500&fit=crop");
            updateVariantColor(conn, 7, "M", "Black", "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&h=500&fit=crop");
            updateVariantColor(conn, 7, "L", "Tan", "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&h=500&fit=crop");
            updateVariantColor(conn, 7, "XL", "Brown", "https://images.unsplash.com/photo-1624222247344-550fb60583dc?w=400&h=500&fit=crop");

            System.out.println("\n=== Setup Complete ===");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void updateVariantColor(Connection conn, int productId, String size, String color, String imageUrl) {
        String sql = "UPDATE product_variants SET color = ?, image_url = ? WHERE product_id = ? AND size = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, color);
            ps.setString(2, imageUrl);
            ps.setInt(3, productId);
            ps.setString(4, size);
            int updated = ps.executeUpdate();
            System.out.println("  Product " + productId + " | Size " + size + " -> " + color + " (" + (updated > 0 ? "OK" : "NOT FOUND") + ")");
        } catch (Exception e) { System.out.println("  ERROR: " + e.getMessage()); }
    }
}
