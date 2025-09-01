<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<%@ include file="header.jspf" %>
<%
if(session.getAttribute("role") == null || !"user".equals(session.getAttribute("role"))) {
    response.sendRedirect("index.jsp"); return;
}
int uid = (Integer)session.getAttribute("userId");
%>

<!DOCTYPE html>
<html>
<head>
    <title>My Orders</title>
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
            max-width: 900px;
            margin: 20px auto;
            padding: 20px;
            background: rgba(136, 135, 134, 0.78);
            border-radius: 10px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        table, th, td {
            border: 1px solid #ccc;
        }
        th, td {
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: #0275d8;
            color: white;
        }
        tr:nth-child(even) {background-color: #f2f2f2;}
        tr:hover {background-color: #e6f7ff;}
        .no-orders {
            text-align: center;
            margin-top: 20px;
            font-size: 1.1em;
            color: #d9534f;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>My Orders</h2>
    <%
    PreparedStatement ps = conn.prepareStatement(
      "SELECT o.id, o.order_date, u.username AS sname, p.name AS pname, od.quantity, od.price " +
      "FROM orders o " +
      "JOIN order_details od ON o.id = od.order_id " +
      "JOIN products p ON od.product_id = p.id " +
      "JOIN users u ON od.supplier_id = u.id " +
      "WHERE o.user_id=? " +
      "ORDER BY o.order_date DESC"
    );
    ps.setInt(1, uid);
    ResultSet rs = ps.executeQuery();
    boolean hasOrders = false;
    %>

    <table>
        <tr>
            <th>Order ID</th>
            <th>Date</th>
            <th>Supplier</th>
            <th>Product</th>
            <th>Quantity</th>
            <th>Price (Rs.)</th>
            <th>Total (Rs.)</th>
        </tr>
        <%
        while(rs.next()){
            hasOrders = true;
            int orderId = rs.getInt("id");
            Timestamp date = rs.getTimestamp("order_date");
            String supplier = rs.getString("sname");
            String product = rs.getString("pname");
            int qty = rs.getInt("quantity");
            double price = rs.getDouble("price");
            double total = price * qty;
        %>
        <tr>
            <td><%=orderId%></td>
            <td><%=date%></td>
            <td><%=supplier%></td>
            <td><%=product%></td>
            <td><%=qty%></td>
            <td><%=price%></td>
            <td><%=total%></td>
        </tr>
        <% } %>
    </table>

    <% if(!hasOrders){ %>
        <div class="no-orders">You have no orders yet.</div>
    <% } %>
</div>
</body>
</html>
