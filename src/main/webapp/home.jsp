<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Electronic Store</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: url(https://cdn.pixabay.com/photo/2016/12/21/16/34/shopping-cart-1923313_1280.png) no-repeat center center fixed;
            background-size: cover;
            color: white;
        }

        /* Navbar */
        .navbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background: rgba(0,0,0,0.7);
            padding: 15px 40px;
        }

        .navbar .logo {
            font-size: 24px;
            font-weight: bold;
            color: #00d4ff;
            display: flex;
            align-items: center;
        }

        .navbar .logo .nav-logo {
            width: 40px;         /* Logo size */
            height: 40px;
            border-radius: 50%;  /* Circular shape */
            margin-right: 10px;  /* Spacing between logo and text */
        }

        .navbar .profile {
            cursor: pointer;
        }

        .navbar .profile img {
            width: 35px;
            height: 35px;
            border-radius: 50%;
        }

        /* Hero Section */
        .hero {
            height: 80vh;
            display: flex;
            flex-direction: column;
            justify-content: center;
            padding-left: 60px;
            background: rgba(0,0,0,0.5);
        }

        .hero h1 {
            font-size: 60px;
            margin-bottom: 20px;
            color: #00d4ff;
        }

        .hero p {
            font-size: 18px;
            max-width: 600px;
            line-height: 1.6;
            margin-bottom: 30px;
        }

        .hero button {
            padding: 12px 25px;
            font-size: 18px;
            background-color: #00d4ff;
            color: black;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            transition: 0.3s;
        }

        .hero button:hover {
            background-color: #009ec1;
        }

        /* Footer */
        .footer {
            background: rgba(0,0,0,0.8);
            padding: 20px;
            text-align: center;
            font-size: 14px;
        }

        .footer a {
            color: #00d4ff;
            margin: 0 10px;
            text-decoration: none;
        }

        .footer a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <div class="navbar">
        <div class="logo">
            <img src="https://cdn.pixabay.com/photo/2016/12/21/16/34/shopping-cart-1923313_1280.png" 
                 alt="Logo" class="nav-logo">
            Electronic Store
        </div>
        <div class="profile" onclick="location.href='index.jsp'">
            <img src="https://cdn-icons-png.flaticon.com/512/149/149071.png" alt="Profile">
        </div>
    </div>

    <!-- Hero Section -->
    <div class="hero">
        <h1>Electronic Store</h1>
        <p>
            Welcome to Electronic Store – your one-stop destination for the latest gadgets, appliances, and accessories.  
            We bring you the best brands at unbeatable prices.  
            Shop smart, save big, and stay connected with technology that matters.  
            Experience seamless shopping and fast delivery with us.  
            Discover the future of electronics today!
        </p>
        <button onclick="location.href='index.jsp'">Shop Now</button>
    </div>

    <!-- Footer -->
    <div class="footer">
        <p>&copy; 2025 Electronic Store | 
            <a href="#">About Us</a> | 
            <a href="#">Services</a> | 
            <a href="#">Contact</a>
        </p>
    </div>

</body>
</html>
