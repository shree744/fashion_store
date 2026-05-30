<%@ page import="com.fashionstore.model.User" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%!
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;").replace("'", "&#39;");
    }
%>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    String message = (String) request.getAttribute("message");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Fashion Store</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { box-sizing: border-box; }
        body { font-family: 'Outfit', sans-serif; background: #060b1e; color: #f8fafc; margin: 0; }
        .profile-page { max-width: 980px; width: 100%; margin: 40px auto 48px; padding: 28px 24px; background: rgba(15, 23, 42, 0.95); border: 1px solid rgba(148, 163, 184, 0.16); border-radius: 28px; box-shadow: 0 24px 70px rgba(0, 0, 0, 0.22); }
        .profile-header { display: flex; justify-content: space-between; align-items: center; gap: 32px; margin-bottom: 40px; flex-wrap: wrap; }
        .profile-header h1 { margin: 0 0 8px; font-size: 34px; line-height: 1.1; }
        .profile-header p { margin: 0; color: #94a3b8; max-width: 600px; line-height: 1.6; }
        .profile-avatar-group { display: flex; align-items: center; gap: 16px; flex-shrink: 0; }
        .profile-avatar { width: 64px; height: 64px; border-radius: 50%; background: rgba(99, 102, 241, 0.18); border: 2px solid rgba(255, 255, 255, 0.14); display: flex; align-items: center; justify-content: center; color: #eef2ff; font-size: 24px; font-weight: 700; }
        .profile-badge { padding: 8px 18px; background: rgba(99, 102, 241, 0.16); border-radius: 999px; border: 1px solid rgba(99, 102, 241, 0.2); color: #e0e7ff; font-weight: 700; white-space: nowrap; font-size: 13px; }
        .profile-grid { display: grid; grid-template-columns: minmax(0, 1.1fr) minmax(0, 0.9fr); gap: 28px; }
        .card { background: rgba(15, 23, 42, 0.98); border: 1px solid rgba(148, 163, 184, 0.12); border-radius: 24px; padding: 28px; box-shadow: 0 25px 50px rgba(0, 0, 0, 0.18); }
        .profile-summary h2, .profile-form h2 { margin: 0 0 20px; font-size: 24px; }
        .summary-row { display: flex; justify-content: space-between; align-items: flex-start; gap: 16px; padding: 14px 0; border-bottom: 1px solid rgba(148, 163, 184, 0.08); }
        .summary-row:last-child { border-bottom: none; }
        .summary-row span { color: #94a3b8; font-size: 14px; flex-shrink: 0; }
        .summary-row strong { text-align: right; color: #f8fafc; word-break: break-word; }
        .profile-form form { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 18px; }
        .form-row { display: flex; flex-direction: column; width: 100%; }
        .form-row.full { grid-column: span 2; }
        .form-row label { margin-bottom: 10px; color: #cbd5e1; font-weight: 600; font-size: 14px; }
        .form-row input { width: 100%; padding: 14px 16px; border-radius: 16px; border: 1px solid rgba(148, 163, 184, 0.18); background: rgba(255, 255, 255, 0.05); color: #f8fafc; min-width: 0; transition: border-color 0.2s ease, box-shadow 0.2s ease; }
        .form-row input:focus { outline: none; border-color: #6366f1; box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.12); }
        .avatar-uploader { display: flex; flex-direction: column; align-items: center; margin-bottom: 20px; }
        .avatar-upload-label { width: 128px; height: 128px; border-radius: 50%; border: 2px solid rgba(148, 163, 184, 0.28); background: rgba(255, 255, 255, 0.05); display: flex; align-items: center; justify-content: center; overflow: hidden; cursor: pointer; position: relative; transition: border-color 0.2s ease, transform 0.2s ease, box-shadow 0.2s ease; }
        .avatar-upload-label:hover { border-color: rgba(99, 102, 241, 0.35); transform: translateY(-2px); box-shadow: 0 18px 36px rgba(0, 0, 0, 0.18); }
        .avatar-preview { width: 100%; height: 100%; object-fit: cover; display: none; }
        .avatar-placeholder { color: #cbd5e1; font-size: 42px; display: flex; align-items: center; justify-content: center; width: 100%; height: 100%; }
        .avatar-helper { margin-top: 18px; color: #94a3b8; font-size: 14px; }
        .avatar-input { display: none; }
        .profile-actions { display: flex; gap: 14px; flex-wrap: wrap; margin-top: 28px; }
        .link-button { color: #cbd5e1; text-decoration: none; font-size: 14px; padding: 12px 0; }
        .btn-primary { max-width: 240px; }

        .identity-badge {
            position: absolute; 
            color: #a855f7; 
            font-size: 1.5rem; 
            background: #0f172a; 
            border-radius: 50%; 
            padding: 3px; 
            top: -4px; 
            right: -4px; 
            border: 2px solid #0f172a; 
            box-shadow: 0 0 15px rgba(168, 85, 247, 0.4); 
            z-index: 2;
        }

        @media (max-width: 900px) { .profile-grid { grid-template-columns: 1fr; } .profile-header { flex-direction: column; align-items: stretch; } .profile-actions { align-items: stretch; } }
    </style>
</head>
<body>
    <div class="profile-page">
        <div class="profile-header">
            <div>
                <h1>My Profile</h1>
                <p>Review your registration details and keep your contact information up to date.</p>
            </div>
            <div class="profile-avatar-group">
                <div class="profile-avatar" onclick="document.getElementById('profilePictureInput').click()" style="cursor: pointer; position: relative; background: linear-gradient(135deg, rgba(168, 85, 247, 0.2), rgba(99, 102, 241, 0.2));">
                    <c:choose>
                        <c:when test="${not empty user.profileImage}">
                            <img src="${pageContext.request.contextPath}/${user.profileImage}?t=${System.currentTimeMillis()}" 
                                    style="width:100%; height:100%; border-radius:50%; object-fit:cover;" alt="Avatar">
                        </c:when>
                        <c:otherwise>
                            <span style="color: #a855f7; font-size: 2rem; font-weight: 700; text-transform: uppercase;">
                                ${not empty user.fullName ? user.fullName.substring(0,1) : 'U'}
                            </span>
                        </c:otherwise>
                    </c:choose>
                    <div class="avatar-hover-overlay" style="position: absolute; inset: 0; background: rgba(0,0,0,0.4); display: flex; align-items: center; justify-content: center; opacity: 0; transition: 0.3s; border-radius: 50%;">
                        <i class="fas fa-camera" style="color: #fff; font-size: 1.2rem;"></i>
                    </div>
                    <i class="fas fa-shield-alt identity-badge"></i>
                </div>
                <style>.profile-avatar:hover .avatar-hover-overlay { opacity: 1; }</style>
                <form id="avatarForm" action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data" style="display: none;">
                    <input type="file" id="profilePictureInput" name="profileImage" onchange="this.form.submit()">
                </form>
                <div class="profile-badge">Customer</div>
            </div>
        </div>

        <c:if test="${not empty message}">
            <div class="alert alert-success"><%= esc(message) %></div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="alert alert-error"><%= esc(error) %></div>
        </c:if>

        <div class="profile-grid">
            <section class="profile-summary card">
                <h2>Registration Details</h2>
                <div class="summary-row"><span>Full Name</span><strong><%= esc(user.getFullName()) %></strong></div>
                <div class="summary-row"><span>Email</span><strong><%= esc(user.getEmail()) %></strong></div>
                <div class="summary-row"><span>Phone</span><strong><%= esc(user.getPhone()) %></strong></div>
                <div class="summary-row"><span>Address</span><strong><%= esc(user.getAddressLine1()) %><br/><%= esc(user.getAddressLine2()) %></strong></div>
                <div class="summary-row"><span>City</span><strong><%= esc(user.getCity()) %></strong></div>
                <div class="summary-row"><span>State</span><strong><%= esc(user.getState()) %></strong></div>
                <div class="summary-row"><span>Pin Code</span><strong><%= esc(user.getPincode()) %></strong></div>
                <div class="summary-row"><span>Country</span><strong><%= esc(user.getCountry()) %></strong></div>
            </section>

            <section class="profile-form card">
                <h2>Edit Profile</h2>
                <form action="${pageContext.request.contextPath}/profile" method="post" enctype="multipart/form-data">

                    <div class="form-row full"><label for="fullName">Full Name</label><input type="text" id="fullName" name="fullName" value="<%= esc(user.getFullName()) %>" required /></div>
                    <div class="form-row half"><label for="phone">Phone</label><input type="text" id="phone" name="phone" value="<%= esc(user.getPhone()) %>" /></div>
                    <div class="form-row full"><label for="addressLine1">Address Line 1</label><input type="text" id="addressLine1" name="addressLine1" value="<%= esc(user.getAddressLine1()) %>" /></div>
                    <div class="form-row full"><label for="addressLine2">Address Line 2</label><input type="text" id="addressLine2" name="addressLine2" value="<%= esc(user.getAddressLine2()) %>" /></div>
                    <div class="form-row half"><label for="city">City</label><input type="text" id="city" name="city" value="<%= esc(user.getCity()) %>" /></div>
                    <div class="form-row half"><label for="state">State</label><input type="text" id="state" name="state" value="<%= esc(user.getState()) %>" /></div>
                    <div class="form-row half"><label for="pincode">Pin Code</label><input type="text" id="pincode" name="pincode" value="<%= esc(user.getPincode()) %>" /></div>
                    <div class="form-row half"><label for="country">Country</label><input type="text" id="country" name="country" value="<%= esc(user.getCountry()) %>" /></div>
                    <div class="form-row full"><label for="email">Email</label><input type="email" id="email" value="<%= esc(user.getEmail()) %>" readonly /></div>
                    <div class="form-row full"><button type="submit" class="btn-primary">Save Changes</button></div>
                </form>
            </section>
        </div>

        <div class="profile-actions">
            <a class="link-button" href="${pageContext.request.contextPath}/home">Back to Store</a>
            <a class="link-button" href="${pageContext.request.contextPath}/logout">Logout</a>
        </div>
    </div>
    <script>
        const avatarInput = document.getElementById('avatarUpload');
        const avatarPreview = document.getElementById('avatarPreview');
        const avatarPlaceholder = document.getElementById('avatarPlaceholder');

        if (avatarInput) {
            avatarInput.addEventListener('change', event => {
                const file = event.target.files[0];
                if (!file) return;
                const reader = new FileReader();
                reader.onload = function(e) {
                    avatarPreview.src = e.target.result;
                    avatarPreview.style.display = 'block';
                    avatarPlaceholder.style.display = 'none';
                };
                reader.readAsDataURL(file);
            });
        }
    </script>
</body>
</html>
