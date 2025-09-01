<%@ page import="java.sql.*,java.util.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<%@ include file="header.jspf" %>
<%
if(session.getAttribute("role")==null || !"user".equals(session.getAttribute("role"))){
    response.sendRedirect("index.jsp"); return;
}

int userId = (Integer)session.getAttribute("userId");
Map<Integer, Map<String,Object>> cart = 
    (Map<Integer, Map<String,Object>>)session.getAttribute("cart");
if(cart==null) cart = new HashMap<>();

// Handle quantity update
String updatePid = request.getParameter("update_product");
String updateQty = request.getParameter("quantity");
if(updatePid != null && updateQty != null){
    int pid = Integer.parseInt(updatePid);
    int qty = Integer.parseInt(updateQty);
    if(cart.containsKey(pid)){
        cart.get(pid).put("quantity", qty);
    }
    session.setAttribute("cart", cart);
}

// Handle remove product
String removePid = request.getParameter("remove_product");
if(removePid != null){
    int pid = Integer.parseInt(removePid);
    cart.remove(pid);
    session.setAttribute("cart", cart);
}

// Handle place order
if("place".equals(request.getParameter("action")) && !cart.isEmpty()){
    try{
        conn.setAutoCommit(false);
        PreparedStatement psOrder = conn.prepareStatement(
            "INSERT INTO orders(user_id) VALUES(?)", Statement.RETURN_GENERATED_KEYS);
        psOrder.setInt(1, userId);
        psOrder.executeUpdate();
        ResultSet rs = psOrder.getGeneratedKeys();
        int orderId = 0;
        if(rs.next()){ orderId = rs.getInt(1); }

        PreparedStatement psDetail = conn.prepareStatement(
            "INSERT INTO order_details(order_id, product_id, supplier_id, quantity, price) VALUES(?,?,?,?,?)");
        PreparedStatement psStock = conn.prepareStatement(
            "UPDATE products SET quantity = quantity - ? WHERE id=? AND quantity >= ?");

        for(Map<String,Object> item : cart.values()){
            int pid = (Integer)item.get("productId");
            int qty = (Integer)item.get("quantity");
            int supplierId = (Integer)item.get("supplierId");

            // get current price
            PreparedStatement psPrice = conn.prepareStatement(
                "SELECT price FROM products WHERE id=?");
            psPrice.setInt(1, pid);
            ResultSet rsPrice = psPrice.executeQuery();
            double price = 0;
            if(rsPrice.next()) price = rsPrice.getDouble("price");

            psDetail.setInt(1, orderId);
            psDetail.setInt(2, pid);
            psDetail.setInt(3, supplierId);
            psDetail.setInt(4, qty);
            psDetail.setDouble(5, price);
            psDetail.executeUpdate();

            psStock.setInt(1, qty);
            psStock.setInt(2, pid);
            psStock.setInt(3, qty);
            psStock.executeUpdate();
        }

        conn.commit();
        cart.clear();
        session.setAttribute("cart", cart);
        out.println("<p style='color:green'>Order placed successfully!</p>");
    } catch(Exception e){
        conn.rollback();
        out.println("<p class='alert'>Error placing order: "+e.getMessage()+"</p>");
    } finally {
        conn.setAutoCommit(true);
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Cart - Electronics Store</title>
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
        .container{
            max-width: 900px;
            margin: 20px auto;
            padding:20px;
            background: rgba(255,255,255,0.95);
            border-radius:10px;
        }
        h2{text-align:center;color:#333;}
        table{
            width:100%;
            border-collapse: collapse;
            margin-top:20px;
        }
        table, th, td{border:1px solid #ccc;}
        th, td{padding:10px;text-align:center;}
        input[type=number]{width:60px;padding:5px;}
        input[type=submit]{padding:5px 10px;border:none;border-radius:5px;cursor:pointer;}
        .update-btn{background:#5cb85c;color:white;}
        .update-btn:hover{background:#4cae4c;}
        .remove-btn{background:#d9534f;color:white;}
        .remove-btn:hover{background:#c9302c;}
        .place-btn{margin-top:20px;background:#0275d8;color:white;width:100%;padding:10px;font-size:1.1em;}
        .place-btn:hover{background:#025aa5;}
    </style>
</head>
<body>
<div class="container">
    <h2>My Cart</h2>
    <% if(cart.isEmpty()){ %>
        <p>Your cart is empty.</p>
    <% } else { %>
    <table>
        <tr><th>Product</th><th>Quantity</th><th>Price</th><th>Total</th><th>Actions</th></tr>
        <%
        double grandTotal = 0;
        for(Map<String,Object> item : cart.values()){
            int pid = (Integer)item.get("productId");
            int qty = (Integer)item.get("quantity");
            int supplierId = (Integer)item.get("supplierId");
            // get product info
            PreparedStatement psProd = conn.prepareStatement("SELECT name, price FROM products WHERE id=?");
            psProd.setInt(1, pid);
            ResultSet rsProd = psProd.executeQuery();
            String pname=""; double price=0;
            if(rsProd.next()){ pname=rsProd.getString("name"); price=rsProd.getDouble("price"); }
            double total = price*qty; grandTotal+=total;
        %>
        <tr>
            <td><%=pname%></td>
            <td>
                <form method="get" style="display:inline">
                    <input type="hidden" name="update_product" value="<%=pid%>"/>
                    <input type="number" name="quantity" value="<%=qty%>" min="1"/>
                    <input type="submit" class="update-btn" value="Update"/>
                </form>
            </td>
            <td>Rs.<%=price%></td>
            <td>Rs.<%=total%></td>
            <td>
                <form method="get" style="display:inline">
                    <input type="hidden" name="remove_product" value="<%=pid%>"/>
                    <input type="submit" class="remove-btn" value="Remove"/>
                </form>
            </td>
        </tr>
        <% } %>
        <tr>
            <td colspan="3"><b>Grand Total</b></td>
            <td colspan="2"><b>Rs.<%=grandTotal%></b></td>
        </tr>
    </table>
    <form method="get">
        <input type="hidden" name="action" value="place"/>
        <input type="submit" class="place-btn" value="Place Order"/>
    </form>
    <% } %>
</div>
</body>
</html>
