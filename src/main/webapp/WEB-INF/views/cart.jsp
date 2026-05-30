<%@ page import="java.util.List" %>
<%@ page import="com.fashionstore.model.CartItem" %>
<%@ page import="com.fashionstore.model.Product" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Cart - Fashion Store</title>

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
            padding-bottom: 50px;
        }

        .cart-container {
            max-width: 1200px;
            margin: 60px auto;
            padding: 0 20px;
        }

        .cart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
        }

        h1 {
            font-size: 36px;
            font-weight: 700;
            background: linear-gradient(to right, #fff, #94a3b8);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;

        }

        .cart-layout {
            display: grid;
            grid-template-columns: 1.8fr 1fr;
            gap: 30px;
        }

        @media (max-width: 992px) {
            .cart-layout {
                grid-template-columns: 1fr;
            }
        }

        /* CART ITEMS */
        .cart-items {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .cart-card {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 20px;
            padding: 24px;
            display: flex;
            gap: 24px;
            transition: 0.3s;
        }

        .cart-card:hover {
            border-color: rgba(255, 255, 255, 0.2);
            transform: scale(1.01);
        }

        .item-image {
            width: 140px;
            height: 175px; /* Maintaining 4:5 ratio (140/175 = 4/5) */
            background: rgba(255, 255, 255, 0.05);
            border-radius: 16px;
            overflow: hidden;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .item-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .item-details {
            flex: 1;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .item-details h2 {
            font-size: 20px;
            margin-bottom: 8px;
        }

        .item-meta {
            font-size: 14px;
            color: #94a3b8;
            margin-bottom: 12px;
        }

        .item-meta span {
            color: var(--accent);
            font-weight: 600;
        }

        .item-controls {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .qty-input {
            display: flex;
            align-items: center;
            background: rgba(255, 255, 255, 0.05);
            border-radius: 10px;
            padding: 4px 12px;
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        .qty-input input {
            background: transparent;
            border: none;
            color: #fff;
            width: 40px;
            text-align: center;
            font-weight: 600;
            outline: none;
        }

        .btn-update {
            background: transparent;
            border: none;
            color: var(--primary);
            font-weight: 600;
            cursor: pointer;
            font-size: 14px;
        }

        .btn-remove {
            color: #ef4444;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
        }

        .item-price-box {
            text-align: right;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .item-price {
            font-size: 22px;
            font-weight: 700;
            color: #fff;
        }

        .item-subtotal-label {
            font-size: 12px;
            color: #94a3b8;
            text-transform: uppercase;
        }

        /* SUMMARY */
        .cart-summary {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            padding: 30px;
            height: fit-content;
            position: sticky;
            top: 40px;
        }

        .cart-summary h2 {
            margin-bottom: 24px;
            font-size: 24px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 16px;
            color: #94a3b8;
        }

        .summary-total {
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 20px;
            margin-top: 20px;
            display: flex;
            justify-content: space-between;
            font-size: 24px;
            font-weight: 700;
            color: #fff;
        }

        .btn-checkout {
            display: block;
            width: 100%;
            padding: 18px;
            margin-top: 30px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
            text-align: center;
            text-decoration: none;
            border-radius: 16px;
            font-weight: 700;
            font-size: 18px;
            transition: 0.3s;
            box-shadow: 0 10px 20px -10px rgba(99, 102, 241, 0.5);
        }

        .btn-checkout:hover {
            transform: translateY(-3px);
            filter: brightness(1.1);
        }

        .empty-cart {
            text-align: center;
            padding: 80px 0;
            background: var(--card-bg);
            border-radius: 24px;
            grid-column: span 2;
        }

        .empty-cart h2 {
            font-size: 28px;
            margin-bottom: 16px;
        }

        .btn-shop {
            display: inline-block;
            margin-top: 20px;
            color: var(--accent);
            text-decoration: none;
            font-weight: 600;
        }
    </style>
</head>

<body>

<%@ include file="partials/navbar.jsp" %>

<div class="cart-container">

    <div class="cart-header">
        <h1>Shopping Cart</h1>
    </div>

    <%
        List<CartItem> cart = (List<CartItem>) request.getAttribute("cart");
        Double total = (Double) request.getAttribute("total");
        if (total == null) total = 0.0;
    %>

    <div class="cart-layout">
        <% if (cart == null || cart.isEmpty()) { %>
            <div class="empty-cart">
                <h2>Your cart is currently empty</h2>
                <p>Looks like you haven't added anything to your cart yet.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn-shop">← Continue Shopping</a>
            </div>
        <% } else { %>
            
            <div class="cart-items">
                <% for (CartItem item : cart) { %>
                    <div class="cart-card">
                        <div class="item-image">
                            <img src="<%= item.getProduct().getImageUrl().startsWith("http") ? item.getProduct().getImageUrl() : request.getContextPath() + "/" + item.getProduct().getImageUrl() %>" 
                                 alt="<%= item.getProduct().getProductName() %>"
                                 onerror="this.src='https://placehold.co/400x500/1e293b/f8fafc?text=Product'">
                        </div>

                        <div class="item-details">
                            <div>
                                <h2><%= item.getProduct().getProductName() %></h2>
                                <p class="item-meta">Size: <span><%= item.getSize() %></span> | Price: <span>₹ <%= item.getProduct().getPrice() %></span></p>
                            </div>

                            <div class="item-controls">
                                <form action="${pageContext.request.contextPath}/cart" method="get" style="display: flex; align-items: center; gap: 10px;">
                                    <input type="hidden" name="action" value="update">
                                    <input type="hidden" name="id" value="<%= item.getVariantId() %>"> <!-- ✅ FIXED ID -->
                                    
                                    <div class="qty-input">
                                        <input type="number" name="qty" value="<%= item.getQuantity() %>" min="1" required>
                                    </div>
                                    <button type="submit" class="btn-update">Update</button>
                                </form>
                                
                                <a href="${pageContext.request.contextPath}/cart?action=remove&id=<%= item.getVariantId() %>" class="btn-remove">Remove</a> <!-- ✅ FIXED ID -->
                            </div>
                        </div>

                        <div class="item-price-box">
                            <p class="item-subtotal-label">Subtotal</p>
                            <p class="item-price">₹ <%= item.getTotalPrice() %></p>
                        </div>
                    </div>
                <% } %>
            </div>

            <div class="cart-summary">
                <h2>Order Summary</h2>
                <div class="summary-row">
                    <span>Subtotal</span>
                    <span>₹ <%= total %></span>
                </div>
                <div class="summary-row">
                    <span>Shipping</span>
                    <span style="color: #22c55e;">FREE</span>
                </div>
                <div class="summary-total">
                    <span>Total</span>
                    <span>₹ <%= total %></span>
                </div>

                <a href="${pageContext.request.contextPath}/checkout" class="btn-checkout">
                    Proceed to Checkout
                </a>
            </div>
        <% } %>
    </div>

</div>

<%@ include file="partials/footer.jsp" %>

</body>
</html>

