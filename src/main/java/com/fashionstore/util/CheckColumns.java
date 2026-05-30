package com.fashionstore.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

public class CheckColumns {
    public static void main(String[] args) {
        String[] tables = {"products", "product_variants", "cart_items", "carts"};
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {
            for (String table : tables) {
                System.out.println("Columns in " + table + ":");
                try (ResultSet rs = stmt.executeQuery("SELECT * FROM " + table + " LIMIT 0")) {
                    ResultSetMetaData rsmd = rs.getMetaData();
                    int columnCount = rsmd.getColumnCount();
                    for (int i = 1; i <= columnCount; i++) {
                        System.out.print(rsmd.getColumnName(i) + " (" + rsmd.getColumnTypeName(i) + "), ");
                    }
                    System.out.println("\n");
                } catch (Exception e) {
                    System.out.println("Error reading " + table + ": " + e.getMessage());
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
