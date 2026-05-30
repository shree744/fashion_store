package com.fashionstore.model;

import java.sql.Date;

public class Reward {
    private int rewardId;
    private int userId;
    private int points;
    private Date claimDate;
    private int streakCount;

    public Reward() {}

    public int getRewardId() { return rewardId; }
    public void setRewardId(int rewardId) { this.rewardId = rewardId; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getPoints() { return points; }
    public void setPoints(int points) { this.points = points; }

    public Date getClaimDate() { return claimDate; }
    public void setClaimDate(Date claimDate) { this.claimDate = claimDate; }

    public int getStreakCount() { return streakCount; }
    public void setStreakCount(int streakCount) { this.streakCount = streakCount; }
}
