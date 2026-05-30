package com.fashionstore.test;

import com.fashionstore.dao.impl.ProductDAOImpl;
import com.fashionstore.model.Product;
import java.util.List;

public class TestDelete {
    public static void main(String[] args) {
        ProductDAOImpl dao = new ProductDAOImpl();
        
        // Find a product to delete (one that we created for testing)
        List<Product> products = dao.getAllProducts();
        if (products != null && !products.isEmpty()) {
            Product toDelete = products.get(0); // Take the latest
            System.out.println("Attempting to delete product: " + toDelete.getProductName() + " (ID: " + toDelete.getProductId() + ")");
            
            boolean success = dao.deleteProduct(toDelete.getProductId());
            System.out.println("Delete Success: " + success);
            
            // Verify
            Product check = dao.getProductById(toDelete.getProductId());
            if (check == null) {
                System.out.println("Verification: Product successfully removed from database.");
            } else {
                System.out.println("Verification: FAILED. Product still exists.");
            }
        } else {
            System.out.println("No products found to delete.");
        }
    }
}
