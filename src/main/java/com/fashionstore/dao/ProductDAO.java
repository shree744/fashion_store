package com.fashionstore.dao;

import java.util.List;
import com.fashionstore.model.Product;

public interface ProductDAO {

    // ================= BASIC CRUD =================
    int addProduct(Product product);
    boolean updateProduct(Product product);
    boolean deleteProduct(int productId);

    Product getProductById(int productId);
    List<Product> getAllProducts();
    List<Product> getActiveProducts();

    // ================= CATEGORY =================
    List<Product> getProductsByCategoryId(int categoryId);

    // ================= SEARCH =================
    List<Product> searchProducts(String keyword);

    // ================= FILTER =================
    List<Product> filterProducts(Integer categoryId,
                                 String keyword,
                                 Double minPrice,
                                 Double maxPrice,
                                 String sort);   // ✅ FIXED (added sort)

    // ================= STATUS =================
    boolean updateProductStatus(int productId, boolean isActive);

    // ================= LATEST =================
    List<Product> getLatestProducts(int limit);  // ✅ keep only one

    // ================= BRANDS =================
    List<String> getAllBrands();
}