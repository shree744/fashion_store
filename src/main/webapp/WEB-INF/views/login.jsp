<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Fashion Store</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #6366f1;
            --secondary: #a855f7;
            --accent: #22d3ee;
            --bg: #0f172a;
            --card-bg: rgba(30, 41, 59, 0.7);
            --text: #f8fafc;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Outfit', sans-serif;
            background: radial-gradient(circle at top right, #1e1b4b, #0f172a);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .auth-card {
            max-width: 480px;
            width: 100%;
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 32px;
            padding: 45px;
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);
            animation: fadeIn 0.6s ease-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .auth-header { text-align: center; margin-bottom: 30px; }
        .auth-header h1 {
            font-size: 32px; font-weight: 700; margin-bottom: 8px;
            background: linear-gradient(to right, #fff, #94a3b8);
            -webkit-background-clip: text; 
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .auth-header p { color: #94a3b8; font-size: 15px; }

        /* TABS */
        .login-tabs {
            display: flex;
            background: rgba(15,23,42,0.5);
            border-radius: 16px;
            padding: 5px;
            margin-bottom: 30px;
            border: 1px solid rgba(255,255,255,0.05);
        }
        .tab-btn {
            flex: 1;
            padding: 14px;
            border: none;
            background: transparent;
            color: #94a3b8;
            font-family: inherit;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            border-radius: 12px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }
        .tab-btn.active {
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            box-shadow: 0 8px 20px rgba(99,102,241,0.35);
        }
        .tab-btn:not(.active):hover {
            background: rgba(255,255,255,0.05);
            color: #cbd5e1;
        }

        /* FORMS */
        .tab-content { display: none; }
        .tab-content.active { display: block; animation: fadeIn 0.4s ease; }

        .form-group { margin-bottom: 22px; }
        .form-group label {
            display: block; font-size: 13px; color: #94a3b8;
            margin-bottom: 8px; font-weight: 500;
        }
        .form-group input {
            width: 100%; padding: 14px 18px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 14px; color: #fff;
            font-size: 15px; font-family: inherit;
            outline: none; transition: 0.3s;
        }
        .form-group input:focus {
            border-color: var(--primary);
            background: rgba(255,255,255,0.08);
            box-shadow: 0 0 15px rgba(99,102,241,0.2);
        }
        .btn-auth {
            width: 100%; padding: 16px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff; border: none; border-radius: 14px;
            font-size: 16px; font-weight: 700; cursor: pointer;
            transition: 0.3s; margin-top: 5px;
            box-shadow: 0 10px 20px rgba(99,102,241,0.3);
        }
        .btn-auth:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 30px rgba(99,102,241,0.45);
            filter: brightness(1.1);
        }
        .btn-admin {
            background: linear-gradient(135deg, #059669, #10b981);
            box-shadow: 0 10px 20px rgba(16,185,129,0.3);
        }
        .btn-admin:hover {
            box-shadow: 0 15px 30px rgba(16,185,129,0.45);
        }

        .error-msg {
            background: rgba(239,68,68,0.1);
            border: 1px solid rgba(239,68,68,0.2);
            color: #fca5a5; padding: 12px;
            border-radius: 12px; font-size: 14px;
            margin-bottom: 20px; text-align: center;
        }
        .success-msg {
            background: rgba(34,197,94,0.1);
            border: 1px solid rgba(34,197,94,0.2);
            color: #4ade80; padding: 12px;
            border-radius: 12px; font-size: 14px;
            margin-bottom: 20px; text-align: center;
        }
        .auth-footer {
            text-align: center; margin-top: 25px;
            font-size: 14px; color: #94a3b8;
        }
        .auth-footer a {
            color: var(--accent); text-decoration: none; font-weight: 600;
        }
        .auth-footer a:hover { color: #67e8f9; }
        .back-link {
            display: block; text-align: center; margin-top: 18px;
            color: #64748b; text-decoration: none; font-size: 13px;
            transition: 0.3s;
        }
        .back-link:hover { color: #94a3b8; }
        .divider {
            display: flex; align-items: center; gap: 15px;
            margin: 20px 0; color: #475569; font-size: 12px;
        }
        .divider::before, .divider::after {
            content: ''; flex: 1; height: 1px;
            background: rgba(255,255,255,0.08);
        }
    </style>
</head>
<body>

<div class="auth-card">
    <div class="auth-header">
        <h1>Welcome Back</h1>
        <p>Sign in to continue to Fashion Store</p>
    </div>

    <!-- LOGIN TABS -->
    <div class="login-tabs">
        <button class="tab-btn active" onclick="switchTab('user')" id="userTabBtn">
            <i class="fas fa-user"></i> Customer
        </button>
        <button class="tab-btn" onclick="switchTab('admin')" id="adminTabBtn">
            <i class="fas fa-shield-alt"></i> Admin
        </button>
    </div>

    <!-- USER LOGIN FORM -->
    <div class="tab-content active" id="userTab">
        <%
            String error = (String) request.getAttribute("error");
            String adminError = (String) request.getAttribute("adminError");
            String success = (String) request.getAttribute("success");
            if (error != null) {
        %>
            <div class="error-msg"><i class="fas fa-exclamation-circle"></i> <%= error %></div>
        <% } %>
        <% if (success != null) { %>
            <div class="success-msg"><i class="fas fa-check-circle"></i> <%= success %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="post">
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="name@example.com" required />
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="••••••••" required />
            </div>
            <button type="submit" class="btn-auth">
                <i class="fas fa-sign-in-alt"></i> Sign In as Customer
            </button>
        </form>

        <div class="auth-footer">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/register">Create Account</a>
        </div>
    </div>

    <!-- ADMIN LOGIN FORM -->
    <div class="tab-content" id="adminTab">
        <% if (adminError != null) { %>
            <div class="error-msg"><i class="fas fa-exclamation-circle"></i> <%= adminError %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/admin-login" method="post">
            <div class="form-group">
                <label>Admin Email</label>
                <input type="email" name="email" placeholder="admin@fashionstore.com" required />
            </div>
            <div class="form-group">
                <label>Admin Password</label>
                <input type="password" name="password" placeholder="••••••••" required />
            </div>
            <button type="submit" class="btn-auth btn-admin">
                <i class="fas fa-shield-alt"></i> Sign In as Admin
            </button>
        </form>

        <div class="divider">Admin Access</div>

        <div class="auth-footer">
            New admin?
            <a href="${pageContext.request.contextPath}/admin-register">Create Admin Account</a>
        </div>
    </div>

    <a href="${pageContext.request.contextPath}/home" class="back-link">
        <i class="fas fa-arrow-left"></i> Back to Home
    </a>
</div>

<script>
    function switchTab(tab) {
        document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(el => el.classList.remove('active'));
        document.getElementById(tab + 'Tab').classList.add('active');
        document.getElementById(tab + 'TabBtn').classList.add('active');
    }
</script>

</body>
</html>
