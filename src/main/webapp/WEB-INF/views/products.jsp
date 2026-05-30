<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.List,com.fashionstore.model.Product,com.fashionstore.model.Category,com.fashionstore.model.Coupon" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shop Premium Collections - Fashion Store</title>

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
        }

        .main-layout {
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 40px;
            max-width: 1400px;
            margin: 40px auto;
            padding: 0 40px;
        }

        @media (max-width: 992px) {
            .main-layout { grid-template-columns: 1fr; }
        }

        /* SIDEBAR FILTERS */
        .sidebar {
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            padding: 30px;
            height: fit-content;
            max-height: calc(100vh - 140px);
            overflow-y: auto;
            position: sticky;
            top: 100px;
        }

        .sidebar::-webkit-scrollbar {
            width: 6px;
        }
        .sidebar::-webkit-scrollbar-track {
            background: rgba(255, 255, 255, 0.02);
            border-radius: 10px;
            margin: 10px 0;
        }
        .sidebar::-webkit-scrollbar-thumb {
            background: rgba(99, 102, 241, 0.3);
            border-radius: 10px;
        }
        .sidebar::-webkit-scrollbar-thumb:hover {
            background: rgba(99, 102, 241, 0.6);
        }

        .sidebar h3 {
            font-size: 24px;
            margin-bottom: 24px;
            font-weight: 700;
        }

        .filter-group {
            margin-bottom: 24px;
        }

        .filter-group label {
            display: block;
            font-size: 14px;
            color: #94a3b8;
            margin-bottom: 10px;
            font-weight: 600;
        }

        .filter-group input, .filter-group select {
            width: 100%;
            padding: 12px 16px;
            background: rgba(255, 255, 255, 0.03);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 12px;
            color: #fff;
            outline: none;
            transition: 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 24 24' stroke='%236366f1'%3E%3Cpath stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='M19 9l-7 7-7-7'%3E%3C/path%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 18px;
        }

        .filter-group select option {
            background: #0f172a;
            color: #fff;
        }

        .filter-group input:focus, .filter-group select:focus {
            border-color: var(--primary);
            background: rgba(255, 255, 255, 0.06);
            box-shadow: 0 0 20px rgba(99, 102, 241, 0.1);
        }



        .btn-apply {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: #fff;
            border: none;
            border-radius: 12px;
            font-weight: 700;
            cursor: pointer;
            transition: 0.3s;
        }

        .btn-apply:hover {
            transform: translateY(-3px);
            filter: brightness(1.1);
            box-shadow: 0 10px 20px rgba(99, 102, 241, 0.3);
        }

        /* PRODUCT GRID */
        .products-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 30px;
        }

        .product-card {
            background: var(--card-bg);
            border-radius: 24px;
            padding: 20px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: 0.4s;
            display: flex;
            flex-direction: column;
        }

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 30px 60px -20px rgba(0, 0, 0, 0.5);
            border-color: rgba(255, 255, 255, 0.2);
        }

        .product-img {
            width: 100%;
            height: 375px; /* Maintaining 4:5 ratio for a 300px wide card */
            border-radius: 18px;
            overflow: hidden;
            background: rgba(255, 255, 255, 0.02);
            margin-bottom: 20px;
        }

        .product-img img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: 0.5s;
        }

        .product-card:hover .product-img img {
            transform: scale(1.1);
        }

        .brand-tag {
            font-size: 12px;
            color: var(--accent);
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 1px;
            margin-bottom: 8px;
        }

        .product-card h3 {
            font-size: 18px;
            margin-bottom: 12px;
            font-weight: 600;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: auto;
        }

        .price {
            font-size: 22px;
            font-weight: 700;
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

<div class="main-layout">
    
    <!-- FILTERS -->
    <aside class="sidebar">
        <h3>Filters</h3>
        <form method="get" action="${pageContext.request.contextPath}/products">
            <div class="filter-group">
                <label>Search</label>
                <input type="text" name="keyword" placeholder="What are you looking for?" value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>">
            </div>

            <div class="filter-group">
                <label>Category</label>
                <select name="categoryId">
                    <option value="">All Collections</option>
                    <%
                        java.util.List<com.fashionstore.model.Category> categories = (java.util.List<com.fashionstore.model.Category>) request.getAttribute("categories");
                        String selectedCat = request.getParameter("categoryId");
                        if (categories != null) {
                            for (com.fashionstore.model.Category cat : categories) {
                                boolean isSelected = String.valueOf(cat.getCategoryId()).equals(selectedCat);
                    %>
                        <option value="<%= cat.getCategoryId() %>" <%= isSelected ? "selected" : "" %>><%= cat.getCategoryName() %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <div class="filter-group">
                <label>Price Range</label>
                <div style="display: flex; gap: 10px;">
                    <input type="number" name="min" placeholder="Min" value="<%= request.getParameter("min") != null ? request.getParameter("min") : "" %>">
                    <input type="number" name="max" placeholder="Max" value="<%= request.getParameter("max") != null ? request.getParameter("max") : "" %>">
                </div>
            </div>

            <div class="filter-group">
                <label>Sort By</label>
                <select name="sort">
                    <option value="default" <%= "default".equals(request.getParameter("sort")) ? "selected" : "" %>>Featured</option>
                    <option value="low" <%= "low".equals(request.getParameter("sort")) ? "selected" : "" %>>Price: Low to High</option>
                    <option value="high" <%= "high".equals(request.getParameter("sort")) ? "selected" : "" %>>Price: High to Low</option>
                </select>
            </div>

            <button type="submit" class="btn-apply">Apply Filters</button>
        </form>
    </aside>

    <!-- CONTENT -->
    <main class="content">
        <div class="products-grid">
            <%
                List<Product> productsList = (List<Product>) request.getAttribute("products");
                if (productsList != null && !productsList.isEmpty()) {
                    for (Product p : productsList) {
            %>
                <div class="product-card">
                    <div class="product-img">
                        <img src="<%= p.getImageUrl().startsWith("http") ? p.getImageUrl() : request.getContextPath() + "/" + p.getImageUrl() %>" 
                             alt="<%= p.getProductName() %>"
                             onerror="this.src='https://placehold.co/400x500/1e293b/f8fafc?text=<%= p.getProductName() %>'">
                    </div>
                    <div class="brand-tag"><%= p.getBrand() != null ? p.getBrand() : "Trending" %></div>
                    <h3><%= p.getProductName() %></h3>
                    <div class="price-row" style="margin-top: 15px;">
                        <div class="price">₹ <%= p.getPrice() %></div>
                    </div>
                    <a href="${pageContext.request.contextPath}/product-details?id=<%= p.getProductId() %>" class="btn-view-shop" style="margin-top: 15px; display: block; text-align: center; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 12px; padding: 12px; color: #fff; text-decoration: none; font-weight: 600; transition: 0.3s;">
                        View & Shop
                    </a>
                </div>
            <%
                    }
                } else {
            %>
                <div style="grid-column: span 3; text-align: center; padding: 100px 0;">
                    <h2 style="color: #94a3b8;">No products found matching your filters.</h2>
                    <a href="${pageContext.request.contextPath}/products" style="color: var(--primary); text-decoration: none; font-weight: 600;">Clear All Filters</a>
                </div>
            <% } %>
        </div>
    </main>

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
