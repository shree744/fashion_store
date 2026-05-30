<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<div class="mobile-header">
    <h2 style="margin: 0; font-size: 1.4rem; letter-spacing: -0.5px;">
        Fashion<span style="color: var(--primary);">Store</span>
    </h2>
    <button class="hamburger-btn" onclick="toggleSidebar()">
        <i class="fas fa-bars"></i>
    </button>
</div>

<div class="sidebar">
    <div class="sidebar-header">
        <h2 style="padding: 0 1rem; margin-bottom: 2.5rem; font-size: 1.8rem; letter-spacing: -0.5px;">
            Fashion<span style="color: var(--primary);">Store</span>
        </h2>
    </div>
    
    <div class="nav-list">
        <a href="admin-dashboard" class="nav-link ${param.activePage == 'dashboard' ? 'active' : ''}">
            <i class="fas fa-chart-line"></i> Dashboard
        </a>
        <a href="admin-products" class="nav-link ${param.activePage == 'products' ? 'active' : ''}">
            <i class="fas fa-tshirt"></i> Products
        </a>
        <a href="admin-orders" class="nav-link ${param.activePage == 'orders' ? 'active' : ''}">
            <i class="fas fa-shopping-bag"></i> Orders
        </a>
        <a href="admin-faq" class="nav-link ${param.activePage == 'faq' ? 'active' : ''}">
            <i class="fas fa-question-circle"></i> FAQ Management
        </a>
        <a href="admin-coupons" class="nav-link ${param.activePage == 'coupons' ? 'active' : ''}">
            <i class="fas fa-ticket-alt"></i> Coupons
        </a>
        <a href="admin-profile" class="nav-link ${param.activePage == 'profile' ? 'active' : ''}">
            <i class="fas fa-user-cog"></i> Profile Settings
        </a>
        <a href="refund?action=admin-list" class="nav-link ${param.activePage == 'refunds' ? 'active' : ''}">
            <i class="fas fa-undo"></i> Refund Requests
        </a>
    </div>

    <div class="sidebar-divider" style="margin: 2rem 1rem; height: 1px; background: rgba(255,255,255,0.1);"></div>

    <div class="nav-list">
        <a href="home" class="nav-link" style="color: #94a3b8;">
            <i class="fas fa-external-link-alt"></i> View Store
        </a>
        <a href="admin-logout" class="nav-link logout-link">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </div>


</div>

<style>
    :root {
        --sidebar-width: 280px;
        --sidebar-padding: 2rem 1.5rem;
    }

    .sidebar-badge-shield {
        position: absolute; 
        color: #6366f1; 
        font-size: 0.75rem;
        background: #1e293b;
        border-radius: 50%;
        padding: 2px;
        border: 2px solid #1e293b;
        box-shadow: 0 0 10px rgba(99, 102, 241, 0.3);
        top: var(--badge-top, -1px);
        right: var(--badge-right, -1px);
        z-index: 2;
    }

    .sidebar {
        box-sizing: border-box;
        width: var(--sidebar-width);
        background: rgba(15, 23, 42, 0.95);
        backdrop-filter: blur(20px);
        height: 100vh;
        padding: var(--sidebar-padding);
        border-right: 1px solid rgba(255, 255, 255, 0.1);
        position: fixed;
        left: 0;
        top: 0;
        display: flex;
        flex-direction: column;
        transition: none;
        overflow-y: auto;
    }

    .sidebar::-webkit-scrollbar {
        width: 6px;
    }
    .sidebar::-webkit-scrollbar-track {
        background: transparent;
    }
    .sidebar::-webkit-scrollbar-thumb {
        background: rgba(99, 102, 241, 0.3);
        border-radius: 10px;
    }
    .sidebar::-webkit-scrollbar-thumb:hover {
        background: rgba(99, 102, 241, 0.6);
    }

    .nav-link {
        display: flex;
        align-items: center;
        padding: 0.85rem 1.25rem;
        color: #94a3b8;
        text-decoration: none;
        border-radius: 14px;
        margin-bottom: 0.5rem;
        transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        font-weight: 500;
        font-size: 0.95rem;
    }

    .nav-link i {
        margin-right: 1.25rem;
        font-size: 1.1rem;
        width: 20px;
        text-align: center;
    }

    .nav-link:hover {
        background: rgba(255, 255, 255, 0.05);
        color: #fff;
        transform: translateX(5px);
    }

    .nav-link.active {
        background: linear-gradient(135deg, var(--primary), var(--secondary, #a855f7));
        color: white;
        box-shadow: 0 10px 20px rgba(99, 102, 241, 0.3);
    }

    .logout-link {
        color: #fca5a5 !important;
        margin-top: 0.5rem;
    }

    .logout-link:hover {
        background: rgba(239, 68, 68, 0.1);
    }



    .admin-badge {
        position: absolute;
        top: 2rem;
        right: 3.5rem;
        z-index: 1000;
        background: rgba(15, 23, 42, 0.85);
        backdrop-filter: blur(12px);
        -webkit-backdrop-filter: blur(12px);
        border: 1px solid rgba(255, 255, 255, 0.1);
        padding: 0.5rem 1.25rem 0.5rem 0.5rem;
        border-radius: 50px;
        display: flex;
        align-items: center;
        gap: 12px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        text-decoration: none;
        transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    .admin-badge:hover {
        transform: scale(1.05);
    }

    .badge-icon {
        width: 44px;
        height: 44px;
        background: linear-gradient(135deg, var(--primary), var(--secondary, #a855f7));
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 1.2rem;
    }

    .badge-info {
        display: flex;
        flex-direction: column;
    }

    .badge-info span {
        font-size: 0.75rem;
        color: #94a3b8;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .badge-info strong {
        font-size: 0.95rem;
        color: #fff;
        font-weight: 600;
    }
    .mobile-header {
        display: none;
        align-items: center;
        justify-content: space-between;
        padding: 1rem 1.5rem;
        background: rgba(15, 23, 42, 0.95);
        backdrop-filter: blur(20px);
        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        position: sticky;
        top: 0;
        z-index: 1000;
    }
    
    .hamburger-btn {
        background: transparent;
        border: none;
        color: #f8fafc;
        font-size: 1.5rem;
        cursor: pointer;
    }

    @media (max-width: 1024px) {
        .mobile-header { display: flex; }
        .sidebar { transform: translateX(-100%); transition: transform 0.3s ease; z-index: 2000; }
        .sidebar.active { transform: translateX(0); }
        .main-content { margin-left: 0; max-width: 100%; padding: 1.5rem !important; }
        .admin-badge { top: 4.5rem; right: 1.5rem; padding: 0.5rem; }
        .admin-badge .badge-info { display: none; }
        .stats-grid { grid-template-columns: 1fr !important; }
    }
    
    @media (max-width: 768px) {
        .admin-badge { display: none; } /* Hide floating badge on very small screens to save space */
    }
</style>
<script>
    function toggleSidebar() {
        document.querySelector('.sidebar').classList.toggle('active');
    }
</script>

<a href="admin-profile" class="admin-badge">
    <div class="badge-icon">
        <i class="fas fa-user-shield"></i>
    </div>
    <div class="badge-info">
        <span>Administrator</span>
        <strong>${not empty admin.fullName ? admin.fullName : 'Admin'}</strong>
    </div>
</a>
