<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<%@ include file="header.jspf" %>
<%
if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) { 
    response.sendRedirect("index.jsp"); return; 
}

String action = request.getParameter("action");
if("reset".equals(action)){
    int uid = Integer.parseInt(request.getParameter("user_id"));
    String np = request.getParameter("new_password");
    try(PreparedStatement ps = conn.prepareStatement("UPDATE users SET password=? WHERE id=?")){
        ps.setString(1, np);
        ps.setInt(2, uid);
        int r = ps.executeUpdate();
        if(r>0) out.println("<p style='color:green'>Password updated successfully.</p>");
        else out.println("<p class='alert'>User not found.</p>");
    } catch(Exception e){ out.println("<p class='alert'>"+e.getMessage()+"</p>"); }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Reset User Password</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: url('https://cdn.pixabay.com/photo/2016/12/21/16/34/shopping-cart-1923313_1280.png') no-repeat center center fixed;
            background-size: cover;
            color: #333;
        }
		
		/* Navbar Styles */
        .navbar {
            display: flex;
            background-color: rgba(0,0,0,0.8);
            padding: 15px 30px;
            justify-content: flex-start;
            align-items: center;
        }
        .navbar a {
            color: white;
            text-decoration: none;
            padding: 10px 20px;
            margin-right: 15px;
            border-radius: 6px;
            transition: 0.3s;
            font-weight: bold;
        }
        .navbar a:hover {
            background-color: #0275d8;
        }
		
        .container {
            max-width: 500px;
            margin: 60px auto;
            background:rgba(136, 135, 134, 0.78);
            padding: 30px 25px;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0,0,0,0.3);
        }
        h2 {
            text-align: center;
            color: #0275d8;
            margin-bottom: 25px;
        }
        form label {
            font-weight: bold;
            margin-top: 10px;
            display: block;
        }
        select, input[type=text], input[type=submit] {
            width: 100%;
            padding: 8px 10px;
            margin: 8px 0 15px 0;
            border-radius: 6px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        input[type=submit] {
            background-color: #0275d8;
            color: white;
            border: none;
            cursor: pointer;
            transition: 0.3s;
        }
        input[type=submit]:hover {
            background-color: #025aa5;
        }
        .alert { color: red; font-weight: bold; margin-bottom: 10px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Reset User Password</h2>
    <form method="post">
        <input type="hidden" name="action" value="reset">
        
        <label>User</label>
        <select name="user_id" required>
            <option value="">--Select User--</option>
            <%
            try(Statement st = conn.createStatement(); 
                ResultSet rs = st.executeQuery("SELECT id, username, role FROM users ORDER BY username")){
                while(rs.next()){
            %>
                <option value="<%=rs.getInt("id")%>">
                    <%=rs.getString("username")%> ( <%=rs.getString("role")%> )
                </option>
            <% }} %>
        </select>
        
        <label>New Password</label>
        <input type="text" name="new_password" placeholder="Enter new password" required>
        
        <input type="submit" value="Update Password">
    </form>
</div>
</body>
</html>
