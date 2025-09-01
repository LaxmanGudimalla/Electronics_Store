<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>About Us - Electronic Store</title>
    <link rel="stylesheet" href="style.css"> <!-- optional external CSS -->
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: url(https://cdn.pixabay.com/photo/2016/12/21/16/34/shopping-cart-1923313_1280.png) no-repeat center center fixed;
            background-size: cover;
            color: white;
        }
        .navbar { display: flex; justify-content: space-between; align-items: center; background: rgba(0,0,0,0.7); padding: 15px 40px; }
        .navbar .logo { font-size: 24px; font-weight: bold; color: #00d4ff; display: flex; align-items: center; }
        .navbar .logo .nav-logo { width: 40px; height: 40px; border-radius: 50%; margin-right: 10px; }
        .navbar .profile img { width: 35px; height: 35px; border-radius: 50%; cursor: pointer; }
        .content { min-height: 75vh; background: rgba(0,0,0,0.5); padding: 60px; }
        .content h1 { font-size: 50px; color: #00d4ff; margin-bottom: 20px; }
        .content p { font-size: 18px; line-height: 1.6; max-width: 800px; }
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
    <div class="profile" onclick="location.href='index.jsp'">
        <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="Profile">
    </div>
</div>


    <!-- Page Content -->
    <div class="content">
        <h1>About Us</h1>
        <p>
At Electronic Store, <br>we are passionate about bringing the world of technology closer to you.
Since 2010, we have been a trusted destination for gadgets, appliances, and accessories.
Our mission is to make technology accessible, affordable, and reliable for everyone.

We pride ourselves on offering a wide range of latest electronics from leading brands.
From smartphones to laptops, home appliances to wearables – we have it all.
Every product goes through strict quality checks to ensure trust and durability.

Our customers are at the heart of everything we do.
That’s why we provide dedicated support and quick resolutions for all queries.
With secure payments and fast delivery, shopping with us is always hassle-free.

We believe in quality, trust, and innovation – values that define our journey.
Electronic Store is not just a shop, it’s your tech partner for life.
        </p>
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
