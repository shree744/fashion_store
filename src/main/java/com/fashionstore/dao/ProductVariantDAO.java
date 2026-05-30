package com.fashionstore.dao;

import java.util.List;
import com.fashionstore.model.ProductVariant;

public interface ProductVariantDAO {
    int addVariant(ProductVariant variant);
    boolean updateVariant(ProductVariant variant);
    boolean deleteVariant(int variantId);
    ProductVariant getVariantById(int variantId);
    List<ProductVariant> getVariantsByProductId(int productId);
    ProductVariant getVariantByProductIdAndSize(int productId, String size);
    ProductVariant getVariantByProductSizeAndColor(int productId, String size, String color);
    boolean updateStock(int variantId, int stockQuantity);
}