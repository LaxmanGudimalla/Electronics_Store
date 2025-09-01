<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<%@ include file="header.jspf" %>
<%
if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) { 
    response.sendRedirect("index.jsp"); return; 
}

String action = request.getParameter("action");
if("save".equals(action)){
    String vol = request.getParameter("max_volume_ml");
    String size = request.getParameter("max_size_cm");

    try(PreparedStatement ps = conn.prepareStatement(
        "UPDATE product_limits SET max_volume_ml=?, max_size_cm=? WHERE id=1")){
        if(vol==null || vol.isEmpty()) ps.setNull(1, java.sql.Types.DECIMAL); 
        else ps.setDouble(1, Double.parseDouble(vol));
        if(size==null || size.isEmpty()) ps.setNull(2, java.sql.Types.DECIMAL); 
        else ps.setDouble(2, Double.parseDouble(size));
        ps.executeUpdate();
        out.println("<p style='color:green'>Limits saved successfully.</p>");
    } catch(Exception e){ out.println("<p class='alert'>"+e.getMessage()+"</p>"); }
}

Double curVol=null, curSize=null;
try(Statement st = conn.createStatement(); ResultSet rs = st.executeQuery("SELECT max_volume_ml, max_size_cm FROM product_limits WHERE id=1")){
    if(rs.next()){
        curVol = (Double) rs.getObject("max_volume_ml");
        curSize = (Double) rs.getObject("max_size_cm");
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Set Product Measurement Limits</title>
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
            background: rgba(136, 135, 134, 0.78);
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
        input[type=number], input[type=submit] {
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
    <h2>Set Product Measurement Limits</h2>
    <form method="post">
        <input type="hidden" name="action" value="save">

        <%-- <label>Max Volume (ml)</label>
        <input type="number" step="0.01" name="max_volume_ml" value="<%= (curVol==null? "" : curVol.toString()) %>"> --%>

        <label>Max Size (cm)</label>
        <input type="number" step="0.01" name="max_size_cm" value="<%= (curSize==null? "" : curSize.toString()) %>">

        <input type="submit" value="Save Limits">
    </form>
</div>
</body>
</html>
