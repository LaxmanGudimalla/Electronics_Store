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
        
        .hero strong{
        	font-size:23px;
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
<strong>Welcome to Electronic Store,</strong> <br>
Your ultimate destination for everything tech!
Since our inception, we have been committed to delivering the latest gadgets, appliances, and accessories that bring convenience and innovation to your life.
We partner with the best global brands to ensure you get top-quality products at prices that truly fit your budget.
Whether you’re upgrading your home, enhancing your work setup, or looking for the perfect gift, we have something for everyone.
<br>

With our <b>24/7 customer support</b> and easy returns policy, your satisfaction is always guaranteed. <br>
Discover the future of electronics today – only at Electronic Store, where technology meets trust.
        </p>
        <button onclick="location.href='index.jsp'">Shop Now</button>
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
