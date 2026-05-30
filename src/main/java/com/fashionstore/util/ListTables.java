package com.fashionstore.util;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.ResultSet;

public class ListTables {
    public static void main(String[] args) {
        try (Connection conn = DBConnection.getConnection()) {
            DatabaseMetaData metaData = conn.getMetaData();
            ResultSet rs = metaData.getTables(null, null, "%", new String[]{"TABLE"});
            System.out.println("Tables in database:");
            while (rs.next()) {
                System.out.println(rs.getString("TABLE_NAME"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
