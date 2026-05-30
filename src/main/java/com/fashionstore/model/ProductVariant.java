package com.fashionstore.model;

public class ProductVariant {

    private int variantId;
    private int productId;
    private String size;
    private String color; // Added for color variants
    private int stockQuantity;
    private String imageUrl; // Image for this specific color variant

    public ProductVariant() {
    }

    public ProductVariant(int variantId, int productId, String size, String color, int stockQuantity, String imageUrl) {
        this.variantId = variantId;
        this.productId = productId;
        this.size = size;
        this.color = color;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl;
    }

    public int getVariantId() {
        return variantId;
    }

    public void setVariantId(int variantId) {
        this.variantId = variantId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public String getSize() {
        return size;
    }

    public void setSize(String size) {
        this.size = size;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }
}