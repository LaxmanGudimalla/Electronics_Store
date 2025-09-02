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
        body { margin:0; font-family:Arial,sans-serif; position:relative; }
        body::before {
            content:""; position:fixed; top:0; left:0; width:100%; height:100%;
            background:url('https://cdn.pixabay.com/photo/2016/12/21/16/34/shopping-cart-1923313_1280.png') no-repeat center center fixed;
            background-size:cover; filter:blur(5px); z-index:-1;
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
        
        .container { max-width:800px; margin:100px auto 50px auto; background:rgba(136,135,134,0.78); padding:30px 25px; border-radius:12px; box-shadow:0 0 20px rgba(0,0,0,0.3); }
        h2 { color:#0275d8; margin-bottom:20px; text-align:center; }
        table { width:100%; border-collapse:collapse; margin-top:20px; }
        th, td { border:1px solid #ccc; padding:10px 8px; text-align:center; }
        th { background-color:#0275d8; color:white; }
        .alert { color:red; }

        /* Buttons */
        button, input[type=submit] {
            padding:5px 10px;
            font-size:13px;
            line-height:1.4;
            border:none;
            border-radius:6px;
            cursor:pointer;
            transition:0.3s;
            display:inline-block;
            vertical-align:middle;
        }
        button { background-color:#0275d8; color:white; height:30px; margin-right:5px; }
        button:hover { background-color:#025aa5; }

        input[type=submit] {
            background-color:red;
            color:white;
        }
        input[type=submit]:hover {
            background-color:darkred;
        }

        /* Add form */
        form.add-form { display:flex; gap:5px; align-items:center; margin-bottom:20px; }
        form.add-form input[type=text] { flex:1; padding:5px 8px; border-radius:6px; border:1px solid #ccc; font-size:13px; }

        /* Modal */
        .modal { display:none; position:fixed; z-index:1000; left:0; top:0; width:100%; height:100%; overflow:auto; background-color:rgba(0,0,0,0.5); }
        .modal-content { background-color:#fefefe; margin:15% auto; padding:20px; border-radius:12px; width:300px; position:relative; }
        .close { color:#aaa; position:absolute; top:10px; right:15px; font-size:28px; font-weight:bold; cursor:pointer; }
        .close:hover { color:black; }
        .modal-content input[type=text], .modal-content input[type=submit] { width:100%; margin-top:10px; }
    </style>
</head>
<body>

<!--  Navbar already included via header.jspf -->

<div class="container">
    <h2>Manage Categories</h2>

    <!-- Add Category -->
    <h3>Add New Category</h3>
    <form method="post" class="add-form">
        <input type="hidden" name="action" value="add">
        <input type="text" name="name" placeholder="Category name" required>
        <input type="submit" value="Add">
    </form>

    <!-- Existing Categories -->
    <h3>Existing Categories</h3>
    <table>
        <tr><th>ID</th><th>Name</th><th>Actions</th></tr>
        <%
        try (Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery("SELECT * FROM categories ORDER BY id")) {
            while(rs.next()){
        %>
        <tr id="row-<%=rs.getInt("id")%>">
            <td><%=rs.getInt("id")%></td>
            <td id="name-<%=rs.getInt("id")%>"><%=rs.getString("name")%></td>
            <td>
                <!-- Edit + Delete buttons side by side -->
                <button onclick="openEditModal(<%=rs.getInt("id")%>, '<%=rs.getString("name").replace("'", "\\'")%>')">Edit</button>
                <form method="post" style="display:inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="id" value="<%=rs.getInt("id")%>">
                    <input type="submit" value="Delete" onclick="return confirm('Delete this category?')">
                </form>
            </td>
        </tr>
        <% }} %>
    </table>
</div>

<!-- Edit Modal -->
<div id="editModal" class="modal">
    <div class="modal-content">
        <span class="close" onclick="closeEditModal()">&times;</span>
        <h3>Edit Category</h3>
        <form id="editForm" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" id="edit-id">
            <input type="text" name="name" id="edit-name" required>
            <input type="submit" value="Save Changes">
        </form>
    </div>
</div>

<script>
function openEditModal(id, name){
    document.getElementById('edit-id').value = id;
    document.getElementById('edit-name').value = name;
    document.getElementById('editModal').style.display = 'block';
}
function closeEditModal(){
    document.getElementById('editModal').style.display = 'none';
}
// Close modal if user clicks outside
window.onclick = function(event) {
    if(event.target == document.getElementById('editModal')){
        closeEditModal();
    }
}
</script>
</body>
</html>
