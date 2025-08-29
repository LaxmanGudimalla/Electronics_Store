<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<%@ include file="header.jspf" %>
<%
if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) { 
    response.sendRedirect("index.jsp"); return; 
}

// Handle deletion
String deleteUserIdStr = request.getParameter("deleteUserId");
if(deleteUserIdStr != null){
    int deleteUserId = Integer.parseInt(deleteUserIdStr);
    if(deleteUserId != 1){ // Optional: prevent deleting admin with id=1
        try(PreparedStatement ps = conn.prepareStatement("DELETE FROM users WHERE id=?")){
            ps.setInt(1, deleteUserId);
            ps.executeUpdate();
            out.println("<p style='color:green'>User deleted successfully.</p>");
        } catch(Exception e){
            out.println("<p style='color:red'>Error deleting user: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p style='color:red'>Cannot delete admin user.</p>");
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Users & Suppliers</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: url('https://cdn.pixabay.com/photo/2016/12/21/16/34/shopping-cart-1923313_1280.png') no-repeat center center fixed;
            background-size: cover;
            color: #333;
        }
        .container {
            max-width: 900px;
            margin: 50px auto;
            background: rgba(255,255,255,0.95);
            padding: 30px 25px;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0,0,0,0.3);
        }
        h2 { color: #0275d8; margin-bottom: 20px; }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 10px 8px;
            text-align: center;
        }

        th {
            background-color: #0275d8;
            color: white;
        }

        input[type=submit] {
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            background-color: #d9534f;
            color: white;
            cursor: pointer;
            transition: 0.3s;
        }

        input[type=submit]:hover {
            background-color: #c9302c;
        }

        .alert { margin-top: 10px; color: red; }
    </style>
</head>
<body>
<div class="container">
    <h2>All Users & Suppliers</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Role</th>
            <th>Action</th>
        </tr>
    <%
    try(Statement st = conn.createStatement(); 
        ResultSet rs = st.executeQuery("SELECT id, username, role FROM users ORDER BY id")) {
        while(rs.next()){
            int uid = rs.getInt("id");
            String uname = rs.getString("username");
            String role = rs.getString("role");
    %>
        <tr>
            <td><%=uid%></td>
            <td><%=uname%></td>
            <td><%=role%></td>
            <td>
                <% if(!"admin".equals(role)){ %>
                    <form method="get" style="margin:0;">
                        <input type="hidden" name="deleteUserId" value="<%=uid%>"/>
                        <input type="submit" value="Delete"/>
                    </form>
                <% } %>
            </td>
        </tr>
    <% }} %>
    </table>
</div>
</body>
</html>
