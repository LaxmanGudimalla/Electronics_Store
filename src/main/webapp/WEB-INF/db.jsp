
<%@ page import="java.sql.*" %>

<%! 
// Declare class-level variables to avoid duplicate declarations
Connection conn = null;
String dbUrl = "jdbc:mysql://localhost:3306/e_store";
String dbUser = "root";
String dbPass = "root";
%>

<%
if (conn == null) {
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbUrl, dbUser, dbPass);
    } catch(Exception e) {
        out.println("DB Connection Error: " + e.getMessage());
    }
}
%>
