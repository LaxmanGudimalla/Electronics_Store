<%@ page import="java.sql.*,java.util.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<%@ include file="header.jspf" %>

<%
if(session.getAttribute("role") == null || !"user".equals(session.getAttribute("role"))) {
    response.sendRedirect("index.jsp"); return;
}
int userId = (Integer)session.getAttribute("userId");

// Handle Add to Cart
String addPidStr = request.getParameter("add_product");
String addQtyStr = request.getParameter("quantity");
String message = null;

String selCat = request.getParameter("category_id"); // retain selected category

if(addPidStr != null && addQtyStr != null){
    int pid = Integer.parseInt(addPidStr);
    int qty = Integer.parseInt(addQtyStr);

    // Get supplier id
    int supplierId = 0;
    try {
        PreparedStatement ps = conn.prepareStatement("SELECT supplier_id FROM products WHERE id=?");
        ps.setInt(1, pid);
        ResultSet rs = ps.executeQuery();
        if(rs.next()){ supplierId = rs.getInt("supplier_id"); }
    } catch(Exception e){ message = e.getMessage(); }

    // Get or create cart
    Map<Integer, Map<String,Object>> cart = 
        (Map<Integer, Map<String,Object>>)session.getAttribute("cart");
    if(cart==null) cart = new HashMap<>();

    if(cart.containsKey(pid)){
        Map<String,Object> item = cart.get(pid);
        item.put("quantity", (Integer)item.get("quantity") + qty);
    } else {
        Map<String,Object> item = new HashMap<>();
        item.put("productId", pid);
        item.put("quantity", qty);
        item.put("supplierId", supplierId);
        cart.put(pid, item);
    }
    session.setAttribute("cart", cart);
    message = "Product added to cart!";
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Electronics Store - Products</title>
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
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background: rgba(136, 135, 134, 0.78);
            border-radius: 10px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .message {
            text-align: center;
            color: green;
            font-weight: bold;
        }
        .category-select {
            text-align: center;
            margin-bottom: 20px;
        }
        .products {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            justify-content: center;
        }
        .product-card {
            background: #5E92B5;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.2);
            padding: 15px;
            width: 220px;
            text-align: center;
            transition: transform 0.2s;
        }
        .product-card:hover {
            transform: translateY(-5px);
        }
        .product-card b {
            font-size: 1.1em;
        }
        .product-card .price {
            color: #252625;
            font-weight: bold;
            margin: 5px 0;
        }
        .product-card .details {
            font-size: 0.85em;
            color: #555;
        }
        .product-card input[type=number] {
            width: 60px;
            padding: 5px;
            margin: 5px 0;
        }
        .product-card input[type=submit] {
            padding: 5px 10px;
            background: #5cb85c;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .product-card input[type=submit]:hover {
            background: #252625;
        }
        .cart-btn {
            display: block;
            text-align: center;
            margin-top: 30px;
        }
        .cart-btn button {
            padding: 10px 20px;
            font-size: 1em;
            background: #0275d8;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .cart-btn button:hover {
            background: #025aa5;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Order Products</h2>

    <% if(message != null){ %>
        <div class="message"><%=message%></div>
    <% } %>

    <div class="category-select">
        <form method="get">
            <label>Category:</label>
            <select name="category_id" onchange="this.form.submit()">
                <option value="">--Select Category--</option>
                <%
                ResultSet rsCat = conn.createStatement().executeQuery("SELECT * FROM categories");
                Map<Integer,String> categoryMap = new HashMap<>();
                while(rsCat.next()){
                    int cid = rsCat.getInt("id");
                    String cname = rsCat.getString("name");
                    categoryMap.put(cid, cname);
                    String selected = (selCat != null && selCat.equals(""+cid))?"selected":"";
                %>
                    <option value="<%=cid%>" <%=selected%>><%=cname%></option>
                <% } %>
            </select>
        </form>
    </div>

    <div class="products">
        <%
        if(selCat != null && !selCat.isEmpty()){
            int catId = Integer.parseInt(selCat);
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM products WHERE category_id=? AND quantity>0");
            ps.setInt(1, catId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                int pid = rs.getInt("id");
                String pname = rs.getString("name");
                double price = rs.getDouble("price");
                int stock = rs.getInt("quantity");
                Double size = rs.getObject("size_cm") != null ? rs.getDouble("size_cm") : null;
                Double volume = rs.getObject("volume_ml") != null ? rs.getDouble("volume_ml") : null;
                String catName = categoryMap.get(rs.getInt("category_id"));
        %>
            <div class="product-card">
                <b><%=pname%></b>
                <div class="price">Rs. <%=price%></div>
                <div class="details">
                    <% if(size != null){ %>Size: <%=size%> cm<br/><% } %>
                    <% if(volume != null){ %>Volume: <%=volume%> ml<br/><% } %>
                    Category: <%=catName%>
                </div>
                <form method="get">
                    <input type="hidden" name="add_product" value="<%=pid%>"/>
                    <input type="hidden" name="category_id" value="<%=catId%>"/> <!-- retain category -->
                    <input type="number" name="quantity" value="1" min="1"/>
                    <input type="submit" value="Add to Cart"/>
                </form>
            </div>
        <% } } %>
    </div>

    <div class="cart-btn">
        <a href="cart.jsp"><button>Go to Cart</button></a>
    </div>
</div>
</body>
</html>
