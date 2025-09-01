<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Contact - Electronic Store</title>
    <style>
        body { margin: 0; font-family: Arial, sans-serif; background: url(https://cdn.pixabay.com/photo/2016/12/21/16/34/shopping-cart-1923313_1280.png) no-repeat center center fixed; background-size: cover; color: white; }
        .navbar { display: flex; justify-content: space-between; align-items: center; background: rgba(0,0,0,0.7); padding: 15px 40px; }
        .navbar .logo { font-size: 24px; font-weight: bold; color: #00d4ff; display: flex; align-items: center; }
        .navbar .logo .nav-logo { width: 40px; height: 40px; border-radius: 50%; margin-right: 10px; }
        .navbar .profile img { width: 35px; height: 35px; border-radius: 50%; cursor: pointer; }
        .content { min-height: 75vh; background: rgba(0,0,0,0.5); padding: 60px; }
        .content h1 { font-size: 50px; color: #00d4ff; margin-bottom: 20px; }
        .content p, .content ul { font-size: 18px; line-height: 1.6; }
        .footer { background: rgba(0,0,0,0.8); padding: 20px; text-align: center; font-size: 14px; }
        .footer a { color: #00d4ff; margin: 0 10px; text-decoration: none; }
        .footer a:hover { text-decoration: underline; }
    </style>
</head>
<body>
<!-- Navbar -->
<div class="navbar">
    <div class="logo">
        <a href="home.jsp" style="display: flex; align-items: center; text-decoration: none; color: #00d4ff;">
            <img src="https://cdn.pixabay.com/photo/2016/12/21/16/34/shopping-cart-1923313_1280.png" 
                 alt="Logo" class="nav-logo">
            Electronic Store
        </a>
    </div>
    <div class="profile" onclick="location.href='home.jsp'">
        <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="Profile">
    </div>
</div>


    <!-- Page Content -->
    <div class="content">
        <h1>Contact Us</h1>
        <p>If you have any queries or need support, feel free to reach us:</p>
        <ul>
            <li>Email: support@electronicstore.com</li>
            <li>Phone: +91-9876543210</li>
            <li>Address: Electronic Store ,Jubilee Hills Checkpost, Hyderabad, India</li>
        </ul>
    </div>

    <!-- Footer -->
    <div class="footer">
        <p>&copy; 2025 Electronic Store |
            <a href="about.jsp">About Us</a> |
            <a href="services.jsp">Services</a> |
            <a href="contact.jsp">Contact</a>
        </p>
    </div>
</body>
</html>
