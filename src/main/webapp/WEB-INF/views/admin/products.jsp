<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Products | FashionStore</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root { --primary: #6366f1; --bg: #0f172a; --card-bg: rgba(30, 41, 59, 0.7); --text: #f8fafc; --danger: #ef4444; --success: #10b981; }
        body { font-family: 'Outfit', sans-serif; background: #0f172a; color: var(--text); margin: 0; display: flex; }
        .main-content { flex: 1; padding: 2.5rem 3.5rem; margin-left: 280px; max-width: calc(100vw - 280px - 4rem); }
        
        h1 { font-size: 2.25rem; font-weight: 700; margin-bottom: 2rem; letter-spacing: -0.025em; }
        .card { background: var(--card-bg); border-radius: 24px; padding: 2rem; border: 1px solid rgba(255,255,255,0.1); margin-bottom: 2rem; backdrop-filter: blur(10px); }
        .btn { background: var(--primary); color: white; border: none; padding: 0.75rem 1.5rem; border-radius: 10px; cursor: pointer; transition: 0.3s; font-weight: 600; }
        .btn:hover { opacity: 0.9; transform: translateY(-2px); box-shadow: 0 4px 12px rgba(99, 102, 241, 0.4); }
        .btn-danger { background: var(--danger); }
        .btn-danger:hover { box-shadow: 0 4px 12px rgba(239, 68, 68, 0.4); }

        input, select, textarea { 
            width: 100%; padding: 0.75rem; background: rgba(15, 23, 42, 0.5); border: 1px solid rgba(255,255,255,0.1); 
            border-radius: 10px; color: white; margin-bottom: 1rem; transition: 0.3s;
        }
        input:focus, select:focus, textarea:focus { outline: none; border-color: var(--primary); background: rgba(15, 23, 42, 0.8); }

        .size-chips { display: flex; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 1rem; }
        .size-chip { 
            padding: 0.5rem 1rem; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); 
            border-radius: 8px; cursor: pointer; transition: 0.3s; font-size: 0.9rem; user-select: none;
        }
        .size-chip:hover { border-color: var(--primary); }
        .size-chip.active { background: var(--primary); border-color: var(--primary); color: white; transform: scale(1.05); }

        table { width: 100%; border-collapse: collapse; }
        th { text-align: left; padding: 1rem; color: #94a3b8; border-bottom: 1px solid rgba(255,255,255,0.1); text-transform: uppercase; font-size: 0.8rem; letter-spacing: 1px; }
        td { padding: 1rem; border-bottom: 1px solid rgba(255,255,255,0.05); }
        .product-img { width: 50px; height: 50px; border-radius: 8px; object-fit: cover; border: 1px solid rgba(255,255,255,0.1); }
        
        /* Toast Notification */
        .toast {
            position: fixed; top: 20px; right: 20px; padding: 1rem 2rem; border-radius: 12px; color: white; 
            z-index: 1000; transform: translateX(150%); transition: 0.5s cubic-bezier(0.68, -0.55, 0.265, 1.55);
            display: flex; align-items: center; gap: 0.8rem; font-weight: 600; box-shadow: 0 10px 25px rgba(0,0,0,0.5);
        }
        .toast.show { transform: translateX(0); }
        .toast-success { background: var(--success); }
        .toast-error { background: var(--danger); }

        /* Modal */
        .modal-overlay {
            position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.8);
            display: none; justify-content: center; align-items: center; z-index: 2000; backdrop-filter: blur(5px);
        }
        .modal { background: #1e293b; padding: 2rem; border-radius: 20px; border: 1px solid rgba(255,255,255,0.1); width: 400px; text-align: center; }
        .modal h3 { margin-top: 0; }
        .modal p { color: #94a3b8; margin-bottom: 2rem; }
        .modal-btns { display: flex; justify-content: center; gap: 1rem; }
    </style>
</head>
<body>
    <jsp:include page="partials/sidebar.jsp">
        <jsp:param name="activePage" value="products" />
    </jsp:include>

    <div class="main-content">
        <h1>Manage Products</h1>

        <div class="card">
            <h3 id="form-title">Add New Product</h3>
            <form action="admin-products" method="post" id="product-form">
                <input type="hidden" name="action" id="form-action" value="add">
                <input type="hidden" name="id" id="product-id">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <input type="text" name="name" id="p-name" placeholder="Product Name" required>
                    <input type="text" name="brand" id="p-brand" placeholder="Brand" required>
                    <select name="categoryId" id="p-category" onchange="updateSizeOptions()">
                        <option value="1">Men's Wear</option>
                        <option value="2">Women's Wear</option>
                        <option value="3">Kids Wear</option>
                        <option value="4">Footwear</option>
                        <option value="5">Belts</option>
                        <option value="6">Accessories</option>
                    </select>
                    <input type="number" step="0.01" name="price" id="p-price" placeholder="Price ($)" required>
                    <input type="text" name="imageUrl" id="p-image" placeholder="Image URL" required>
                    
                    <div id="size-selection-wrapper" style="grid-column: span 2;">
                        <label style="display: block; margin-bottom: 0.5rem; color: #94a3b8; font-size: 0.9rem;">Select Available Sizes:</label>
                        <div class="size-chips" id="size-chips-container">
                            <!-- Chips will be loaded here by JS -->
                        </div>
                        <!-- Hidden inputs for selected sizes will be added here -->
                        <div id="hidden-sizes"></div>
                    </div>

                    <div id="stock-container" style="grid-column: span 2;">
                        <label style="display: block; margin-bottom: 0.5rem; color: #94a3b8; font-size: 0.9rem;">Stock Level (Applied to all sizes):</label>
                        <input type="number" name="stock" id="p-stock" placeholder="Enter fixed stock amount" required>
                    </div>
                </div>
                <textarea name="description" id="p-desc" placeholder="Description" rows="3"></textarea>
                <div style="display: flex; align-items: center; gap: 1rem;">
                    <input type="checkbox" name="active" id="p-active" value="true" checked style="width: auto; margin: 0;"> Active
                </div>
                <div style="display: flex; gap: 1rem; margin-top: 1rem;">
                    <button type="submit" class="btn" id="submit-btn">Add Product</button>
                    <button type="button" class="btn btn-danger" id="cancel-btn" style="display: none;" onclick="resetForm()">Cancel Edit</button>
                </div>
            </form>
        </div>

        <div class="card">
            <h3>Product List</h3>
            <table>
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Brand</th>
                        <th>Price</th>
                        <th>Stock</th>
                        <th>Rating</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="p" items="${products}">
                        <c:set var="currentStock" value="0" />
                        <c:if test="${not empty p.variants}">
                            <c:set var="currentStock" value="${p.variants[0].stockQuantity}" />
                        </c:if>
                        <tr>
                            <td><img src="${p.imageUrl}" class="product-img"></td>
                            <td>${p.productName}</td>
                            <td>${p.brand}</td>
                            <td>₹${p.price}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${currentStock <= 3}">
                                        <span style="background: rgba(239, 68, 68, 0.1); color: var(--danger); padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">
                                            ${currentStock} (Low)
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="background: rgba(16, 185, 129, 0.1); color: var(--success); padding: 4px 10px; border-radius: 20px; font-size: 0.85rem; font-weight: 600;">
                                            ${currentStock}
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td><i class="fas fa-star" style="color: #fbbf24;"></i> ${p.averageRating}</td>
                            <td>${p.active ? 'Active' : 'Inactive'}</td>
                            <td>
                                <c:set var="sizesList" value="" />
                                <c:forEach var="v" items="${p.variants}" varStatus="loop">
                                    <c:set var="sizesList" value="${sizesList}${v.size}${!loop.last ? ',' : ''}" />
                                    <c:if test="${loop.first}"><c:set var="currentStock" value="${v.stockQuantity}" /></c:if>
                                </c:forEach>
                                <button class="btn edit-btn" title="Edit Product"
                                    data-id="${p.productId}"
                                    data-name="<c:out value='${p.productName}' />"
                                    data-brand="<c:out value='${p.brand}' />"
                                    data-category="${p.categoryId}"
                                    data-price="${p.price}"
                                    data-image="${p.imageUrl}"
                                    data-desc="<c:out value='${p.description}' />"
                                    data-active="${p.active}"
                                    data-sizes="${sizesList}"
                                    data-stock="${currentStock}">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn btn-danger delete-btn" title="Delete Product" 
                                    data-id="${p.productId}" 
                                    data-name="<c:out value='${p.productName}' />">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <!-- Confirmation Modal -->
    <div class="modal-overlay" id="delete-modal">
        <div class="modal">
            <i class="fas fa-exclamation-triangle" style="font-size: 3rem; color: var(--danger); margin-bottom: 1rem;"></i>
            <h3>Delete Product?</h3>
            <p id="delete-msg">Are you sure you want to delete this product? This action cannot be undone.</p>
            <div class="modal-btns">
                <button class="btn" onclick="closeModal()">Cancel</button>
                <button class="btn btn-danger" id="confirm-delete-btn">Delete Now</button>
            </div>
        </div>
    </div>

    <!-- Toast Notification -->
    <div id="toast" class="toast">
        <i id="toast-icon" class="fas"></i>
        <span id="toast-msg"></span>
    </div>
    <script>
        const sizeOptions = {
            '1': ['XS', 'S', 'M', 'L', 'XL', 'XXL'], // Men
            '2': ['XS', 'S', 'M', 'L', 'XL', 'XXL'], // Women
            '3': ['XS', 'S', 'M', 'L', 'XL', 'XXL'], // Kids
            '4': ['6', '7', '8', '9', '10', '11'],   // Footwear
            '5': ['30', '32', '34', '36', '38'],     // Belts
            '6': ['Free Size', 'Standard Size']      // Accessories
        };

        let selectedSizes = new Set();

        document.addEventListener('DOMContentLoaded', function() {
            updateSizeOptions();

            // Event delegation for edit and delete buttons
            document.body.addEventListener('click', function(e) {
                const editBtn = e.target.closest('.edit-btn');
                const deleteBtn = e.target.closest('.delete-btn');

                if (editBtn) {
                    editProduct(editBtn);
                } else if (deleteBtn) {
                    confirmDelete(deleteBtn.getAttribute('data-id'), deleteBtn.getAttribute('data-name'));
                }
            });

            // Check for URL parameters to show toasts
            const urlParams = new URLSearchParams(window.location.search);
            if (urlParams.has('success')) showToast(decodeURIComponent(urlParams.get('success')), 'success');
            if (urlParams.has('error')) showToast(decodeURIComponent(urlParams.get('error')), 'error');
        });

        function updateSizeOptions() {
            const categoryId = document.getElementById('p-category').value;
            const container = document.getElementById('size-chips-container');
            container.innerHTML = '';
            selectedSizes.clear();
            updateHiddenInputs();

            if (sizeOptions[categoryId]) {
                sizeOptions[categoryId].forEach(size => {
                    const chip = document.createElement('div');
                    chip.className = 'size-chip';
                    chip.innerText = size;
                    chip.onclick = () => toggleSize(chip, size);
                    container.appendChild(chip);
                });
            }
        }

        function toggleSize(chip, size) {
            if (selectedSizes.has(size)) {
                selectedSizes.delete(size);
                chip.classList.remove('active');
            } else {
                selectedSizes.add(size);
                chip.classList.add('active');
            }
            updateHiddenInputs();
        }

        function updateHiddenInputs() {
            const container = document.getElementById('hidden-sizes');
            container.innerHTML = '';
            selectedSizes.forEach(size => {
                const input = document.createElement('input');
                input.type = 'hidden';
                input.name = 'sizes';
                input.value = size;
                container.appendChild(input);
            });
        }

        function editProduct(btn) {
            document.getElementById('form-title').innerText = 'Edit Product';
            document.getElementById('form-action').value = 'update';
            
            document.getElementById('product-id').value = btn.getAttribute('data-id');
            document.getElementById('p-name').value = btn.getAttribute('data-name');
            document.getElementById('p-brand').value = btn.getAttribute('data-brand');
            const categoryId = btn.getAttribute('data-category');
            document.getElementById('p-category').value = categoryId;
            document.getElementById('p-price').value = btn.getAttribute('data-price');
            document.getElementById('p-image').value = btn.getAttribute('data-image');
            document.getElementById('p-desc').value = btn.getAttribute('data-desc');
            document.getElementById('p-active').checked = btn.getAttribute('data-active') === 'true';
            document.getElementById('p-stock').value = btn.getAttribute('data-stock');
            
            // Re-load size chips based on category
            updateSizeOptions();
            
            // Pre-select existing sizes
            const dataSizes = btn.getAttribute('data-sizes');
            if (dataSizes) {
                const existingSizes = dataSizes.split(',').map(s => s.trim()).filter(s => s !== "");
                const chips = document.querySelectorAll('.size-chip');
                chips.forEach(chip => {
                    if (existingSizes.includes(chip.innerText.trim())) {
                        chip.classList.add('active');
                        selectedSizes.add(chip.innerText.trim());
                    }
                });
            }
            updateHiddenInputs();

            // Show stock container during update
            document.getElementById('stock-container').style.display = 'block';
            document.getElementById('p-stock').required = true;
            document.getElementById('p-stock').placeholder = 'Enter updated stock for all sizes';

            document.getElementById('submit-btn').innerText = 'Update Product';
            document.getElementById('cancel-btn').style.display = 'block';
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function resetForm() {
            document.getElementById('form-title').innerText = 'Add New Product';
            document.getElementById('form-action').value = 'add';
            document.getElementById('product-form').reset();
            
            updateSizeOptions();
            document.getElementById('stock-container').style.display = 'block';
            document.getElementById('p-stock').required = true;
            document.getElementById('p-stock').placeholder = 'Enter fixed stock amount';

            document.getElementById('submit-btn').innerText = 'Add Product';
            document.getElementById('cancel-btn').style.display = 'none';
        }

        function confirmDelete(id, name) {
            const modal = document.getElementById('delete-modal');
            const confirmBtn = document.getElementById('confirm-delete-btn');
            document.getElementById('delete-msg').innerText = "Are you sure you want to delete '" + name + "'? This will also remove all its variants and images.";
            
            modal.style.display = 'flex';
            confirmBtn.onclick = function() {
                window.location.href = 'admin-products?action=delete&id=' + id;
            };
        }

        function closeModal() {
            document.getElementById('delete-modal').style.display = 'none';
        }

        function showToast(msg, type) {
            const toast = document.getElementById('toast');
            const icon = document.getElementById('toast-icon');
            toast.className = 'toast show toast-' + type;
            document.getElementById('toast-msg').innerText = msg;
            icon.className = 'fas ' + (type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle');
            
            setTimeout(() => {
                toast.classList.remove('show');
            }, 4000);
        }
    </script>
</body>
</html>
