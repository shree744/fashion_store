<%@ taglib prefix="c" uri="jakarta.tags.core" %>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { box-sizing: border-box; }
        body { margin: 0; padding-top: 100px; }
        .navbar {
            position: absolute;
            top: 0;
            left: 0;
            min-width: 100%;
            width: max-content;
            min-height: 80px;
            padding: clamp(10px, 1.5vw, 15px) clamp(2%, 3vw, 4%);
            z-index: 1000;
            background: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: clamp(10px, 2vw, 25px);
            flex-wrap: nowrap;
            font-family: 'Outfit', sans-serif;
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .navbar.scrolled {
            min-height: 70px;
            padding: 5px 3%;
            background: rgba(15, 23, 42, 0.95);
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            border-bottom: 1px solid rgba(99, 102, 241, 0.2);
        }

        .logo a {
            font-size: clamp(20px, 2vw, 28px);
            font-weight: 800;
            color: #fff;
            text-decoration: none;
            background: linear-gradient(135deg, #6366f1, #a855f7);
            background-clip: text;
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            transition: 0.3s;
        }

        .logo a:hover {
            filter: drop-shadow(0 0 8px rgba(168, 85, 247, 0.5));
            transform: scale(1.02);
        }

        .search-bar {
            max-width: clamp(250px, 30vw, 450px);
            width: 100%;
            height: 46px;
            flex-shrink: 1;
            display: flex;
            align-items: center;
            gap: 10px;
            background: rgba(255, 255, 255, 0.04);
            border-radius: 14px;
            padding: 0 12px;
            border: 1px solid rgba(255, 255, 255, 0.08);
            transition: border 0.3s, background 0.3s;
        }

        .search-bar:focus-within {
            border-color: #6366f1;
            background: rgba(255, 255, 255, 0.07);
            box-shadow: 0 0 20px rgba(99, 102, 241, 0.15);
            transform: translateY(-1px);
        }

        .search-bar input,
        .search-bar select {
            background: transparent;
            border: none;
            color: #fff;
            padding: 10px 0;
            outline: none;
            font-size: clamp(12px, 1.2vw, 14px);
        }

        .search-bar select {
            min-width: 80px;
            max-width: 30%;
            color: #fff;
            appearance: none;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 12px;
            padding: 10px 14px;
            border: 1px solid rgba(255, 255, 255, 0.12);
            cursor: pointer;
        }

        .search-bar select option {
            background: #1e293b;
            color: #fff;
            padding: 10px;
        }

        .search-bar button {
            background: transparent;
            border: none;
            color: #6366f1;
            font-weight: 700;
            cursor: pointer;
            padding-left: 10px;
        }

        .search-bar button {
            background: transparent;
            border: none;
            color: #6366f1;
            font-weight: 700;
            cursor: pointer;
            padding-left: 10px;
        }

        .nav-links {
            display: flex;
            gap: clamp(10px, 1.5vw, 20px);
            align-items: center;
            flex-wrap: nowrap;
        }

        .nav-link {
            display: flex;
            align-items: center;
            color: #94a3b8;
            text-decoration: none;
            font-weight: 600;
            font-size: clamp(12px, 1.2vw, 14px);
            transition: all 0.3s ease;
            position: relative;
            padding: clamp(6px, 1vw, 8px) clamp(10px, 1.5vw, 16px);
            border-radius: 12px;
            gap: clamp(4px, 0.8vw, 8px);
            white-space: nowrap;
        }

        .nav-link:hover {
            color: #fff;
            background: rgba(255, 255, 255, 0.05);
        }

        /* Dropdown styling */
        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background: rgba(15, 23, 42, 0.95);
            backdrop-filter: blur(10px);
            min-width: 170px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.5);
            z-index: 1001;
            border-radius: 12px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            overflow: hidden;
            top: 100%;
            left: 0;
            margin-top: 5px;
        }

        .dropdown-content a {
            color: #cbd5e1;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
            font-size: clamp(12px, 1.2vw, 14px);
            transition: 0.3s;
            font-family: 'Outfit', sans-serif;
            white-space: nowrap;
        }

        .dropdown-content a:hover {
            background-color: rgba(255, 255, 255, 0.1);
            color: #fff;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .nav-link i {
            font-size: clamp(0.9rem, 1.1vw, 1.1rem);
            opacity: 0.8;
            transition: 0.3s;
        }

        .nav-link:hover i {
            opacity: 1;
            transform: translateY(-1px);
        }

        .profile-icon {
            width: clamp(36px, 4vw, 48px);
            height: clamp(36px, 4vw, 48px);
            font-size: clamp(0.9rem, 1.2vw, 1.1rem);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.05);
            border: 2px solid var(--role-color, rgba(255, 255, 255, 0.1));
            color: #fff;
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            text-decoration: none;
            box-shadow: 0 0 15px var(--role-glow, transparent);
        }

        .profile-icon:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-2px) scale(1.05);
            box-shadow: 0 0 25px var(--role-glow, rgba(99, 102, 241, 0.3));
            border-color: var(--role-color);
        }



        .nav-link::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 0;
            height: 2px;
            background: linear-gradient(to right, #6366f1, #a855f7);
            transition: 0.3s ease;
            border-radius: 2px;
        }

        .nav-link:hover {
            color: #fff;
            text-shadow: 0 0 10px rgba(255, 255, 255, 0.2);
        }

        .nav-link:hover::after {
            width: 100%;
        }

        .cart-btn {
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.1), rgba(168, 85, 247, 0.1));
            padding: clamp(8px, 1vw, 10px) clamp(12px, 1.8vw, 22px);
            border-radius: 14px;
            color: #fff !important;
            border: 1px solid rgba(99, 102, 241, 0.25);
            font-weight: 700;
            font-size: clamp(12px, 1.2vw, 14px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            transition: 0.4s;
            white-space: nowrap;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .cart-btn:hover {
            background: linear-gradient(135deg, #6366f1, #a855f7);
            border-color: transparent;
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(99, 102, 241, 0.4);
        }

        .auth-btn {
            color: #fff;
            text-decoration: none;
            background: rgba(255, 255, 255, 0.05);
            padding: clamp(8px, 1vw, 10px) clamp(12px, 1.8vw, 20px);
            border-radius: 12px;
            font-weight: 600;
            font-size: clamp(12px, 1.2vw, 14px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            transition: 0.3s;
            white-space: nowrap;
            display: flex;
            align-items: center;
        }

        .auth-btn:hover {
            background: rgba(255, 255, 255, 0.1);
            border-color: rgba(255, 255, 255, 0.2);
        }

    </style>

    <script>
        window.addEventListener('scroll', () => {
            const navbar = document.querySelector('.navbar');
            if (window.scrollY > 50) {
                navbar.classList.add('scrolled');
            } else {
                navbar.classList.remove('scrolled');
            }
        });
    </script>

    <header class="navbar">
        <div class="logo">
            <a href="${pageContext.request.contextPath}/home">Fashion Store</a>
        </div>

        <form class="search-bar" action="${pageContext.request.contextPath}/products" method="get">
            <select name="categoryId">
                <option value="" <%= request.getParameter("categoryId") == null || request.getParameter("categoryId").isEmpty() ? "selected" : "" %>>All</option>
                <option value="1" <%= "1".equals(request.getParameter("categoryId")) ? "selected" : "" %>>Men</option>
                <option value="2" <%= "2".equals(request.getParameter("categoryId")) ? "selected" : "" %>>Women</option>
                <option value="3" <%= "3".equals(request.getParameter("categoryId")) ? "selected" : "" %>>Kids</option>
            </select>
            <input type="text" name="keyword" placeholder="Search trends..." value="<%= request.getParameter("keyword") != null ? request.getParameter("keyword") : "" %>" />
            <button type="submit">Search</button>
        </form>

        <nav class="nav-links">
            <a href="${pageContext.request.contextPath}/home" class="nav-link"><i class="fas fa-home"></i>Home</a>
            <a href="${pageContext.request.contextPath}/products" class="nav-link"><i class="fas fa-compass"></i>Explore</a>
            <c:if test="${not empty admin}">
                <a href="${pageContext.request.contextPath}/admin-dashboard" class="nav-link" style="color: #6366f1;"><i class="fas fa-user-shield"></i>Admin Panel</a>
            </c:if>
            <c:if test="${not empty user}">
                <div class="dropdown">
                    <a href="javascript:void(0)" class="nav-link"><i class="fas fa-box-open"></i>Order Details <i class="fas fa-caret-down" style="margin-left: 5px;"></i></a>
                    <div class="dropdown-content">
                        <a href="claim-reward"><i class="fas fa-gift" style="color: #fbbf24; margin-right: 8px;"></i>Rewards</a>
                        <a href="order-history"><i class="fas fa-history" style="margin-right: 8px;"></i>My Orders</a>
                        <a href="refund?action=view_all"><i class="fas fa-undo-alt" style="margin-right: 8px;"></i>My Refunds</a>
                    </div>
                </div>
                <a href="${pageContext.request.contextPath}/cart" class="cart-btn"><i class="fas fa-shopping-cart"></i>Cart</a>
            </c:if>
            <c:if test="${not empty user}">
                <c:set var="roleColor" value="#a855f7" />
                <c:set var="roleGlow" value="rgba(168, 85, 247, 0.3)" />
                <a href="${pageContext.request.contextPath}/profile" 
                   class="profile-icon" title="Profile"
                   style="--role-color: ${roleColor}; --role-glow: ${roleGlow};">
                    <c:choose>
                        <c:when test="${not empty user.profileImage}">
                            <img src="${pageContext.request.contextPath}/${user.profileImage}" style="width: 100%; height: 100%; border-radius: 50%; object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                            <span style="color: var(--role-color); font-size: 1.1rem; font-weight: 800; text-transform: uppercase;">
                                ${user.fullName.substring(0,1)}
                            </span>
                        </c:otherwise>
                    </c:choose>
                </a>
            </c:if>
            <c:choose>
                <c:when test="${empty user}">
                    <a href="${pageContext.request.contextPath}/login" class="auth-btn">Login</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/logout" 
                       class="auth-btn" style="color: #fca5a5;">
                        <i class="fas fa-sign-out-alt" style="margin-right: 8px;"></i>Logout
                    </a>
                </c:otherwise>
            </c:choose>
        </nav>

    </header>