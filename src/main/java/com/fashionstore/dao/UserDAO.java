package com.fashionstore.dao;

import java.util.List;
import com.fashionstore.model.User;

public interface UserDAO {
    boolean registerUser(User user);
    User loginUser(String email, String password);
    User getUserById(int userId);
    User getUserByEmail(String email);
    boolean updateUser(User user);
    boolean updatePassword(int userId, String newPassword);
    boolean deleteUser(int userId);
    boolean existsByEmail(String email);
    boolean existsByPhone(String phone);
    List<User> getAllUsers();
}