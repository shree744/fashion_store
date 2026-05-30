<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Coupons | FashionStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #6366f1; --bg: #0f172a; --card-bg: rgba(30, 41, 59, 0.7); --text: #f8fafc; --danger: #ef4444; --success: #10b981; }
        body { font-family: 'Outfit', sans-serif; background: #0f172a; color: var(--text); margin: 0; display: flex; min-height: 100vh; }
        .main-content { flex: 1; padding: 2.5rem 3.5rem; margin-left: 280px; max-width: calc(100vw - 280px - 4rem); }
        
        h1 { font-size: 2.25rem; font-weight: 700; margin-bottom: 2rem; letter-spacing: -0.025em; }
        .card { background: var(--card-bg); border-radius: 24px; padding: 2rem; border: 1px solid rgba(255,255,255,0.1); margin-bottom: 2rem; backdrop-filter: blur(10px); }
        
        input, select { 
            width: 100%; padding: 0.75rem 1rem; background: rgba(15, 23, 42, 0.5); border: 1px solid rgba(255,255,255,0.1); 
            border-radius: 12px; color: white; margin-bottom: 1rem; transition: 0.3s; font-family: inherit;
        }
        input:focus, select:focus { outline: none; border-color: var(--primary); background: rgba(15, 23, 42, 0.8); }
        
        .btn { 
            background: var(--primary); color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 12px; 
            cursor: pointer; transition: 0.3s; font-weight: 600; display: inline-flex; align-items: center; gap: 8px;
        }
        .btn:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(99, 102, 241, 0.3); }
        .btn-secondary { background: rgba(255,255,255,0.1); color: #fff; }
        .btn-secondary:hover { background: rgba(255,255,255,0.2); }
        
        table { width: 100%; border-collapse: collapse; margin-top: 1rem; }
        th { text-align: left; padding: 1rem; color: #94a3b8; border-bottom: 1px solid rgba(255,255,255,0.1); text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; }
        td { padding: 1rem; border-bottom: 1px solid rgba(255,255,255,0.05); }
        
        .action-btns { display: flex; gap: 8px; }
        .edit-btn { color: var(--primary); background: rgba(99, 102, 241, 0.1); padding: 8px; border-radius: 8px; transition: 0.3s; cursor: pointer; }
        .edit-btn:hover { background: var(--primary); color: white; }
        .delete-btn { color: var(--danger); background: rgba(239, 68, 68, 0.1); padding: 8px; border-radius: 8px; transition: 0.3s; cursor: pointer; text-decoration: none; }
        .delete-btn:hover { background: var(--danger); color: white; }
        
        .usage-bar-fill { height: 100%; background: var(--primary); border-radius: 3px; transition: width 0.5s ease; }
    </style>
</head>
<body>
    <jsp:include page="partials/sidebar.jsp">
        <jsp:param name="activePage" value="coupons" />
    </jsp:include>

    <div class="main-content">
        <h1>Manage Coupons</h1>

        <c:if test="${not empty param.success}">
            <div style="background: rgba(16, 185, 129, 0.1); border: 1px solid rgba(16, 185, 129, 0.2); color: #34d399; padding: 1rem; border-radius: 12px; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-check-circle"></i> ${param.success}
            </div>
        </c:if>
        <c:if test="${not empty param.error}">
            <div style="background: rgba(239, 68, 68, 0.1); border: 1px solid rgba(239, 68, 68, 0.2); color: #fca5a5; padding: 1rem; border-radius: 12px; margin-bottom: 1.5rem; display: flex; align-items: center; gap: 10px;">
                <i class="fas fa-exclamation-circle"></i> ${param.error}
            </div>
        </c:if>

        <div class="card">
            <h3 id="form-title" style="margin-bottom: 1.5rem;">Create New Coupon</h3>
            <form action="admin-coupons" method="post" id="coupon-form">
                <input type="hidden" name="action" id="form-action" value="add">
                <input type="hidden" name="id" id="coupon-id">
                
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1.25rem;">
                    <div class="form-group">
                        <label style="display: block; margin-bottom: 8px; color: #94a3b8; font-size: 0.85rem;">Coupon Code</label>
                        <input type="text" name="code" id="c-code" placeholder="e.g. SUMMER50" required>
                    </div>
                    <div class="form-group">
                        <label style="display: block; margin-bottom: 8px; color: #94a3b8; font-size: 0.85rem;">Discount Type</label>
                        <select name="type" id="c-type">
                            <option value="PERCENTAGE">Percentage (%)</option>
                            <option value="FLAT">Flat Amount (&#8377;)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label style="display: block; margin-bottom: 8px; color: #94a3b8; font-size: 0.85rem;">Discount Value</label>
                        <input type="number" step="0.01" name="value" id="c-value" placeholder="Value" required>
                    </div>
                    <div class="form-group">
                        <label style="display: block; margin-bottom: 8px; color: #94a3b8; font-size: 0.85rem;">Expiry Date</label>
                        <input type="date" name="expiry" id="c-expiry" required>
                    </div>
                    <div class="form-group">
                        <label style="display: block; margin-bottom: 8px; color: #94a3b8; font-size: 0.85rem;">Usage Limit</label>
                        <input type="number" name="limit" id="c-limit" placeholder="Max uses" required>
                    </div>
                </div>
                
                <div style="display: flex; gap: 1rem; margin-top: 0.5rem;">
                    <button type="submit" class="btn" id="submit-btn"><i class="fas fa-plus"></i> Create Coupon</button>
                    <button type="button" class="btn btn-secondary" id="cancel-btn" style="display: none;" onclick="resetForm()">Cancel Edit</button>
                </div>
            </form>
        </div>

        <div class="card">
            <h3 style="margin-bottom: 1.5rem;">Existing Coupons</h3>
            <table>
                <thead>
                    <tr>
                        <th>Code</th>
                        <th>Type</th>
                        <th>Value</th>
                        <th>Expiry</th>
                        <th>Status</th>
                        <th>Usage</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${coupons}">
                        <jsp:useBean id="now" class="java.util.Date" />
                        <tr>
                            <td><strong style="color: #fff; font-size: 1.1rem; letter-spacing: 0.5px;">${c.code}</strong></td>
                            <td><span style="background: rgba(255,255,255,0.05); padding: 4px 10px; border-radius: 6px; font-size: 0.85rem;">${c.discountType}</span></td>
                            <td><span style="color: var(--success); font-weight: 600;">
                                <c:choose>
                                    <c:when test="${c.discountType == 'PERCENTAGE'}">${c.discountValue}%</c:when>
                                    <c:otherwise>&#8377;${c.discountValue}</c:otherwise>
                                </c:choose>
                            </span></td>
                            <td><i class="far fa-calendar-alt" style="margin-right: 6px; color: #94a3b8;"></i> ${c.expiryDate}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${c.valid}">
                                        <span style="background: rgba(16, 185, 129, 0.1); color: #34d399; padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 600;">ACTIVE</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="background: rgba(239, 68, 68, 0.1); color: #fca5a5; padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 600;">EXPIRED</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div style="display: flex; align-items: center; gap: 8px;">
                                    <c:set var="usagePct" value="0%" />
                                    <c:if test="${c.usageLimit gt 0}">
                                        <c:set var="usagePct" value="${c.usedCount * 100 / c.usageLimit}%" />
                                    </c:if>
                                    <div style="flex: 1; height: 6px; background: rgba(255,255,255,0.05); border-radius: 3px; min-width: 60px;">
                                        <div class="usage-bar-fill" data-pct="${usagePct}"></div>
                                    </div>
                                    <span style="font-size: 0.85rem; color: #94a3b8;">${c.usedCount}/${c.usageLimit}</span>
                                </div>
                            </td>
                            <td>
                                <div class="action-btns">
                                    <div class="edit-btn" title="Edit Coupon" 
                                         data-id="${c.couponId}" 
                                         data-code="${c.code}" 
                                         data-type="${c.discountType}" 
                                         data-value="${c.discountValue}" 
                                         data-expiry="${c.expiryDate}" 
                                         data-limit="${c.usageLimit}"
                                         onclick="handleEdit(this)">
                                        <i class="fas fa-edit"></i>
                                    </div>
                                    <a href="admin-coupons?action=delete&id=${c.couponId}" class="delete-btn" title="Delete Coupon" 
                                       onclick="return confirm('Are you sure you want to delete this coupon?')">
                                        <i class="fas fa-trash"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        // Set progress bar widths on load
        document.addEventListener('DOMContentLoaded', () => {
            document.querySelectorAll('.usage-bar-fill').forEach(el => {
                el.style.width = el.getAttribute('data-pct');
            });
        });

        function handleEdit(btn) {
            const data = btn.dataset;
            editCoupon(data.id, data.code, data.type, data.value, data.expiry, data.limit);
        }

        function editCoupon(id, code, type, value, expiry, limit) {
            document.getElementById('form-title').innerText = 'Edit Coupon: ' + code;
            document.getElementById('form-action').value = 'update';
            document.getElementById('coupon-id').value = id;
            
            document.getElementById('c-code').value = code;
            document.getElementById('c-type').value = type;
            document.getElementById('c-value').value = value;
            document.getElementById('c-expiry').value = expiry;
            document.getElementById('c-limit').value = limit;
            
            document.getElementById('submit-btn').innerHTML = '<i class="fas fa-save"></i> Save Changes';
            document.getElementById('cancel-btn').style.display = 'inline-flex';
            
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function resetForm() {
            document.getElementById('form-title').innerText = 'Create New Coupon';
            document.getElementById('form-action').value = 'add';
            document.getElementById('coupon-form').reset();
            
            document.getElementById('submit-btn').innerHTML = '<i class="fas fa-plus"></i> Create Coupon';
            document.getElementById('cancel-btn').style.display = 'none';
        }
    </script>
</body>
</html>
