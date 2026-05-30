package com.fashionstore.dao;

import com.fashionstore.model.ProductImage;
import java.util.List;

public interface ProductImageDAO {
    boolean addProductImage(ProductImage image);
    List<ProductImage> getImagesByProductId(int productId);
    boolean deleteProductImage(int imageId);
    boolean deleteImagesByProductId(int productId);
}
