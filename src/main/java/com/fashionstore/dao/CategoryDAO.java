package com.fashionstore.dao;

import java.util.List;
import com.fashionstore.model.Category;

public interface CategoryDAO {
    int addCategory(Category category);
    boolean updateCategory(Category category);
    boolean deleteCategory(int categoryId);
    Category getCategoryById(int categoryId);
    Category getCategoryByName(String categoryName);
    List<Category> getAllCategories();
}