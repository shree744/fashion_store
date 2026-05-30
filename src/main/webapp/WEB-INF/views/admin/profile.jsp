<%@ page import="com.fashionstore.model.Admin" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%!
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;").replace("'", "&#39;");
    }
%>
<%
    Admin admin = (Admin) session.getAttribute("admin");
    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/admin-login");
        return;
    }
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Profile - Fashion Store</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        * { box-sizing: border-box; }
        :root { --primary: #6366f1; --secondary: #a855f7; --bg: #0f172a; --card-bg: rgba(30, 41, 59, 0.7); --text: #f8fafc; }
        body { font-family: 'Outfit', sans-serif; background: radial-gradient(circle at top right, #1e1b4b, #0f172a); color: var(--text); margin: 0; display: flex; min-height: 100vh; }
        
        .main-content { flex: 1; padding: 2.5rem 3.5rem; margin-left: 280px; max-width: calc(100vw - 280px - 4rem); }
        h1 { font-size: 2.25rem; font-weight: 700; margin-bottom: 0.5rem; letter-spacing: -0.025em; }
        
        .admin-profile-card { max-width: 800px; padding: 2.5rem; background: var(--card-bg); backdrop-filter: blur(20px); border: 1px solid rgba(255,255,255,0.1); border-radius: 24px; margin-top: 2rem; }
        .form-group { margin-bottom: 20px; }
        label { display: block; margin-bottom: 8px; color: #94a3b8; font-weight: 600; font-size: 0.9rem; }
        input { width: 100%; padding: 12px 18px; border-radius: 14px; background: rgba(15, 23, 42, 0.5); border: 1px solid rgba(255,255,255,0.1); color: #f8fafc; transition: 0.3s; }
        input:focus { outline: none; border-color: var(--primary); background: rgba(15, 23, 42, 0.8); }
        .btn-primary { padding: 14px 28px; background: linear-gradient(135deg, var(--primary), var(--secondary)); border: none; border-radius: 14px; color: #fff; font-weight: 700; cursor: pointer; transition: 0.3s; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(99, 102, 241, 0.4); }
        .alert { padding: 14px 20px; border-radius: 14px; margin-bottom: 24px; border: 1px solid transparent; }
        .alert-success { background: rgba(16, 185, 129, 0.1); border-color: rgba(16, 185, 129, 0.2); color: #34d399; }
        .alert-error { background: rgba(239, 68, 68, 0.1); border-color: rgba(239, 68, 68, 0.2); color: #fca5a5; }
    </style>
</head>
<body>
    <jsp:include page="partials/sidebar.jsp">
        <jsp:param name="activePage" value="profile" />
    </jsp:include>

    <div class="main-content">
        <h1>Admin Profile</h1>
        <p style="color: #94a3b8; margin-bottom: 2rem;">Manage your administrative account settings and display name.</p>

        <div class="admin-profile-card">

        <c:if test="${not empty message}">
            <div class="alert alert-success"><%= esc(message) %></div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error"><%= esc(error) %></div>
        </c:if>

        <form action="${pageContext.request.contextPath}/admin-profile" method="post">

            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" value="<%= esc(admin.getFullName()) %>" required />
            </div>
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" value="<%= esc(admin.getEmail()) %>" readonly />
            </div>
            <button type="submit" class="btn-primary" style="width: 100%;">Save Profile Changes</button>
        </form>


        </div>
    </div>
</body>
</html>
