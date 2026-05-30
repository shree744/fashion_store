package com.fashionstore.dao;

import com.fashionstore.model.Reward;
import java.util.List;

public interface RewardDAO {
    Reward getRewardByUserId(int userId);
    boolean claimDailyReward(int userId);
    int getPoints(int userId);
    boolean addOrderReward(int userId, int orderId, double orderAmount);
    boolean removeOrderReward(int userId, int orderId);
    boolean isOrderRewarded(int orderId);
    List<java.util.Map<String, Object>> getRewardHistory(int userId);
    int syncMissingOrderRewards(int userId);
}
