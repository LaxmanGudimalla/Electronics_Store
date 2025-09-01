<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<%@ include file="header.jspf" %>
<%
if(session.getAttribute("role") == null || !"supplier".equals(session.getAttribute("role"))) { 
    response.sendRedirect("index.jsp"); return; 
}
int supplierId = (Integer)session.getAttribute("userId");

// Handle deletion
String deleteIdStr = request.getParameter("deleteId");
if(deleteIdStr != null){
    int deleteId = Integer.parseInt(deleteIdStr);
    try(PreparedStatement delPs = conn.prepareStatement("DELETE FROM products WHERE id=? AND supplier_id=?")){
        delPs.setInt(1, deleteId);
        delPs.setInt(2, supplierId);
        int r = delPs.executeUpdate();
        if(r>0){ out.println("<p style='color:green;'>Product removed successfully.</p>"); }
        else{ out.println("<p style='color:red;'>Unable to remove product.</p>"); }
    } catch(Exception e){ out.println("<p style='color:red;'>"+e.getMessage()+"</p>"); }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Products</title>
    <style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    position: relative;  /* needed for ::before */
    color: white;        /* for your content */
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
            max-width: 1000px;
            margin: 30px auto;
            background: rgba(136, 135, 134, 0.78);
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.3);
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: center;
        }
        th, td {
            padding: 10px 8px;
            border: 1px solid #ccc;
        }
        th {
            background-color: #0275d8;
            color: white;
        }
        tr:nth-child(even) { background-color: #f2f2f2; }
        tr:hover { background-color: #d9edf7; }
        input[type=submit] {
            padding: 5px 10px;
            background-color: #d9534f;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        input[type=submit]:hover { background-color: #c9302c; }
        a.back-btn {
            display: inline-block;
            margin-top: 15px;
            padding: 10px 20px;
            background-color: #0275d8;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: 0.3s;
        }
        a.back-btn:hover { background-color: #025aa5; }
    </style>
</head>
<body>
<div class="container">
    <h2>My Products</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Category</th>
            <th>Price (Rs.)</th>
            <th>Stock</th>
            <th>Size (cm)</th>
            <th>Remove</th>
        </tr>
        <%
        PreparedStatement ps = conn.prepareStatement(
            "SELECT p.id, p.name, c.name AS cname, p.price, p.quantity, p.size_cm " +
            "FROM products p JOIN categories c ON p.category_id=c.id WHERE p.supplier_id=? ORDER BY p.id DESC"
        );
        ps.setInt(1, supplierId);
        ResultSet rs = ps.executeQuery();
        while(rs.next()){
        %>
        <tr>
            <td><%=rs.getInt("id")%></td>
            <td><%=rs.getString("name")%></td>
            <td><%=rs.getString("cname")%></td>
            <td>Rs. <%=rs.getDouble("price")%></td>
            <td><%=rs.getInt("quantity")%></td>
            <td><%=rs.getString("size_cm")%></td>
            <td>
                <form method="post" action="supplierProducts.jsp" onsubmit="return confirm('Delete this product?');">
                    <input type="hidden" name="deleteId" value="<%=rs.getInt("id")%>"/>
                    <input type="submit" value="Remove"/>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
    <a href="supplierHome.jsp" class="back-btn">Back to Dashboard</a>
</div>
</body>
</html>
