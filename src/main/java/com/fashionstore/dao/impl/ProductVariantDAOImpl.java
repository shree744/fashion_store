package com.fashionstore.dao.impl;

import com.fashionstore.dao.ProductVariantDAO;
import com.fashionstore.model.ProductVariant;
import com.fashionstore.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductVariantDAOImpl implements ProductVariantDAO {

    @Override
    public int addVariant(ProductVariant variant) {
        String sql = "INSERT INTO product_variants (product_id, size, color, stock_quantity, image_url) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, variant.getProductId());
            ps.setString(2, variant.getSize());
            ps.setString(3, variant.getColor());
            ps.setInt(4, variant.getStockQuantity());
            ps.setString(5, variant.getImageUrl());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    @Override
    public boolean updateVariant(ProductVariant variant) {
        String sql = "UPDATE product_variants SET size=?, color=?, stock_quantity=?, image_url=? WHERE variant_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, variant.getSize());
            ps.setString(2, variant.getColor());
            ps.setInt(3, variant.getStockQuantity());
            ps.setString(4, variant.getImageUrl());
            ps.setInt(5, variant.getVariantId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public boolean deleteVariant(int variantId) {
        String sql = "DELETE FROM product_variants WHERE variant_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, variantId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    @Override
    public ProductVariant getVariantById(int variantId) {
        String sql = "SELECT * FROM product_variants WHERE variant_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, variantId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractVariant(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public List<ProductVariant> getVariantsByProductId(int productId) {
        List<ProductVariant> list = new ArrayList<>();
        String sql = "SELECT * FROM product_variants WHERE product_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                list.add(extractVariant(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    @Override
    public ProductVariant getVariantByProductIdAndSize(int productId, String size) {
        String sql = "SELECT * FROM product_variants WHERE product_id=? AND size=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ps.setString(2, size);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return extractVariant(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public ProductVariant getVariantByProductSizeAndColor(int productId, String size, String color) {
        String sql = "SELECT * FROM product_variants WHERE product_id=? AND size=? AND color=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ps.setString(2, size);
            ps.setString(3, color);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractVariant(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public boolean updateStock(int variantId, int stockQuantity) {
        String sql = "UPDATE product_variants SET stock_quantity=? WHERE variant_id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, stockQuantity);
            ps.setInt(2, variantId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // 🔥 Helper method
    private ProductVariant extractVariant(ResultSet rs) throws SQLException {
        ProductVariant variant = new ProductVariant();

        variant.setVariantId(rs.getInt("variant_id"));
        variant.setProductId(rs.getInt("product_id"));
        variant.setSize(rs.getString("size"));
        variant.setColor(rs.getString("color"));
        variant.setStockQuantity(rs.getInt("stock_quantity"));
        variant.setImageUrl(rs.getString("image_url"));

        return variant;
    }
}