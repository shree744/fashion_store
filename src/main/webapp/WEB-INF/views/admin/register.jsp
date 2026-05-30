<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Register | FashionStore</title>
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
        .register-container {
            width: 100%;
            max-width: 500px;
            background: rgba(30, 41, 59, 0.6);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 28px;
            padding: 45px 40px;
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
        h1 { font-size: 28px; font-weight: 700; margin-bottom: 8px; }
        .subtitle { color: #94a3b8; margin-bottom: 25px; }
        .alert-error {
            padding: 12px 18px;
            border-radius: 12px;
            margin-bottom: 20px;
            font-size: 14px;
            background: rgba(239,68,68,0.15);
            color: #f87171;
            border: 1px solid rgba(239,68,68,0.2);
        }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .form-group { margin-bottom: 18px; }
        .form-group label {
            display: block;
            font-size: 13px;
            color: #94a3b8;
            margin-bottom: 6px;
        }
        .form-group input {
            width: 100%;
            padding: 13px 16px;
            background: rgba(15, 23, 42, 0.6);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            color: #f8fafc;
            font-size: 15px;
            font-family: inherit;
            transition: 0.3s;
        }
        .form-group input:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 20px rgba(99,102,241,0.2);
        }
        .btn-register {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            border: none;
            border-radius: 14px;
            color: white;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
            box-shadow: 0 10px 25px rgba(99,102,241,0.4);
            margin-top: 5px;
        }
        .btn-register:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(99,102,241,0.5);
        }
        .links {
            text-align: center;
            margin-top: 20px;
            font-size: 14px;
            color: #94a3b8;
        }
        .links a { color: #818cf8; text-decoration: none; font-weight: 600; }
        .links a:hover { color: #a78bfa; }
    </style>
</head>
<body>
    <div class="register-container">
        <div class="admin-badge"><i class="fas fa-user-shield"></i> Admin Portal</div>
        <h1>Create Admin Account</h1>
        <p class="subtitle">Register a new administrator</p>

        <c:if test="${not empty error}">
            <div class="alert-error"><i class="fas fa-exclamation-circle"></i> ${error}</div>
        </c:if>

        <form action="admin-register" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" placeholder="John Doe" required>
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="tel" name="phone" placeholder="+91 98765 43210" required>
                </div>
            </div>
            <div class="form-group">
                <label>Email Address</label>
                <input type="email" name="email" placeholder="admin@fashionstore.com" required>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" placeholder="••••••••" required minlength="6">
                </div>
                <div class="form-group">
                    <label>Confirm Password</label>
                    <input type="password" name="confirmPassword" placeholder="••••••••" required minlength="6">
                </div>
            </div>
            <button type="submit" class="btn-register"><i class="fas fa-user-plus"></i> Create Admin Account</button>
        </form>

        <div class="links">
            <p>Already have an account? <a href="admin-login">Sign In</a></p>
            <p style="margin-top: 10px;"><a href="home"><i class="fas fa-arrow-left"></i> Back to Store</a></p>
        </div>
    </div>
</body>
</html>
