package com.fashionstore.model;

public class Product {

    private int productId;
    private int categoryId;
    private String productName;
    private String brand;
    private String description;
    private double price;
    private String imageUrl;
    private boolean active;   
    private double averageRating; // Added for reviews
    private java.util.List<ProductVariant> variants; // Added for variant management

    public java.util.List<ProductVariant> getVariants() {
        return variants;
    }

    public void setVariants(java.util.List<ProductVariant> variants) {
        this.variants = variants;
    }

    public Product() {
    }

    public Product(int productId, int categoryId, String productName, String brand,
                   String description, double price, String imageUrl, boolean active, double averageRating) {
        this.productId = productId;
        this.categoryId = categoryId;
        this.productName = productName;
        this.brand = brand;
        this.description = description;
        this.price = price;
        this.imageUrl = imageUrl;
        this.active = active;
        this.averageRating = averageRating;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    // ✅ FIXED BOOLEAN NAMING
    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public double getAverageRating() {
        return averageRating;
    }

    public void setAverageRating(double averageRating) {
        this.averageRating = averageRating;
    }
}