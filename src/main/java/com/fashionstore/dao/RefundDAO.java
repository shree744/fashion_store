package com.fashionstore.dao;

import com.fashionstore.model.Refund;
import java.util.List;

public interface RefundDAO {
    boolean requestRefund(Refund refund);
    boolean updateRefundStatus(int refundId, String status);
    List<Refund> getAllRefunds();
    List<Refund> getRefundsByOrderId(int orderId);
    List<Refund> getRefundsByUserId(int userId);
    Refund getRefundById(int refundId);
}
