<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<%@ include file="header.jspf" %>
<%
if(session.getAttribute("role") == null || !"supplier".equals(session.getAttribute("role"))) {
    response.sendRedirect("index.jsp"); return;
}
int supplierId = (Integer)session.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Supplier Dashboard</title>
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
            max-width: 900px;
            margin: 30px auto;
            background: rgba(136, 135, 134, 0.78);
            padding: 20px 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.3);
        }
        h2, h3 {
            color: #333;
            text-align: center;
        }
        p.links {
            text-align: center;
            margin-bottom: 30px;
        }
        p.links a {
            margin: 0 15px;
            text-decoration: none;
            background-color: #0275d8;
            color: white;
            padding: 8px 15px;
            border-radius: 5px;
            transition: 0.3s;
        }
        p.links a:hover {
            background-color: #025aa5;
        }
        form {
            margin-bottom: 30px;
        }
        label {
            font-weight: bold;
            display: block;
            margin-top: 10px;
        }
        input[type=text], input[type=number], select {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
            border-radius: 5px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        input[type=submit] {
            width: 100%;
            padding: 10px;
            margin-top: 15px;
            background-color: #0275d8;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
        }
        input[type=submit]:hover {
            background-color: #025aa5;
        }
        .alert {
            text-align: center;
            margin-top: 10px;
            padding: 10px;
            border-radius: 5px;
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Supplier Dashboard</h2>
    <p class="links">
        <a href="supplierProducts.jsp">View My Products</a> | 
        <a href="supplierOrders.jsp">View Orders</a>
    </p>

    <!-- Add New Product -->
    <h3>Add New Product</h3>
    <form method="post">
        <input type="hidden" name="action" value="add"/>
        <label>Product Name</label>
        <input type="text" name="name" required/>

        <label>Category</label>
        <select name="category_id" required>
            <option value="">--Select Category--</option>
            <%
            ResultSet rsCat = conn.createStatement().executeQuery("SELECT * FROM categories");
            while(rsCat.next()){
            %>
            <option value="<%=rsCat.getInt("id")%>"><%=rsCat.getString("name")%></option>
            <% } %>
        </select>

        <label>Price (rs.)</label>
        <input type="number" step="0.01" name="price" required/>

        <label>Quantity</label>
        <input type="number" name="quantity" min="1" value="1" required/>

 <%-- <label>Volume (ml) - optional</label>
        <input type="number" step="0.01" name="volume_ml"/> --%>       

        <label>Size (cm) - optional</label>
        <input type="number" step="0.01" name="size_cm"/>

        <input type="submit" value="Add Product"/>
    </form>

    <!-- Update Stock -->
    <h3>Update My Product Stock</h3>
    <form method="post">
        <input type="hidden" name="action" value="update"/>
        <label>Select Product</label>
        <select name="product_id" required>
            <option value="">--Select Product--</option>
            <%
            PreparedStatement psMy = conn.prepareStatement(
                "SELECT p.id, p.name, c.name AS category_name, p.quantity " +
                "FROM products p JOIN categories c ON p.category_id=c.id WHERE p.supplier_id=?");
            psMy.setInt(1, supplierId);
            ResultSet rsProd = psMy.executeQuery();
            while(rsProd.next()){
            %>
            <option value="<%=rsProd.getInt("id")%>"><%=rsProd.getString("name")%> (Category: <%=rsProd.getString("category_name")%>, Stock: <%=rsProd.getInt("quantity")%>)</option>
            <% } %>
        </select>

        <label>Increment Quantity</label>
        <input type="number" name="quantity" min="1" value="1"/>
        <input type="submit" value="Update Stock"/>
    </form>

    <!-- Delete Product -->
    <h3>Delete Product</h3>
    <form method="post">
        <input type="hidden" name="action" value="delete"/>
        <label>Select Product</label>
        <select name="product_id" required>
            <option value="">--Select Product--</option>
            <%
            psMy.setInt(1, supplierId);
            rsProd = psMy.executeQuery();
            while(rsProd.next()){
            %>
            <option value="<%=rsProd.getInt("id")%>"><%=rsProd.getString("name")%></option>
            <% } %>
        </select>
        <input type="submit" value="Delete Product" onclick="return confirm('Are you sure you want to delete this product?');"/>
    </form>

<%
String action = request.getParameter("action");
if(action != null){
    if("add".equals(action)){
        String name = request.getParameter("name");
        int cid = Integer.parseInt(request.getParameter("category_id"));
        double price = Double.parseDouble(request.getParameter("price"));
        int qty = Integer.parseInt(request.getParameter("quantity"));
        String volStr = request.getParameter("volume_ml");
        String sizeStr = request.getParameter("size_cm");

        // Check limits
        Double limVol = null, limSize = null;
        try (Statement s = conn.createStatement()) {
            ResultSet rsl = s.executeQuery("SELECT max_volume_ml, max_size_cm FROM product_limits WHERE id=1");
            if(rsl.next()){
            	limVol = (rsl.getBigDecimal("max_volume_ml") != null) ? rsl.getBigDecimal("max_volume_ml").doubleValue() : null;
            	limSize = (rsl.getBigDecimal("max_size_cm") != null) ? rsl.getBigDecimal("max_size_cm").doubleValue() : null;

            }
        }

        Double v = (volStr==null || volStr.isEmpty()) ? null : Double.valueOf(volStr);
        Double sz = (sizeStr==null || sizeStr.isEmpty()) ? null : Double.valueOf(sizeStr);

        if(limVol != null && v != null && v > limVol){
            out.println("<div class='alert alert-error'>Volume exceeds admin limit ("+limVol+" ml)</div>");
        } else if(limSize != null && sz != null && sz > limSize){
            out.println("<div class='alert alert-error'>Size exceeds admin limit ("+limSize+" cm)</div>");
        } else {
            try{
                PreparedStatement ps = conn.prepareStatement(
                    "INSERT INTO products(name, category_id, price, quantity, supplier_id, volume_ml, size_cm) VALUES(?,?,?,?,?,?,?)"
                );
                ps.setString(1,name);
                ps.setInt(2,cid);
                ps.setDouble(3,price);
                ps.setInt(4,qty);
                ps.setInt(5,supplierId);
                if(v==null) ps.setNull(6, java.sql.Types.DECIMAL); else ps.setDouble(6, v);
                if(sz==null) ps.setNull(7, java.sql.Types.DECIMAL); else ps.setDouble(7, sz);
                ps.executeUpdate();
                out.println("<div class='alert alert-success'>Product added successfully!</div>");
            } catch(Exception e){
                out.println("<div class='alert alert-error'>Error: " + e.getMessage() + "</div>");
            }
        }
    } else if("update".equals(action)){
        int pid = Integer.parseInt(request.getParameter("product_id"));
        int qinc = Integer.parseInt(request.getParameter("quantity"));
        try{
            PreparedStatement ps = conn.prepareStatement(
                "UPDATE products SET quantity = quantity + ? WHERE id=? AND supplier_id=?"
            );
            ps.setInt(1, qinc);
            ps.setInt(2, pid);
            ps.setInt(3, supplierId);
            int rows = ps.executeUpdate();
            if(rows>0) out.println("<div class='alert alert-success'>Stock updated successfully!</div>");
            else out.println("<div class='alert alert-error'>Invalid product selection.</div>");
        } catch(Exception e){
            out.println("<div class='alert alert-error'>Error: " + e.getMessage() + "</div>");
        }
    } else if("delete".equals(action)){
        int pid = Integer.parseInt(request.getParameter("product_id"));
        try{
            PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM products WHERE id=? AND supplier_id=?"
            );
            ps.setInt(1, pid);
            ps.setInt(2, supplierId);
            int rows = ps.executeUpdate();
            if(rows>0) out.println("<div class='alert alert-success'>Product deleted successfully!</div>");
            else out.println("<div class='alert alert-error'>Invalid product selection.</div>");
        } catch(Exception e){
            out.println("<div class='alert alert-error'>Error: " + e.getMessage() + "</div>");
        }
    }
}
%>
</div>
</body>
</html>
