<%@ page import="java.sql.*" %>
<%@ include file="WEB-INF/db.jsp" %>
<%@ include file="header.jspf" %>
<%
if(session.getAttribute("role") == null || !"admin".equals(session.getAttribute("role"))) { 
    response.sendRedirect("index.jsp"); return; 
}

// Handle soft deletion
String deleteUserIdStr = request.getParameter("deleteUserId");
if(deleteUserIdStr != null){
    int deleteUserId = Integer.parseInt(deleteUserIdStr);
    if(deleteUserId != 1){ // Optional: prevent deactivating admin with id=1
        try(PreparedStatement ps = conn.prepareStatement("UPDATE users SET status=0 WHERE id=?")){
            ps.setInt(1, deleteUserId);
            ps.executeUpdate();
        } catch(Exception e){
            out.println("<p style='color:red'>Error deactivating user: " + e.getMessage() + "</p>");
        }
    } else {
        out.println("<p style='color:red'>Cannot deactivate admin user.</p>");
    }
}
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Users & Suppliers</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
body {
    margin: 0;
    font-family: Arial, sans-serif;
    position: relative;
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
    filter: blur(5px);
    z-index: -1;
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
    margin: 50px auto;
    background: rgba(136, 135, 134, 0.78);
    padding: 30px 25px;
    border-radius: 12px;
    box-shadow: 0 0 20px rgba(0,0,0,0.3);
}

h2 { color: #0275d8; margin-bottom: 20px; }

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

input[type=submit] {
    padding: 6px 12px;
    border: none;
    border-radius: 6px;
    background-color: #d9534f;
    color: white;
    cursor: pointer;
    transition: 0.3s;
}

input[type=submit]:hover {
    background-color: #c9302c;
}

#pagination {
    margin-top: 20px;
    text-align: center;
}

.page-btn {
    padding: 5px 10px;
    margin: 0 3px;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    background: #0275d8;
    color: white;
}

.page-btn.active {
    background: #025aa5;
}

#searchInput {
    width: 100%;
    padding: 8px;
    margin-bottom: 15px;
    border-radius: 6px;
    border: 1px solid #ccc;
}

.alert { margin-top: 10px; color: red; }
    </style>
</head>
<body>

<%--     <!-- Navbar added -->
    <div class="navbar">
        <a href="adminDashboard.jsp">Dashboard</a>
        <a href="manageCategories.jsp">Manage Categories</a>
        <a href="manageUsers.jsp">Manage Users</a>
        <a href="resetPasswords.jsp">Reset Passwords</a>
        <a href="setLimits.jsp">Set Limits</a>
        <a href="logout.jsp">Logout</a>
    </div>
    
--%>

<div class="container">
    <h2>All Users & Suppliers</h2>

    <!-- Search bar -->
    <input type="text" id="searchInput" placeholder="Search users...">

    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Username</th>
            <th>Role</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
        try(Statement st = conn.createStatement(); 
            ResultSet rs = st.executeQuery("SELECT id, username, role FROM users WHERE status=1 ORDER BY id")) {
            while(rs.next()){
                int uid = rs.getInt("id");
                String uname = rs.getString("username");
                String role = rs.getString("role");
        %>
        <tr>
            <td><%=uid%></td>
            <td><%=uname%></td>
            <td><%=role%></td>
            <td>
                <% if(!"admin".equals(role)){ %>
                    <form method="get" style="margin:0;">
                        <input type="hidden" name="deleteUserId" value="<%=uid%>"/>
                        <input type="submit" value="Delete"/>
                    </form>
                <% } %>
            </td>
        </tr>
        <% }} %>
        </tbody>
    </table>

    <div id="pagination"></div>
</div>

<script>
$(document).ready(function() {
    var rowsPerPage = 5;
    var $rows = $('table tbody tr');
    var filteredRows = $rows; // start with all rows

    function showPage(page, rows) {
        var start = (page - 1) * rowsPerPage;
        var end = start + rowsPerPage;
        rows.hide().slice(start, end).show();  //shows only the rows for the selected page.
    }

    function updatePagination(rows) {
        $('#pagination').empty();
        var totalPages = Math.ceil(rows.length / rowsPerPage);
        if (totalPages === 0) return;
        for (var i = 1; i <= totalPages; i++) {
            $('#pagination').append('<button class="page-btn" data-page="' + i + '">' + i + '</button>');
        }
        $('#pagination .page-btn').first().addClass('active');
    }		//Dynamically creates pagination buttons based on number of rows.

    // initial display
    showPage(1, filteredRows);
    updatePagination(filteredRows);

    // page click
    $('#pagination').on('click', '.page-btn', function() {
        var page = $(this).data('page');
        showPage(page, filteredRows);
        $('.page-btn').removeClass('active');
        $(this).addClass('active');
    });			//Highlights the active button and shows only that pages rows.

    // search functionality
    $('#searchInput').on('keyup', function() {
        var value = $(this).val().toLowerCase();
        filteredRows = $rows.filter(function() {
            return $(this).text().toLowerCase().indexOf(value) > -1;
        });				//keeps only rows that contain the search text.
        $rows.hide();
        showPage(1, filteredRows);
        updatePagination(filteredRows);
    });
});
</script>

</body>
</html>
