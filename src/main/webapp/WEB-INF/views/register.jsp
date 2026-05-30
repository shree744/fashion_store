<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account - Fashion Store</title>

    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

    <style>
        :root {
            --primary: #6366f1;
            --secondary: #a855f7;
            --accent: #22d3ee;
            --bg: #0f172a;
            --card-bg: rgba(30, 41, 59, 0.7);
            --text: #f8fafc;
        }

        body {
            font-family: 'Outfit', sans-serif;
            background: radial-gradient(circle at top right, #1e1b4b, #0f172a);
            color: var(--text);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 20px;
        }

        .auth-card {
            max-width: 800px;
            width: 100%;
            background: var(--card-bg);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 32px;
            padding: 50px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.5);
            animation: fadeIn 0.8s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .auth-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .auth-header h1 {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 10px;
            background: linear-gradient(to right, #fff, #94a3b8);
            -webkit-background-clip: text;
            background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        @media (max-width: 600px) {
            .form-grid { grid-template-columns: 1fr; }
        }

        .form-group {
            margin-bottom: 10px;
        }

        .form-group.full {
            grid-column: span 2;
        }

        @media (max-width: 600px) {
            .form-group.full { grid-column: span 1; }
        }

        label {
            display: block;
            font-size: 13px;
            color: #94a3b8;
            margin-bottom: 8px;
            font-weight: 500;
        }

        input {
            width: 100%;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            color: #fff;
            font-size: 14px;
            outline: none;
            transition: 0.3s;
        }

        input:focus {
            border-color: var(--primary);
            background: rgba(255, 255, 255, 0.08);
        }

        .btn-auth {
            grid-column: span 2;
            padding: 16px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
            border: none;
            border-radius: 14px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
            margin-top: 20px;
        }

        @media (max-width: 600px) {
            .btn-auth { grid-column: span 1; }
        }

        .btn-auth:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 20px rgba(99, 102, 241, 0.4);
        }

        .error-msg {
            background: rgba(239, 68, 68, 0.1);
            color: #fca5a5;
            padding: 12px;
            border-radius: 10px;
            font-size: 14px;
            margin-bottom: 24px;
            text-align: center;
            grid-column: span 2;
        }

        .auth-footer {
            text-align: center;
            margin-top: 30px;
            font-size: 14px;
            color: #94a3b8;
        }

        .auth-footer a {
            color: var(--accent);
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>

<body>

<div class="auth-card">
    <div class="auth-header">
        <h1>Join the Trend</h1>
        <p>Create an account to start your fashion journey</p>
    </div>

    <form action="${pageContext.request.contextPath}/register" method="post" class="form-grid">
        
        <% String error = (String) request.getAttribute("error");
           if (error != null) { %>
            <div class="error-msg"><%= error %></div>
        <% } %>

        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="name" placeholder="John Doe" required>
        </div>

        <div class="form-group">
            <label>Email Address</label>
            <input type="email" name="email" placeholder="john@example.com" required>
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="••••••••" required>
        </div>

        <div class="form-group">
            <label>Phone Number</label>
            <input type="text" name="phone" placeholder="+91 0000000000" required>
        </div>

        <div class="form-group full">
            <label>Address Line 1</label>
            <input type="text" name="address1" placeholder="House No, Street Name" required>
        </div>

        <div class="form-group full">
            <label>Address Line 2 (Optional)</label>
            <input type="text" name="address2" placeholder="Landmark, Area">
        </div>

        <div class="form-group">
            <label>City</label>
            <input type="text" name="city" placeholder="Your City" required>
        </div>

        <div class="form-group">
            <label>State</label>
            <input type="text" name="state" placeholder="Your State" required>
        </div>

        <div class="form-group">
            <label>Pincode</label>
            <input type="text" name="pincode" placeholder="000000" required>
        </div>

        <div class="form-group">
            <label>Country</label>
            <input type="text" name="country" placeholder="India" required>
        </div>

        <button type="submit" class="btn-auth">Create My Account</button>
    </form>

    <div class="auth-footer">
        Already have an account? 
        <a href="${pageContext.request.contextPath}/login">Sign In Instead</a>
    </div>
</div>

</body>
</html>
