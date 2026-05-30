<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | FashionStore</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Outfit', sans-serif;
            background: radial-gradient(circle at top left, #1e1b4b, #0f172a);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #f8fafc;
        }
        .login-container {
            width: 100%;
            max-width: 460px;
            background: rgba(30, 41, 59, 0.6);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 28px;
            padding: 50px 40px;
            box-shadow: 0 30px 60px rgba(0,0,0,0.4);
        }
        .admin-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            padding: 6px 16px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            letter-spacing: 1px;
            text-transform: uppercase;
            margin-bottom: 20px;
        }
        h1 { font-size: 32px; font-weight: 700; margin-bottom: 8px; }
        .subtitle { color: #94a3b8; margin-bottom: 30px; }
        .alert {
            padding: 12px 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-error { background: rgba(239,68,68,0.15); color: #f87171; border: 1px solid rgba(239,68,68,0.2); }
        .alert-success { background: rgba(34,197,94,0.15); color: #4ade80; border: 1px solid rgba(34,197,94,0.2); }
        .form-group { margin-bottom: 20px; }
        .form-group label {
            display: block;
            font-size: 14px;
            color: #94a3b8;
            margin-bottom: 8px;
            font-weight: 400;
        }
        .form-group input {
            width: 100%;
            padding: 14px 18px;
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 14px;
            color: #f8fafc;
            font-size: 16px;
            font-family: inherit;
            transition: 0.3s;
        }
        .form-group input:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 20px rgba(99,102,241,0.2);
        }
        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            border: none;
            border-radius: 14px;
            color: white;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
            box-shadow: 0 10px 25px rgba(99,102,241,0.4);
            margin-top: 10px;
        }
        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(99,102,241,0.5);
        }
        .links {
            text-align: center;
            margin-top: 24px;
            font-size: 14px;
            color: #94a3b8;
        }
        .links a {
            color: #818cf8;
            text-decoration: none;
            font-weight: 600;
        }
        .links a:hover { color: #a78bfa; }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="admin-badge"><i class="fas fa-shield-alt"></i> Admin Portal</div>
        <h1>Admin Login</h1>
        <p class="subtitle">Sign in to manage your store</p>

        <c:if test="${not empty error}">
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
        </c:if>
        <c:if test="${not empty success}">
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> ${success}</div>
        </c:if>

        <form action="admin-login" method="post">
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="admin@fashionstore.com" required>
            </div>
            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="••••••••" required>
            </div>
            <button type="submit" class="btn-login"><i class="fas fa-sign-in-alt"></i> Sign In</button>
        </form>

        <div class="links">
            <p>Don't have an admin account? <a href="admin-register">Create Account</a></p>
            <p style="margin-top: 10px;"><a href="home"><i class="fas fa-arrow-left"></i> Back to Store</a></p>
        </div>
    </div>
</body>
</html>
