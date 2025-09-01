<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<%@ include file="header.jspf" %>
<%
if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
    response.sendRedirect("index.jsp"); return;
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: url('https://cdn.pixabay.com/photo/2016/12/21/16/34/shopping-cart-1923313_1280.png') no-repeat center center fixed;
            background-size: cover;
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

        /* Main container */
        .container {
            max-width: 700px;
            margin: 50px auto;
            background: rgba(136, 135, 134, 0.78);
            padding: 30px 25px;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0,0,0,0.3);
            text-align: center;
        }
        h2 {
            color: #0275d8;
            margin-bottom: 25px;
        }
        ul {
            list-style: none;
            padding: 0;
        }
        li {
            margin: 15px 0;
        }
        .dashboard-links a {
            display: block;
            background-color: #0275d8;
            color: white;
            text-decoration: none;
            padding: 12px 20px;
            border-radius: 8px;
            transition: 0.3s;
            font-weight: bold;
        }
        .dashboard-links a:hover {
            background-color: #025aa5;
        }
    </style>
</head>
<body>

    <div class="container">
        <h2>Admin Dashboard</h2>
        <div class="dashboard-links">
            <ul>
                <li><a href="manageCategories.jsp">Manage Categories</a></li>
                <li><a href="manageUsers.jsp">View Users & Suppliers</a></li>
                <li><a href="resetPasswords.jsp">Reset Passwords</a></li>
                <li><a href="setLimits.jsp">Set Product Measurement Limits</a></li>
            </ul>
        </div>
    </div>

</body>
</html>
