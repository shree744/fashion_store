package com.fashionstore.dao.impl;

import com.fashionstore.dao.ProductDAO;
import com.fashionstore.model.Product;
import com.fashionstore.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAOImpl implements ProductDAO {

    // ================= FILTER PRODUCTS =================
    @Override
    public List<Product> filterProducts(Integer categoryId, String keyword,
                                        Double minPrice, Double maxPrice,
                                        String sort) {

        List<Product> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            StringBuilder sql = new StringBuilder(
                "SELECT p.* FROM products p " +
                "INNER JOIN categories c ON p.category_id = c.category_id " +
                "WHERE p.is_active=1"
            );

            if (categoryId != null) {
                sql.append(" AND p.category_id = ?");
            }

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append(" AND (LOWER(p.product_name) LIKE ? " +
                           "OR LOWER(p.product_name) LIKE ? " +
                           "OR LOWER(p.brand) LIKE ? " +
                           "OR LOWER(p.brand) LIKE ?)");
            }

            if (minPrice != null) {
                sql.append(" AND p.price >= ?");
            }
            
            if (maxPrice != null) {
                sql.append(" AND p.price <= ?");
            }

            if ("low".equals(sort)) {
                sql.append(" ORDER BY p.price ASC");
            } else if ("high".equals(sort)) {
                sql.append(" ORDER BY p.price DESC");
            } else {
                sql.append(" ORDER BY p.product_id DESC");
            }

            PreparedStatement ps = conn.prepareStatement(sql.toString());
            int idx = 1;

            if (categoryId != null) {
                ps.setInt(idx++, categoryId);
            }

            if (keyword != null && !keyword.trim().isEmpty()) {
                String normalized = keyword.trim().toLowerCase();
                ps.setString(idx++, normalized + "%");
                ps.setString(idx++, "% " + normalized + "%");
                ps.setString(idx++, normalized + "%");
                ps.setString(idx++, "% " + normalized + "%");
            }

            if (minPrice != null) {
                ps.setDouble(idx++, minPrice);
            }

            if (maxPrice != null) {
                ps.setDouble(idx++, maxPrice);
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= LATEST PRODUCTS =================
    @Override
    public List<Product> getLatestProducts(int limit) {

        List<Product> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {

            String sql = "SELECT * FROM products WHERE is_active=1 ORDER BY product_id DESC LIMIT ?";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractProduct(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= GET PRODUCT BY ID =================
    @Override
    public Product getProductById(int id) {

        Product product = null;

        String sql = "SELECT * FROM products WHERE product_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                product = extractProduct(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return product;
    }

    @Override
    public int addProduct(Product product) {
        String sql = "INSERT INTO products (category_id, product_name, brand, description, price, image_url, is_active) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getProductName());
            ps.setString(3, product.getBrand());
            ps.setString(4, product.getDescription());
            ps.setDouble(5, product.getPrice());
            ps.setString(6, product.getImageUrl());
            ps.setBoolean(7, product.isActive());
            
            if (ps.executeUpdate() > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET category_id=?, product_name=?, brand=?, description=?, price=?, image_url=?, is_active=? WHERE product_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, product.getCategoryId());
            ps.setString(2, product.getProductName());
            ps.setString(3, product.getBrand());
            ps.setString(4, product.getDescription());
            ps.setDouble(5, product.getPrice());
            ps.setString(6, product.getImageUrl());
            ps.setBoolean(7, product.isActive());
            ps.setInt(8, product.getProductId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean deleteProduct(int productId) {
        String sql = "DELETE FROM products WHERE product_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products ORDER BY product_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractProduct(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<Product> getActiveProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE is_active=1 ORDER BY product_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractProduct(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<Product> getProductsByCategoryId(int categoryId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE category_id=? AND is_active=1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractProduct(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public List<Product> searchProducts(String keyword) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM products WHERE (product_name LIKE ? OR brand LIKE ?) AND is_active=1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractProduct(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public boolean updateProductStatus(int productId, boolean isActive) {
        String sql = "UPDATE products SET is_active=? WHERE product_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public List<String> getAllBrands() {
        List<String> list = new ArrayList<>();
        String sql = "SELECT DISTINCT brand FROM products WHERE is_active=1 AND brand IS NOT NULL AND brand != ''";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(rs.getString("brand"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    private Product extractProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getInt("product_id"));
        p.setCategoryId(rs.getInt("category_id"));
        p.setProductName(rs.getString("product_name"));
        p.setBrand(rs.getString("brand"));
        p.setDescription(rs.getString("description"));
        p.setPrice(rs.getDouble("price"));
        p.setImageUrl(rs.getString("image_url"));
        p.setActive(rs.getBoolean("is_active"));
        p.setAverageRating(rs.getDouble("average_rating"));
        return p;
    }
}