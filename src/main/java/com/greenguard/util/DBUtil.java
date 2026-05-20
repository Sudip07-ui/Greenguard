package com.greenguard.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBUtil – central database connection factory.
 * Update DB_URL, DB_USER, DB_PASS to match your environment.
 */
public class DBUtil {

    private static final String DB_URL  = "jdbc:mysql://localhost:3306/greenguard_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";          // change in production

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    public static void close(AutoCloseable... resources) {
        for (AutoCloseable r : resources) {
            if (r != null) {
                try { r.close(); } catch (Exception ignored) {}
            }
        }
    }
}
