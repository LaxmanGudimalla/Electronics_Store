<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>

<%
String uname = request.getParameter("username");
String pass = request.getParameter("password");
String role = request.getParameter("role");

if(uname != null && pass != null && role != null){
    try {
        PreparedStatement check = conn.prepareStatement("SELECT id FROM users WHERE username=?");
        check.setString(1, uname);
        ResultSet rs = check.executeQuery();

        if(rs.next()){
            // Username already exists
            response.sendRedirect("index.jsp?msg=Username+already+exists");
        } else {
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO users(username, password, role) VALUES(?,?,?)"
            );
            ps.setString(1, uname);
            ps.setString(2, pass);
            ps.setString(3, role);
            ps.executeUpdate();

            response.sendRedirect("index.jsp?msg=Account+Created+Successfully");
        }
    } catch(Exception e){
        response.sendRedirect("index.jsp?msg=Error:+"+e.getMessage());
    }
} else {
    response.sendRedirect("index.jsp?msg=Invalid+Input");
}
%>
