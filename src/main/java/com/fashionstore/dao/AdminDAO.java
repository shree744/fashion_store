package com.fashionstore.dao;

import com.fashionstore.model.Admin;

public interface AdminDAO {
    boolean registerAdmin(Admin admin);
    Admin loginAdmin(String email, String password);
    Admin getAdminById(int adminId);
    boolean updateAdmin(Admin admin);
    boolean isEmailExists(String email);
}
