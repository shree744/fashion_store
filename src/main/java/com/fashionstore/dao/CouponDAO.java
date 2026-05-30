package com.fashionstore.dao;

import com.fashionstore.model.Coupon;
import java.util.List;

public interface CouponDAO {
    boolean addCoupon(Coupon coupon);
    Coupon getCouponByCode(String code);
    List<Coupon> getAllCoupons();
    boolean updateCouponUsage(int couponId);
    boolean updateCoupon(Coupon coupon);
    boolean deleteCoupon(int couponId);
}
