package com.fashionstore.model;

import java.sql.Timestamp;

public class Order {

    private int orderId;
    private int userId;
    private Timestamp orderDate;
    private double totalAmount;
    private String paymentMethod;
    private String orderStatus;
    private String estimatedDeliveryDate; // Added for tracking
    private String trackingStatus;        // Added for tracking
    private String refundStatus;          // Added for synchronization

    private String deliveryName;
    private String deliveryPhone;
    private String deliveryAddressLine1;
    private String deliveryAddressLine2;
    private String deliveryCity;
    private String deliveryState;
    private String deliveryPincode;
    private String deliveryCountry;

    public Order() {
    }

    public Order(int orderId, int userId, Timestamp orderDate, double totalAmount,
                 String paymentMethod, String orderStatus, String estimatedDeliveryDate, String trackingStatus,
                 String deliveryName, String deliveryPhone,
                 String deliveryAddressLine1, String deliveryAddressLine2,
                 String deliveryCity, String deliveryState,
                 String deliveryPincode, String deliveryCountry) {

        this.orderId = orderId;
        this.userId = userId;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.paymentMethod = paymentMethod;
        this.orderStatus = orderStatus;
        this.estimatedDeliveryDate = estimatedDeliveryDate;
        this.trackingStatus = trackingStatus;
        this.deliveryName = deliveryName;
        this.deliveryPhone = deliveryPhone;
        this.deliveryAddressLine1 = deliveryAddressLine1;
        this.deliveryAddressLine2 = deliveryAddressLine2;
        this.deliveryCity = deliveryCity;
        this.deliveryState = deliveryState;
        this.deliveryPincode = deliveryPincode;
        this.deliveryCountry = deliveryCountry;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getDeliveryName() {
        return deliveryName;
    }

    public void setDeliveryName(String deliveryName) {
        this.deliveryName = deliveryName;
    }

    public String getDeliveryPhone() {
        return deliveryPhone;
    }

    public void setDeliveryPhone(String deliveryPhone) {
        this.deliveryPhone = deliveryPhone;
    }

    public String getDeliveryAddressLine1() {
        return deliveryAddressLine1;
    }

    public void setDeliveryAddressLine1(String deliveryAddressLine1) {
        this.deliveryAddressLine1 = deliveryAddressLine1;
    }

    public String getDeliveryAddressLine2() {
        return deliveryAddressLine2;
    }

    public void setDeliveryAddressLine2(String deliveryAddressLine2) {
        this.deliveryAddressLine2 = deliveryAddressLine2;
    }

    public String getDeliveryCity() {
        return deliveryCity;
    }

    public void setDeliveryCity(String deliveryCity) {
        this.deliveryCity = deliveryCity;
    }

    public String getDeliveryState() {
        return deliveryState;
    }

    public void setDeliveryState(String deliveryState) {
        this.deliveryState = deliveryState;
    }

    public String getDeliveryPincode() {
        return deliveryPincode;
    }

    public void setDeliveryPincode(String deliveryPincode) {
        this.deliveryPincode = deliveryPincode;
    }

    public String getDeliveryCountry() {
        return deliveryCountry;
    }

    public void setDeliveryCountry(String deliveryCountry) {
        this.deliveryCountry = deliveryCountry;
    }

    public String getEstimatedDeliveryDate() {
        return estimatedDeliveryDate;
    }

    public void setEstimatedDeliveryDate(String estimatedDeliveryDate) {
        this.estimatedDeliveryDate = estimatedDeliveryDate;
    }

    public String getTrackingStatus() {
        return trackingStatus;
    }

    public void setTrackingStatus(String trackingStatus) {
        this.trackingStatus = trackingStatus;
    }

    public String getRefundStatus() {
        return refundStatus;
    }

    public void setRefundStatus(String refundStatus) {
        this.refundStatus = refundStatus;
    }
}