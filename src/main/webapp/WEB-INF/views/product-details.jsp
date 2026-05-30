<%@ page import="java.util.List" %>
<%@ page import="com.fashionstore.model.ProductVariant" %>
<%@ page import="com.fashionstore.model.Product" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.productName} - Fashion Store</title>

    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
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
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Outfit', sans-serif;
            background: radial-gradient(circle at top right, #1e1b4b, #0f172a);
            color: var(--text);
            min-height: 100vh;
            padding: 40px 20px;
        }
        .product-container {
            max-width: 1100px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 24px;
            padding: 40px;
            box-shadow: 0 25px 50px -12px rgba(0,0,0,0.5);
        }
        @media (max-width: 768px) {
            .product-container { grid-template-columns: 1fr; }
        }

        /* IMAGE */
        .image-section {
            background: rgba(255,255,255,0.03);
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            overflow: hidden;
            border: 1px solid rgba(255,255,255,0.05);
            width: 100%;
            aspect-ratio: 4/5;
        }
        .image-section img {
            width: 100%; height: 100%;
            object-fit: cover;
            transition: transform 0.5s cubic-bezier(0.4,0,0.2,1);
        }
        .image-section:hover img { transform: scale(1.05); }

        /* INFO */
        .info-section {
            display: flex;
            flex-direction: column;
            justify-content: center;
        }
        .brand {
            text-transform: uppercase;
            letter-spacing: 2px;
            color: var(--accent);
            font-weight: 600;
            font-size: 14px;
            margin-bottom: 8px;
        }
        h1 {
            font-size: 38px;
            font-weight: 700;
            line-height: 1.1;
            margin-bottom: 16px;
            background: linear-gradient(to right, #fff, #94a3b8);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .rating-badge {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }
        .stars { color: #fbbf24; font-size: 16px; }
        .stock-badge {
            font-size: 13px;
            padding: 4px 14px;
            border-radius: 20px;
        }
        .stock-in { background: rgba(34,197,94,0.1); color: #4ade80; }
        .stock-low { background: rgba(245,158,11,0.1); color: #fbbf24; }
        .stock-out { background: rgba(239,68,68,0.1); color: #f87171; }
        .price-tag {
            font-size: 28px;
            font-weight: 600;
            color: #fff;
            margin-bottom: 20px;
        }
        .price-tag span {
            font-size: 15px;
            color: #94a3b8;
            font-weight: 400;
            margin-left: 8px;
        }
        .description {
            color: #94a3b8;
            line-height: 1.7;
            margin-bottom: 28px;
            font-size: 15px;
        }

        /* SECTION TITLES */
        .section-title {
            font-weight: 600;
            margin-bottom: 12px;
            font-size: 14px;
            color: #cbd5e1;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        /* COLOR SWATCHES */
        .color-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 28px;
        }
        .color-option { position: relative; }
        .color-option input { position: absolute; opacity: 0; cursor: pointer; }
        .color-option label {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 16px;
            border: 2px solid rgba(255,255,255,0.08);
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 14px;
            font-weight: 500;
            background: rgba(255,255,255,0.03);
        }
        .color-dot {
            width: 18px;
            height: 18px;
            border-radius: 50%;
            border: 2px solid rgba(255,255,255,0.2);
            flex-shrink: 0;
        }
        .color-option input:checked + label {
            border-color: var(--primary);
            background: rgba(99,102,241,0.1);
            box-shadow: 0 0 15px rgba(99,102,241,0.25);
        }
        .color-option label:hover {
            border-color: rgba(255,255,255,0.2);
            background: rgba(255,255,255,0.05);
        }

        /* SIZE BUTTONS */
        .sizes-grid {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 32px;
        }
        .size-option { position: relative; }
        .size-option input { position: absolute; opacity: 0; cursor: pointer; }
        .size-option label {
            display: flex;
            align-items: center;
            justify-content: center;
            min-width: 52px;
            height: 48px;
            padding: 0 14px;
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s;
            font-weight: 600;
            font-size: 15px;
            background: rgba(255,255,255,0.03);
        }
        .size-option input:checked + label {
            background: var(--primary);
            border-color: var(--primary);
            box-shadow: 0 0 20px rgba(99,102,241,0.4);
            transform: translateY(-2px);
        }
        .size-option label:hover:not(.disabled-size) {
            border-color: rgba(255,255,255,0.3);
            background: rgba(255,255,255,0.08);
        }
        .disabled-size {
            opacity: 0.4;
            cursor: not-allowed !important;
            text-decoration: line-through;
        }

        /* BUTTONS */
        .action-btns { display: flex; gap: 14px; }
        .btn-add {
            flex: 1; padding: 16px;
            border: none; border-radius: 14px;
            background: linear-gradient(135deg, var(--primary), var(--secondary));
            color: white; font-weight: 700; font-size: 16px;
            cursor: pointer; transition: all 0.3s;
            box-shadow: 0 10px 20px -10px rgba(99,102,241,0.5);
        }
        .btn-add:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 25px -10px rgba(99,102,241,0.6);
        }
        .btn-back {
            padding: 16px 22px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 14px;
            color: #fff;
            text-decoration: none;
            font-weight: 600;
            transition: all 0.3s;
            display: flex; align-items: center;
        }
        .btn-back:hover { background: rgba(255,255,255,0.1); }
        .btn-disabled {
            background: #475569 !important;
            cursor: not-allowed;
            box-shadow: none !important;
        }

        /* REVIEWS SECTION */
        .reviews-container {
            max-width: 1100px;
            margin: 30px auto 60px;
            background: var(--card-bg);
            backdrop-filter: blur(12px);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 24px;
            padding: 40px;
        }
        .review-card {
            background: rgba(255,255,255,0.03);
            padding: 20px;
            border-radius: 16px;
            margin-bottom: 14px;
            border: 1px solid rgba(255,255,255,0.05);
        }
        .review-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
        }
        .reviewer-name { font-weight: 600; }
        .review-date { color: #94a3b8; font-size: 12px; }
        .review-stars { color: #fbbf24; margin-bottom: 8px; }
        .review-empty {
            text-align: center;
            padding: 40px;
            background: rgba(255,255,255,0.02);
            border-radius: 16px;
        }
        .review-form-card {
            background: rgba(255,255,255,0.03);
            padding: 30px;
            border-radius: 20px;
            border: 1px solid rgba(255,255,255,0.05);
            height: fit-content;
        }
        .review-textarea {
            width: 100%;
            padding: 15px;
            background: rgba(15,23,42,0.5);
            border: 1px solid rgba(255,255,255,0.1);
            border-radius: 12px;
            color: white;
            resize: vertical;
            font-family: inherit;
            margin-bottom: 18px;
            font-size: 14px;
        }
        .review-textarea:focus {
            outline: none;
            border-color: var(--primary);
        }
        .alert-box {
            padding: 12px 20px;
            border-radius: 12px;
            margin: 15px 0;
            font-size: 14px;
        }
        .alert-success { background: rgba(34,197,94,0.15); color: #4ade80; }
        .alert-error { background: rgba(239,68,68,0.15); color: #f87171; }
    </style>
</head>
<body>

<%@ include file="partials/navbar.jsp" %>

<div class="product-container" style="margin-top: 60px;">

    <!-- LEFT: IMAGE -->
    <div class="image-section">
        <% Product pDetail = (Product)request.getAttribute("product"); %>
        <img src="<%= pDetail.getImageUrl().startsWith("http") ? pDetail.getImageUrl() : request.getContextPath() + "/" + pDetail.getImageUrl() %>"
             alt="${product.productName}" id="mainProductImage"
             onerror="this.src='https://placehold.co/400x500/1e293b/f8fafc?text=${product.productName}'">
    </div>

    <!-- RIGHT: DETAILS -->
    <div class="info-section">
        <p class="brand">${product.brand}</p>
        <h1>${product.productName}</h1>

        <div class="rating-badge">
            <div class="stars">
                <c:forEach begin="1" end="5" var="i">
                    <i class="${product.averageRating >= i ? 'fas' : 'far'} fa-star"></i>
                </c:forEach>
                <span style="color: #94a3b8; margin-left: 6px; font-size: 13px;">(${product.averageRating})</span>
            </div>
            <c:choose>
                <c:when test="${not empty variants && variants[0].stockQuantity > 3}">
                    <span class="stock-badge stock-in">In Stock</span>
                </c:when>
                <c:when test="${not empty variants && variants[0].stockQuantity > 0}">
                    <span class="stock-badge stock-low">Low Stock</span>
                </c:when>
                <c:otherwise>
                    <span class="stock-badge stock-out">Out of Stock</span>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="price-tag">
            ₹ ${product.price} <span>Inc. all taxes</span>
        </div>

        <p class="description">${product.description}</p>

        <form action="${pageContext.request.contextPath}/cart" method="get" id="addToCartForm">
            <input type="hidden" name="action" value="add">
            <input type="hidden" name="productId" value="${product.productId}">
            <input type="hidden" name="qty" value="1">

            <!-- SIZE SELECTION (Colors removed as per request) -->
            <p class="section-title">Choose Size</p>
            <div class="sizes-grid">
                <%
                    java.util.List<ProductVariant> vList = (java.util.List<ProductVariant>) request.getAttribute("variants");
                    java.util.Set<String> seenSizes = new java.util.HashSet<>();
                    if (vList != null) {
                        for (ProductVariant v : vList) {
                            if (!seenSizes.contains(v.getSize())) {
                                seenSizes.add(v.getSize());
                %>
                    <div class="size-option">
                        <input type="radio" name="id" id="sz-<%= v.getVariantId() %>" value="<%= v.getVariantId() %>" required
                            <%= v.getStockQuantity() == 0 ? "disabled" : "" %>>
                        <label for="sz-<%= v.getVariantId() %>" class="<%= v.getStockQuantity() == 0 ? "disabled-size" : "" %>">
                            <%= v.getSize() %>
                        </label>
                    </div>
                <%
                            }
                        }
                    }
                %>
            </div>

            <div class="action-btns">
                <a href="${pageContext.request.contextPath}/products" class="btn-back">
                    <i class="fas fa-arrow-left"></i>
                </a>
                <c:choose>
                    <c:when test="${variants[0].stockQuantity > 0}">
                        <button type="submit" class="btn-add">
                            <i class="fas fa-shopping-cart"></i> Add to Shopping Cart
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button type="button" class="btn-add btn-disabled" disabled>Out of Stock</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </form>
    </div>
</div>

<!-- REVIEWS SECTION -->
<div class="reviews-container">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px;">
        <h2 style="font-size: 22px;">Customer Reviews</h2>
        <div style="display: flex; align-items: center; gap: 10px;">
            <span class="stars" style="font-size: 20px;">
                <c:forEach begin="1" end="5" var="i">
                    <i class="${product.averageRating >= i ? 'fas' : 'far'} fa-star"></i>
                </c:forEach>
            </span>
            <span style="color: #94a3b8; font-size: 14px;">${product.averageRating} / 5</span>
        </div>
    </div>

    <c:if test="${not empty sessionScope.succMsg}">
        <div class="alert-box alert-success"><i class="fas fa-check-circle"></i> ${sessionScope.succMsg}</div>
        <c:remove var="succMsg" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.errorMsg}">
        <div class="alert-box alert-error"><i class="fas fa-exclamation-circle"></i> ${sessionScope.errorMsg}</div>
        <c:remove var="errorMsg" scope="session"/>
    </c:if>

    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
        <!-- Reviews List -->
        <div>
            <c:forEach var="r" items="${reviews}">
                <div class="review-card">
                    <div class="review-header">
                        <span class="reviewer-name"><i class="fas fa-user-circle" style="color: var(--primary); margin-right: 6px;"></i>${r.userName}</span>
                        <span class="review-date">${r.reviewDate}</span>
                    </div>
                    <div class="review-stars">
                        <c:forEach begin="1" end="${r.rating}"><i class="fas fa-star"></i></c:forEach>
                        <c:forEach begin="1" end="${5 - r.rating}"><i class="far fa-star" style="color: #475569;"></i></c:forEach>
                    </div>
                    <p style="color: #cbd5e1; font-size: 14px; line-height: 1.6;">${r.comment}</p>
                </div>
            </c:forEach>
            <c:if test="${empty reviews}">
                <div class="review-empty">
                    <i class="far fa-comment-dots" style="font-size: 2.5rem; color: #334155; display: block; margin-bottom: 10px;"></i>
                    <p style="color: #94a3b8;">No reviews yet. Be the first to review!</p>
                </div>
            </c:if>
        </div>

        <!-- Write Review -->
        <div class="review-form-card">
            <h3 style="margin-bottom: 20px;"><i class="fas fa-pen" style="color: var(--primary); margin-right: 8px;"></i>Write a Review</h3>
            <form action="submit-review" method="post">
                <input type="hidden" name="productId" value="${product.productId}">
                <p class="section-title">Your Rating</p>
                <div class="sizes-grid" style="margin-bottom: 20px;">
                    <c:forEach var="i" begin="1" end="5">
                        <div class="size-option">
                            <input type="radio" name="rating" id="rate-${i}" value="${i}" required>
                            <label for="rate-${i}" style="font-size: 16px;">${i} ★</label>
                        </div>
                    </c:forEach>
                </div>
                <p class="section-title">Your Comment</p>
                <textarea name="comment" rows="4" class="review-textarea"
                    placeholder="Share your experience with this product..."></textarea>
                <button type="submit" class="btn-add" style="width: 100%;">Submit Review</button>
            </form>
        </div>
    </div>
</div>

<%@ include file="partials/footer.jsp" %>

</body>
</html>
