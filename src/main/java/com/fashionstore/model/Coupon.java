package com.fashionstore.model;

import java.sql.Date;

public class Coupon {
    private int couponId;
    private String code;
    private String discountType; // PERCENTAGE or FLAT
    private double discountValue;
    private Date expiryDate;
    private int usageLimit;
    private int usedCount;

    public Coupon() {}

    public int getCouponId() { return couponId; }
    public void setCouponId(int couponId) { this.couponId = couponId; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getDiscountType() { return discountType; }
    public void setDiscountType(String discountType) { this.discountType = discountType; }

    public double getDiscountValue() { return discountValue; }
    public void setDiscountValue(double discountValue) { this.discountValue = discountValue; }

    public Date getExpiryDate() { return expiryDate; }
    public void setExpiryDate(Date expiryDate) { this.expiryDate = expiryDate; }

    public int getUsageLimit() { return usageLimit; }
    public void setUsageLimit(int usageLimit) { this.usageLimit = usageLimit; }

    public int getUsedCount() { return usedCount; }
    public void setUsedCount(int usedCount) { this.usedCount = usedCount; }

    public boolean isValid() {
        Date today = new Date(System.currentTimeMillis());
        return !today.after(expiryDate) && usedCount < usageLimit;
    }
}
