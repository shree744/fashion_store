package com.fashionstore.dao.impl;

import com.fashionstore.dao.AdminDAO;
import com.fashionstore.model.Admin;
import com.fashionstore.util.DBConnection;

import java.sql.*;

public class AdminDAOImpl implements AdminDAO {

    @Override
    public boolean registerAdmin(Admin admin) {
        String sql = "INSERT INTO admins (full_name, email, password, phone) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, admin.getFullName());
            ps.setString(2, admin.getEmail());
            ps.setString(3, admin.getPassword());
            ps.setString(4, admin.getPhone());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public Admin loginAdmin(String email, String password) {
        String sql = "SELECT * FROM admins WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractAdmin(rs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public Admin getAdminById(int adminId) {
        String sql = "SELECT * FROM admins WHERE admin_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, adminId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return extractAdmin(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public boolean updateAdmin(Admin admin) {
        String sql = "UPDATE admins SET full_name = ?, profile_image = ? WHERE admin_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, admin.getFullName());
            ps.setString(2, admin.getProfileImage());
            ps.setInt(3, admin.getAdminId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public boolean isEmailExists(String email) {
        String sql = "SELECT 1 FROM admins WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            return ps.executeQuery().next();
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private Admin extractAdmin(ResultSet rs) throws SQLException {
        Admin admin = new Admin();
        admin.setAdminId(rs.getInt("admin_id"));
        admin.setFullName(rs.getString("full_name"));
        admin.setEmail(rs.getString("email"));
        admin.setPassword(rs.getString("password"));
        admin.setPhone(rs.getString("phone"));
        admin.setProfileImage(rs.getString("profile_image"));
        return admin;
    }
}
