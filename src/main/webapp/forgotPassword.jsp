<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>

<%
String username = request.getParameter("username");
String newPassword = request.getParameter("newPassword");
String confirmPassword = request.getParameter("confirmPassword");

if(username != null && newPassword != null && confirmPassword != null){
    if(!newPassword.equals(confirmPassword)){
        out.println("<p style='color:red;'>Passwords do not match!</p>");
        out.println("<a href='index.jsp'>Go Back</a>");
    } else {
        try{
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE users SET password=? WHERE username=? AND role IN ('user','supplier')");
            ps.setString(1, newPassword);
            ps.setString(2, username);
            int updated = ps.executeUpdate();
            if(updated > 0){
                out.println("<p style='color:green;'>Password updated successfully!</p>");
            } else {
                out.println("<p style='color:red;'>Username not found!</p>");
            }
            out.println("<a href='index.jsp'>Back to Login</a>");
        } catch(Exception ex){
            out.println("<p style='color:red;'>Error: "+ex.getMessage()+"</p>");
        }
    }
} else {
    response.sendRedirect("index.jsp");
}
%>
