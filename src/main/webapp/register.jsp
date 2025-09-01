<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Create Account</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
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
		
        .container {
            max-width: 400px;
            margin: 50px auto;
            background: rgba(255,255,255,0.95);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.3);
        }
        h1 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }
        input[type=text], input[type=password], select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            margin-bottom: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        input[type=submit], a.button-link {
            width: 100%;
            padding: 10px;
            background-color: #0275d8;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
            text-decoration: none;
            display: inline-block;
        }
        input[type=submit]:hover, a.button-link:hover {
            background-color: #025aa5;
        }
        .alert {
            text-align: center;
            margin-top: 15px;
            padding: 10px;
            border-radius: 5px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 15px;
            width: 380px; 
    		height: 45px; 
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Create Account</h1>

    <form method="post">
        <input type="hidden" name="action" value="register"/>
        <label>Username</label>
        <input type="text" name="username" required/>

        <label>Password</label>
        <input type="password" name="password" required/>

        <label>Role</label>
        <select name="role" required>
            <option value="user">User</option>
            <option value="supplier">Supplier</option>
        </select>

        <input type="submit" value="Register"/>
    </form>

    <div class="back-link">
        <a href="index.jsp" class="button-link">Back to Login</a>
    </div>

<%
if("register".equals(request.getParameter("action"))){
    String uname = request.getParameter("username");
    String pass = request.getParameter("password");
    String role = request.getParameter("role");

    try {
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO users(username, password, role) VALUES(?,?,?)"
        );
        ps.setString(1, uname);
        ps.setString(2, pass);
        ps.setString(3, role);
        ps.executeUpdate();
%>
        <div class="alert alert-success">Registration successful! Login now.</div>
<%
    } catch(Exception e){
%>
        <div class="alert alert-error"><%= e.getMessage() %></div>
<%
    }
}
%>
</div>
</body>
</html>
