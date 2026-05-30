package com.fashionstore.model;

import java.sql.Timestamp;

public class Refund {
    private int refundId;
    private int orderId;
    private String status; // Requested, Approved, Processing, Refunded
    private String reason;
    private Timestamp requestDate;
    private Timestamp processedDate;

    public Refund() {}

    public int getRefundId() { return refundId; }
    public void setRefundId(int refundId) { this.refundId = refundId; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public Timestamp getRequestDate() { return requestDate; }
    public void setRequestDate(Timestamp requestDate) { this.requestDate = requestDate; }

    public Timestamp getProcessedDate() { return processedDate; }
    public void setProcessedDate(Timestamp processedDate) { this.processedDate = processedDate; }
}
