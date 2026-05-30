package com.fashionstore.model;

public class CartItem {

    private int cartItemId;
    private int userId;
    private int productId;
    private int variantId; // ✅ ADDED
    private int quantity;
    private String size;
    private Product product;

    public int getCartItemId() { return cartItemId; }
    public void setCartItemId(int cartItemId) { this.cartItemId = cartItemId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }

    public int getVariantId() { return variantId; }
    public void setVariantId(int variantId) { this.variantId = variantId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getSize() { return size; }
    public void setSize(String size) { this.size = size; }

    public Product getProduct() { return product; }
    public void setProduct(Product product) { this.product = product; }

    public double getTotalPrice() {
        return product.getPrice() * quantity;
    }
}