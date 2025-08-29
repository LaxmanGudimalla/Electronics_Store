<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<%@ include file="header.jspf" %>
<%
if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) {
    response.sendRedirect("index.jsp"); return;
}

String action = request.getParameter("action");
if("add".equals(action)){
    String name = request.getParameter("name");
    try(PreparedStatement ps = conn.prepareStatement("INSERT INTO categories(name) VALUES(?)")){
        ps.setString(1, name);
        ps.executeUpdate();
        out.println("<p style='color:green'>Category added.</p>");
    } catch(Exception e){ out.println("<p class='alert'>"+e.getMessage()+"</p>"); }
} else if("delete".equals(action)){
    int id = Integer.parseInt(request.getParameter("id"));
    try(PreparedStatement ps = conn.prepareStatement("DELETE FROM categories WHERE id=?")){
        ps.setInt(1, id);
        ps.executeUpdate();
        out.println("<p style='color:green'>Category deleted.</p>");
    } catch(Exception e){ out.println("<p class='alert'>"+e.getMessage()+"</p>"); }
} else if("update".equals(action)){
    int id = Integer.parseInt(request.getParameter("id"));
    String name = request.getParameter("name");
    try(PreparedStatement ps = conn.prepareStatement("UPDATE categories SET name=? WHERE id=?")){
        ps.setString(1, name);
        ps.setInt(2, id);
        ps.executeUpdate();
        out.println("<p style='color:green'>Category updated.</p>");
    } catch(Exception e){ out.println("<p class='alert'>"+e.getMessage()+"</p>"); }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Categories</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: url('https://cdn.pixabay.com/photo/2016/12/21/16/34/shopping-cart-1923313_1280.png') no-repeat center center fixed;
            background-size: cover;
            color: #333;
        }

        .container {
            max-width: 800px;
            margin: 50px auto;
            background: rgba(255,255,255,0.95);
            padding: 30px 25px;
            border-radius: 12px;
            box-shadow: 0 0 20px rgba(0,0,0,0.3);
        }

        h2 { color: #0275d8; margin-bottom: 20px; }
        h3 { color: #333; margin-top: 25px; }

        input[type=text], input[type=submit] {
            padding: 8px 12px;
            margin: 5px 0;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 14px;
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

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }

        th, td {
            border: 1px solid #ccc;
            padding: 10px 8px;
            text-align: center;
        }

        th {
            background-color: #0275d8;
            color: white;
        }

        td form { display: inline; }

        .alert { color: red; }
    </style>
</head>
<body>
<div class="container">
    <h2>Manage Categories</h2>

    <h3>Add New Category</h3>
    <form method="post">
        <input type="hidden" name="action" value="add">
        <input type="text" name="name" placeholder="Category name" required>
        <input type="submit" value="Add">
    </form>

    <h3>Existing Categories</h3>
    <table>
        <tr><th>ID</th><th>Name</th><th>Actions</th></tr>
    <%
    try (Statement st = conn.createStatement();
         ResultSet rs = st.executeQuery("SELECT * FROM categories ORDER BY id")) {
        while(rs.next()){
    %>
    <tr>
        <td><%=rs.getInt("id")%></td>
        <td>
            <form method="post">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%=rs.getInt("id")%>">
                <input type="text" name="name" value="<%=rs.getString("name")%>" required>
                <input type="submit" value="Save">
            </form>
        </td>
        <td>
            <form method="post" onsubmit="return confirm('Delete this category?')">
                <input type="hidden" name="action" value="delete">
                <input type="hidden" name="id" value="<%=rs.getInt("id")%>">
                <input type="submit" value="Delete">
            </form>
        </td>
    </tr>
    <% }} %>
    </table>
</div>
</body>
</html>
