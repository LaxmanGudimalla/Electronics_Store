<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<%@ include file="header.jspf" %>
<%
if(session.getAttribute("role") == null || !"supplier".equals(session.getAttribute("role"))) { 
    response.sendRedirect("index.jsp"); return; 
}
int uid = (Integer)session.getAttribute("userId");

String action = request.getParameter("action");
if("change".equals(action)){
    String oldp = request.getParameter("old_password");
    String newp = request.getParameter("new_password");

    PreparedStatement ps = conn.prepareStatement("SELECT id FROM users WHERE id=? AND password=?");
    ps.setInt(1, uid);
    ps.setString(2, oldp);
    ResultSet rs = ps.executeQuery();
    if(rs.next()){
        PreparedStatement up = conn.prepareStatement("UPDATE users SET password=? WHERE id=?");
        up.setString(1, newp);
        up.setInt(2, uid);
        up.executeUpdate();
        out.println("<p style='color:green; text-align:center;'>Password changed successfully!</p>");
    } else {
        out.println("<p class='alert' style='color:red; text-align:center;'>Old password incorrect.</p>");
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Change Password</title>
    <style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    position: relative;  /* needed for ::before */

}

body::before {
    content: "";
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: url('https://cdn.pixabay.com/photo/2016/12/21/16/34/shopping-cart-1923313_1280.png') no-repeat center center fixed;
    background-size: cover;
    filter: blur(5px);   /* adjust blur amount */
    z-index: -1;         /* behind content */
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
            max-width: 400px;
            margin: 80px auto;
            background:rgba(136, 135, 134, 0.78);
            padding: 30px 25px;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0,0,0,0.3);
            text-align: center;
        }
        h2 {
            color: #0275d8;
            margin-bottom: 20px;
        }
        label {
            display: block;
            text-align: left;
            margin-top: 10px;
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="password"] {
            width: 100%;
            padding: 8px;
            margin-bottom: 15px;
            border-radius: 5px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        input[type="submit"] {
            background-color: #0275d8;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: 0.3s;
        }
        input[type="submit"]:hover {
            background-color: #025aa5;
        }
        .back-btn {
            display: inline-block;
            margin-top: 15px;
            text-decoration: none;
            color: white;
            background-color: #5cb85c;
            padding: 8px 16px;
            border-radius: 6px;
            transition: 0.3s;
        }
        .back-btn:hover {
            background-color: #4cae4c;
        }
        .alert {
            font-weight: bold;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Change Password</h2>
    <form method="post">
      <input type="hidden" name="action" value="change">
      <label>Old Password</label>
      <input type="password" name="old_password" required>
      <label>New Password</label>
      <input type="password" name="new_password" required>
      <input type="submit" value="Update">
    </form>
    <a href="supplierHome.jsp" class="back-btn">Back to Dashboard</a>
</div>
</body>
</html>
