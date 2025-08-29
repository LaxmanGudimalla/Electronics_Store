<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<%@ include file="header.jspf" %>

<%
if(session.getAttribute("role") == null || !"supplier".equals(session.getAttribute("role"))) {
    response.sendRedirect("index.jsp"); return;
}
int supplierId = (Integer)session.getAttribute("userId");
%>

<style>
    body {
        font-family: Arial, sans-serif;
        background: url('https://cdn.pixabay.com/photo/2016/12/21/16/34/shopping-cart-1923313_1280.png') no-repeat center center fixed;
        background-size: cover;
        margin: 0;
        padding: 0;
    }
    .container {
        max-width: 1000px;
        margin: 30px auto;
        padding: 20px;
        background: rgba(255,255,255,0.95);
        border-radius: 10px;
    }
    h2 {
        text-align: center;
        color: #333;
    }
    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
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
    .order-header {
        background-color: #5bc0de;
        color: white;
        font-weight: bold;
    }
    .no-orders {
        text-align: center;
        margin-top: 20px;
        font-size: 1.1em;
        color: #d9534f;
    }
</style>

<div class="container">
<h2>Orders Received</h2>

<%
PreparedStatement psOrders = conn.prepareStatement(
    "SELECT o.id AS order_id, o.order_date, u.username AS customer_name, " +
    "p.name AS product_name, od.quantity " +
    "FROM orders o " +
    "JOIN order_details od ON o.id=od.order_id " +
    "JOIN products p ON od.product_id=p.id " +
    "JOIN users u ON o.user_id=u.id " +
    "WHERE od.supplier_id=? " +
    "ORDER BY o.id DESC, od.id ASC"
);
psOrders.setInt(1, supplierId);
ResultSet rsOrders = psOrders.executeQuery();

int currentOrder = -1;
while(rsOrders.next()){
    int orderId = rsOrders.getInt("order_id");
    Timestamp orderDate = rsOrders.getTimestamp("order_date");
    String customer = rsOrders.getString("customer_name");
    String product = rsOrders.getString("product_name");
    int qty = rsOrders.getInt("quantity");

    // New order header
    if(orderId != currentOrder){
        if(currentOrder != -1){
%>
</table><br/>
<%
        }
        currentOrder = orderId;
%>
<table>
<tr class="order-header">
    <td colspan="2"> <%--  Order ID: <%=orderId%> |  --%>Customer: <%=customer%> | Date: <%=orderDate%></td>
</tr>
<tr>
    <th>Product</th>
    <th>Quantity</th>
</tr>
<%
    } // end new order
%>
<tr>
    <td><%=product%></td>
    <td><%=qty%></td>
</tr>
<%
} // end while
if(currentOrder != -1){ %>
</table>
<% } %>

<% if(currentOrder == -1){ %>
<p class="no-orders">No orders received yet.</p>
<% } %>

<%
rsOrders.close();
psOrders.close();
%>
</div>
