/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBContext {
    private static final String serverName = "DESKTOP-ASBGKD8";
    private static final String dbName = "toyshop";
    private static final String portNumber = "1433";
    private static final String userID = "sa";
    private static final String password = "123456";
    
    public Connection getConnection() throws Exception {
        try {
            String url = "jdbc:sqlserver://" + serverName + ":" + portNumber
                    + ";databaseName=" + dbName
                    + ";encrypt=true"
                    + ";trustServerCertificate=true";  // Thêm tham số này
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(url, userID, password);
        } catch (ClassNotFoundException | SQLException e) {
            throw new Exception("Error connecting to database: " + e.getMessage());
        }
    }
}
