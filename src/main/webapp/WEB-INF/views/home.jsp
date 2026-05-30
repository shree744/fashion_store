<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.List,com.fashionstore.model.Product,com.fashionstore.model.Category,com.fashionstore.model.Coupon" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fashion Store - Premium Trends</title>

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
            margin: 0;
            overflow-x: hidden;
        }

        .container {
            max-width: 1300px;
            margin: 0 auto;
            padding: 0 40px;
        }

        /* HERO SECTION */
        .hero {
            display: grid;
            grid-template-columns: 1.2fr 0.8fr;
            align-items: center;
            padding: 80px 0;
            gap: 60px;
        }

        .hero-left h1 {
            font-size: 72px;
            line-height: 1.1;
            font-weight: 800;
            margin-bottom: 24px;
            background: linear-gradient(to right, #fff, #94a3b8);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;

        }

        .hero-left p {
            font-size: 20px;
            color: #94a3b8;
            margin-bottom: 40px;
            max-width: 500px;
        }

        .btn-primary {
            display: inline-block;
            padding: 18px 40px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white;
            text-decoration: none;
            border-radius: 16px;
            font-weight: 700;
            font-size: 18px;
            transition: 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            box-shadow: 0 20px 40px -10px rgba(99, 102, 241, 0.5);
        }

        .btn-primary:hover {
            transform: translateY(-5px) scale(1.02);
            filter: brightness(1.1);
            box-shadow: 0 30px 60px -12px rgba(99, 102, 241, 0.6);
        }

        .hero-right img {
            width: 100%;
            border-radius: 40px;
            box-shadow: 0 40px 100px -20px rgba(0, 0, 0, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.1);
        }

        /* CATEGORIES */
        .section-title {
            font-size: 36px;
            font-weight: 700;
            margin-top: 100px;
            margin-bottom: 40px;
            text-align: center;
        }

        .categories-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 24px;
        }

        @media (max-width: 992px) {
            .categories-grid { grid-template-columns: repeat(2, 1fr); }
        }

        .cat-card {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            padding: 40px;
            text-align: center;
            text-decoration: none;
            color: inherit;
            transition: 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .cat-card:hover {
            transform: translateY(-12px);
            border-color: var(--accent);
            background: rgba(34, 211, 238, 0.05);
            box-shadow: 0 30px 60px -20px rgba(0, 0, 0, 0.4);
        }

        .cat-card .icon {
            font-size: 40px;
            margin-bottom: 20px;
            background: rgba(255, 255, 255, 0.05);
            width: 80px;
            height: 80px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 20px;
            transition: 0.3s;
        }

        .cat-card:hover .icon {
            background: var(--accent);
            color: var(--bg);
            transform: rotate(10deg);
        }

        .cat-card h3 {
            font-size: 24px;
            margin-bottom: 8px;
        }

        .cat-card p {
            color: #94a3b8;
            font-size: 14px;
        }

        /* BRANDS MARQUEE */
        .brands-marquee-container {
            width: 100vw;
            position: relative;
            left: 50%;
            right: 50%;
            margin-left: -50vw;
            margin-right: -50vw;
            background: rgba(15, 23, 42, 0.9);
            border-top: 1px solid rgba(255, 255, 255, 0.05);
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            padding: 40px 0;
            margin-top: 80px;
            overflow: hidden;
            display: flex;
            align-items: center;
        }

        .marquee-content {
            display: flex;
            width: fit-content;
            animation: marquee 30s linear infinite;
        }

        .marquee-content:hover {
            animation-play-state: paused;
        }

        @keyframes marquee {
            0% { transform: translateX(0); }
            100% { transform: translateX(-50%); }
        }

        .brand-item {
            font-size: 32px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 4px;
            padding: 0 40px;
            color: transparent;
            -webkit-text-stroke: 1px rgba(255, 255, 255, 0.3);
            white-space: nowrap;
            display: flex;
            align-items: center;
            transition: 0.3s;
            cursor: default;
        }

        .brand-item:hover {
            color: #fff;
            -webkit-text-stroke: 1px #fff;
            text-shadow: 0 0 20px rgba(255, 255, 255, 0.5);
        }

        .brand-item::after {
            content: "★";
            color: var(--accent);
            font-size: 20px;
            -webkit-text-stroke: 0px;
            margin-left: 80px;
            text-shadow: none;
        }

        /* LATEST PRODUCTS */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 32px;
            margin-bottom: 100px;
        }

        .product-card {
            background: var(--card-bg);
            border-radius: 24px;
            padding: 20px;
            border: 1px solid rgba(255, 255, 255, 0.08);
            transition: 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .product-card:hover {
            transform: translateY(-10px) rotateX(5deg) rotateY(5deg);
            border-color: rgba(255, 255, 255, 0.2);
            box-shadow: 0 40px 80px -25px rgba(0, 0, 0, 0.6);
        }

        .product-img {
            width: 100%;
            height: 375px; /* Maintaining 4:5 ratio for a 300px wide card */
            border-radius: 16px;
            margin-bottom: 20px;
            background: rgba(255, 255, 255, 0.02);
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
        }

        .product-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: 0.6s;
        }

        .product-card:hover .product-img img {
            transform: scale(1.1);
        }

        .product-card h3 {
            font-size: 20px;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .product-card .brand {
            font-size: 13px;
            color: var(--accent);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 12px;
            display: block;
        }

        .product-price {
            font-size: 24px;
            font-weight: 700;
            margin-top: auto;
            margin-bottom: 20px;
        }

        .btn-view-shop:hover {
            background: #fff !important;
            color: var(--bg) !important;
            transform: translateY(-3px);
        }

        /* FLOATING GIFT BOX & OFFERS POPUP */
        .gift-box-container {
            position: absolute;
            top: 100px; /* Right below navbar */
            right: 30px;
            z-index: 999;
        }

        .gift-box-trigger {
            background: linear-gradient(135deg, #ec4899, #f43f5e);
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            cursor: pointer;
            box-shadow: 0 10px 25px rgba(244, 63, 94, 0.5);
            border: 2px solid rgba(255, 255, 255, 0.2);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            animation: giftPulse 2s infinite ease-in-out;
        }

        .gift-box-trigger:hover {
            transform: scale(1.1) rotate(15deg);
            box-shadow: 0 15px 30px rgba(244, 63, 94, 0.7);
        }

        .gift-box-trigger i {
            animation: giftShake 1.5s infinite ease-in-out;
        }

        @keyframes giftPulse {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.08); }
        }

        @keyframes giftShake {
            0%, 100% { transform: rotate(0); }
            25% { transform: rotate(-10deg); }
            75% { transform: rotate(10deg); }
        }

        /* POPUP MODAL */
        .offers-popup {
            position: absolute;
            top: 70px;
            right: 0;
            width: 320px;
            background: rgba(15, 23, 42, 0.95);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            padding: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
            opacity: 0;
            visibility: hidden;
            transform: translateY(-20px) scale(0.9);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            max-height: 450px;
            overflow-y: auto;
        }

        .offers-popup.active {
            opacity: 1;
            visibility: visible;
            transform: translateY(0) scale(1);
        }

        .offers-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.05);
            padding-bottom: 12px;
        }

        .offers-header h3 {
            margin: 0;
            font-size: 18px;
            font-weight: 700;
            background: linear-gradient(to right, #ec4899, #f43f5e);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .offers-header .close-btn {
            background: none;
            border: none;
            color: #94a3b8;
            cursor: pointer;
            font-size: 16px;
            transition: 0.3s;
        }

        .offers-header .close-btn:hover {
            color: white;
        }

        .offer-card {
            background: rgba(255, 255, 255, 0.03);
            border: 1px dashed rgba(236, 72, 153, 0.3);
            border-radius: 16px;
            padding: 16px;
            margin-bottom: 12px;
            transition: 0.3s;
            position: relative;
            overflow: hidden;
        }

        .offer-card:hover {
            background: rgba(236, 72, 153, 0.05);
            border-color: #ec4899;
        }

        .offer-discount {
            font-size: 20px;
            font-weight: 800;
            color: #ec4899;
            margin-bottom: 4px;
            text-align: left;
        }

        .offer-code-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 12px;
            background: rgba(0, 0, 0, 0.2);
            padding: 6px 12px;
            border-radius: 10px;
            border: 1px solid rgba(255, 255, 255, 0.05);
        }

        .offer-code {
            font-family: monospace;
            font-size: 14px;
            font-weight: 700;
            color: #cbd5e1;
            letter-spacing: 1px;
        }

        .copy-btn {
            background: #ec4899;
            color: white;
            border: none;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.2s;
        }

        .copy-btn:hover {
            background: #f43f5e;
            transform: scale(1.05);
        }

        .offer-expiry {
            font-size: 11px;
            color: #64748b;
            margin-top: 8px;
            display: block;
            text-align: left;
        }
    </style>

</head>

<body>

<%@ include file="partials/navbar.jsp" %>

<div class="container">

    <!-- HERO -->
    <div class="hero">
        <div class="hero-left">
            <h1>Elevate Your Style<br>to the Next Level</h1>
            <p>Experience fashion like never before. Premium quality, modern designs, and unbeatable trends tailored just for you.</p>
            <a href="${pageContext.request.contextPath}/products" class="btn-primary">Explore Collection</a>
        </div>
        <div class="hero-right">
            <img src="https://images.unsplash.com/photo-1483985988355-763728e1935b?q=80&w=2070&auto=format&fit=crop" alt="Fashion Hero">
        </div>
    </div>

    <!-- CATEGORIES -->
    <h2 class="section-title" id="categories">Shop by Category</h2>

    <div class="categories-grid">
        <%
            java.util.List<com.fashionstore.model.Category> categories = (java.util.List<com.fashionstore.model.Category>) request.getAttribute("categories");
            if (categories != null) {
                for (Category cat : categories) {
                    String icon = "📦";
                    String name = cat.getCategoryName().toLowerCase();
                    if (name.contains("men")) icon = "👔";
                    else if (name.contains("women")) icon = "👗";
                    else if (name.contains("kid")) icon = "🧸";
                    else if (name.contains("foot") || name.contains("shoe")) icon = "👟";
                    else if (name.contains("belt")) icon = "⛓️";
                    else if (name.contains("accessor")) icon = "👜";
        %>
            <a href="${pageContext.request.contextPath}/products?categoryId=<%= cat.getCategoryId() %>" class="cat-card">
                <div class="icon"><%= icon %></div>
                <h3><%= cat.getCategoryName() %></h3>
                <p><%= cat.getDescription() %></p>
            </a>
        <%
                }
            }
        %>
    </div>

    <!-- BRANDS MARQUEE -->
    <%
        java.util.List<String> brands = (java.util.List<String>) request.getAttribute("brands");
        if (brands != null && !brands.isEmpty()) {
    %>
    <div class="brands-marquee-container">
        <div class="marquee-content">
            <%-- Loop twice to create a seamless infinite scrolling effect --%>
            <% for(int i=0; i<2; i++) { %>
                <% for(String brand : brands) { %>
                    <div class="brand-item"><%= brand %></div>
                <% } %>
            <% } %>
        </div>
    </div>
    <% } %>

    <!-- LATEST -->
    <h2 class="section-title">Latest Arrivals</h2>
    <div class="products-grid">
        <%
            java.util.List<com.fashionstore.model.Product> products = (java.util.List<com.fashionstore.model.Product>) request.getAttribute("latestProducts");
            if (products != null && !products.isEmpty()) {
                for (Product p : products) {
        %>
            <div class="product-card">
                <div class="product-img">
                    <img src="<%= p.getImageUrl().startsWith("http") ? p.getImageUrl() : request.getContextPath() + "/" + p.getImageUrl() %>" 
                         alt="<%= p.getProductName() %>"
                         onerror="this.src='https://placehold.co/400x500/1e293b/f8fafc?text=<%= p.getProductName() %>'">
                </div>
                <div class="product-info">
                    <span class="brand"><%= p.getBrand() != null ? p.getBrand() : "Premium Edition" %></span>
                    <h3><%= p.getProductName() %></h3>
                    <div class="product-price">₹ <%= p.getPrice() %></div>
                    <a href="${pageContext.request.contextPath}/product-details?id=<%= p.getProductId() %>" class="btn-view-shop" style="display: block; text-align: center; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 12px; color: #fff; text-decoration: none; font-weight: 600; transition: 0.3s;">
                        View & Shop
                    </a>
                </div>
<%-- CSS for btn-view-shop added to style tag --%>

            </div>
        <%
                }
            } else {
        %>
            <div style="grid-column: span 4; text-align: center; padding: 50px; background: rgba(255,255,255,0.02); border-radius: 20px;">
                <p style="color: #94a3b8; font-size: 18px;">New collections are coming soon! Stay tuned.</p>
            </div>
        <% } %>
    </div>

</div>

<!-- FLOATING GIFT BOX & OFFERS POPUP -->
<%
    java.util.List<com.fashionstore.model.Coupon> coupons = (java.util.List<com.fashionstore.model.Coupon>) request.getAttribute("coupons");
    if (coupons != null && !coupons.isEmpty()) {
        Object currentUser = session.getAttribute("user");
%>
<div class="gift-box-container">
    <div class="gift-box-trigger" onclick="toggleOffersPopup(event)">
        <i class="fas fa-gift"></i>
    </div>
    <div class="offers-popup" id="offersPopup">
        <div class="offers-header">
            <h3>🎁 Exclusive Offers</h3>
            <button class="close-btn" onclick="toggleOffersPopup(event)"><i class="fas fa-times"></i></button>
        </div>
        <% if (currentUser != null) { %>
            <% for (Coupon coupon : coupons) { %>
                <div class="offer-card">
                    <div class="offer-discount">
                        <%= "Percentage".equalsIgnoreCase(coupon.getDiscountType()) ? coupon.getDiscountValue() + "% OFF" : "₹" + coupon.getDiscountValue() + " OFF" %>
                    </div>
                    <div style="font-size: 13px; color: #94a3b8; font-weight: 600; text-align: left;">On your next purchase!</div>
                    <div class="offer-code-row">
                        <span class="offer-code" id="code-<%= coupon.getCouponId() %>"><%= coupon.getCode() %></span>
                        <button class="copy-btn" onclick="copyCouponCode('<%= coupon.getCode() %>', this)">Copy</button>
                    </div>
                    <span class="offer-expiry">Expires: <%= coupon.getExpiryDate() %></span>
                </div>
            <% } %>
        <% } else { %>
            <div style="text-align: center; padding: 10px 0;">
                <p style="font-size: 14px; color: #cbd5e1; margin-bottom: 20px; line-height: 1.6; text-align: center;">
                    Unlock exclusive discount coupons and special deals!
                </p>
                <a href="${pageContext.request.contextPath}/login" class="btn" style="display: inline-block; background: linear-gradient(135deg, #ec4899, #f43f5e); border: none; padding: 10px 24px; border-radius: 12px; color: white; text-decoration: none; font-weight: 700; transition: 0.3s; box-shadow: 0 4px 12px rgba(244,63,94,0.3);">
                    Login to View Offers
                </a>
            </div>
        <% } %>
    </div>
</div>
<%
    }
%>

<%@ include file="partials/footer.jsp" %>

<script>
    function toggleOffersPopup(event) {
        event.stopPropagation();
        const popup = document.getElementById('offersPopup');
        if (popup) {
            popup.classList.toggle('active');
        }
    }

    function copyCouponCode(code, btn) {
        navigator.clipboard.writeText(code).then(() => {
            const originalText = btn.textContent;
            btn.textContent = 'Copied!';
            btn.style.background = '#22c55e'; // Success green
            setTimeout(() => {
                btn.textContent = originalText;
                btn.style.background = '';
            }, 2000);
        }).catch(err => {
            console.error('Failed to copy text: ', err);
        });
    }

    // Close popup if clicking outside
    document.addEventListener('click', function(event) {
        const popup = document.getElementById('offersPopup');
        const trigger = document.querySelector('.gift-box-trigger');
        if (popup && popup.classList.contains('active')) {
            if (!popup.contains(event.target) && !trigger.contains(event.target)) {
                popup.classList.remove('active');
            }
        }
    });
</script>

</body>
</html>
