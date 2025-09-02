<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>Electronics Store - Login</title>
    <link rel="stylesheet" href="assets/styles.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
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

        /* Navbar */
        .navbar {
            display: flex;
            align-items: center;
            background: rgba(0,0,0,0.7);
            padding: 12px 30px;
        }

        .navbar .logo {
            font-size: 20px;
            font-weight: bold;
            color: #00d4ff;
            display: flex;
            align-items: center;
            cursor: pointer;
        }

        .navbar .logo .nav-logo {
            width: 35px;
            height: 35px;
            border-radius: 50%;
            margin-right: 8px;
        }

        .container {
            width: 400px;
            margin: 80px auto;
            background: rgba(136, 135, 134, 0.78);
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0,0,0,0.4);
            text-align: center;
        }

        h1 { margin-bottom: 20px; }
        input[type=text], input[type=password], select {
            width: 90%;
            padding: 10px;
            margin: 8px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        input[type=submit], button {
            padding: 10px 20px;
            border: none;
            background: #007BFF;
            color: white;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
        }
        input[type=submit]:hover, button:hover { background: #0056b3; }
        a { color: #007BFF; text-decoration: none; }
        a:hover { text-decoration: underline; }
        .alert { color: red; margin-top: 10px; }

        /* Modal Styles */
        .modal { display: none; position: fixed; z-index: 999; padding-top: 100px; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.6); }
        .modal-content { background-color: #fefefe; margin: auto; padding: 20px; border-radius: 10px; width: 350px; box-shadow: 0px 0px 10px rgba(0,0,0,0.3); text-align: center; }
        .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; }
        .close:hover, .close:focus { color: black; cursor: pointer; }
    </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <div class="logo" onclick="location.href='home.jsp'">
        <img src="https://cdn.pixabay.com/photo/2016/12/21/16/34/shopping-cart-1923313_1280.png" 
             alt="Logo" class="nav-logo">
        Electronic Store
    </div>
</div>

<hr/>

<div class="container">
    <h1>Electronics Store</h1> 

    <!-- Show success/error messages -->
    <%
    String msg = request.getParameter("msg");
    if(msg != null) {
        out.println("<div class='alert' style='color:green;'>" + msg + "</div>");
    }
    %>

    <!-- Login Form -->
    <h2>Login</h2>
    <form method="post" autocomplete="off">
        <input type="hidden" name="action" value="login"/>
        <input type="text" name="username" placeholder="Username" required autocomplete="off"/><br/>
        <input type="password" name="password" placeholder="Password" required autocomplete="new-password"/><br/>
        <input type="submit" value="Login"/>
    </form>

    <br/>
    <button id="createAccountBtn">Create New Account</button>
    <br/><br/>
    <a href="#" id="forgotPwdLink">Forgot Password?</a><%
    String error = request.getParameter("error");
    if(error != null){
%>
    <div class="alert" style="color:red; margin-top:5px;"><%= error %></div>
<%
    }
%>
</div>

<!-- Forgot Password Modal -->
<div id="forgotModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h3>Forgot Password</h3>
        <form method="post" action="forgotPassword.jsp">
            <input type="text" name="username" placeholder="Enter your username" required/><br/>
            <input type="password" name="newPassword" placeholder="New Password" required/><br/>
            <input type="password" name="confirmPassword" placeholder="Confirm Password" required/><br/>
            <input type="submit" value="Reset Password"/>
        </form>
    </div>
</div>

<!-- Create Account Modal -->
<div id="registerModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <h3>Create New Account</h3>
<form method="post" action="register.jsp" autocomplete="off">
    <input type="text" name="username" placeholder="Username" required autocomplete="new-username"/><br/>
    <input type="password" name="password" placeholder="Password" required autocomplete="new-password"/><br/>
    <select name="role" required>
        <option value="">Select Role</option>
        <option value="user">User</option>
        <option value="supplier">Supplier</option>
    </select><br/>
    <input type="submit" value="Register"/>
</form>

    </div>
</div>

<%
String action = request.getParameter("action");
if("login".equals(action)){
    String uname = request.getParameter("username");
    String pass = request.getParameter("password");

    try {
        PreparedStatement ps = conn.prepareStatement(
            "SELECT id, role FROM users WHERE username=? AND password=? AND status=1"
        );
        ps.setString(1, uname);
        ps.setString(2, pass);
        ResultSet rs = ps.executeQuery();
        if(rs.next()){
            int userId = rs.getInt("id");
            String role = rs.getString("role");
            session.setAttribute("userId", userId);
            session.setAttribute("username", uname);
            session.setAttribute("role", role);

            switch(role){
                case "admin": response.sendRedirect("adminHome.jsp"); break;
                case "supplier": response.sendRedirect("supplierHome.jsp"); break;
                case "user": response.sendRedirect("userHome.jsp"); break;
                default: out.println("<div class='alert'>Invalid role!</div>");
            }
        } else {
        	response.sendRedirect("index.jsp?error=Invalid+credentials");
        }
    } catch(Exception e){ out.println("<div class='alert'>"+e.getMessage()+"</div>"); }
}
%>

<script>
    // Forgot Password Modal
    var forgotModal = document.getElementById("forgotModal");
    var forgotBtn = document.getElementById("forgotPwdLink");

    // Register Modal
    var registerModal = document.getElementById("registerModal");
    var registerBtn = document.getElementById("createAccountBtn");

    var spans = document.getElementsByClassName("close");

    // Open modals
    forgotBtn.onclick = function() { forgotModal.style.display = "block"; }
    registerBtn.onclick = function() { registerModal.style.display = "block"; }

    // Close modals
    for(let i=0;i<spans.length;i++){
        spans[i].onclick = function() {
            forgotModal.style.display = "none";
            registerModal.style.display = "none";
        }
    }

    window.onclick = function(event) { 
        if(event.target == forgotModal){ forgotModal.style.display = "none"; }
        if(event.target == registerModal){ registerModal.style.display = "none"; }
    }
</script>

</body>
</html>
