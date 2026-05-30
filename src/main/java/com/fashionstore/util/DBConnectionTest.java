package com.fashionstore.util;

import java.sql.Connection;

public class DBConnectionTest {

    public static void main(String[] args) {
        try (Connection connection = DBConnection.getConnection()) {
            if (connection != null) {
                System.out.println("Database connected successfully");
            } else {
                System.out.println("Failed to connect to database.");
            }
        } catch (Exception e) {
            System.out.println("Database connection failed.");
            e.printStackTrace();
        }
    }
}