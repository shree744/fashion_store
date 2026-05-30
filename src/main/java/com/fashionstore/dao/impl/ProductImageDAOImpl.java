package com.fashionstore.dao.impl;

import com.fashionstore.dao.ProductImageDAO;
import com.fashionstore.model.ProductImage;
import com.fashionstore.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductImageDAOImpl implements ProductImageDAO {

    @Override
    public boolean addProductImage(ProductImage image) {
        String sql = "INSERT INTO product_images (product_id, image_url) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, image.getProductId());
            ps.setString(2, image.getImageUrl());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public List<ProductImage> getImagesByProductId(int productId) {
        List<ProductImage> list = new ArrayList<>();
        String sql = "SELECT * FROM product_images WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductImage img = new ProductImage();
                img.setImageId(rs.getInt("image_id"));
                img.setProductId(rs.getInt("product_id"));
                img.setImageUrl(rs.getString("image_url"));
                list.add(img);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    @Override
    public boolean deleteProductImage(int imageId) {
        String sql = "DELETE FROM product_images WHERE image_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, imageId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean deleteImagesByProductId(int productId) {
        String sql = "DELETE FROM product_images WHERE product_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}
