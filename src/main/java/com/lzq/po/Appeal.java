package com.lzq.po;

import java.sql.Timestamp;

public class Appeal {
    private Integer appealId;
    private Integer userId;
    private Integer appealUserId;
    private String appealPhoto;
    private String appealDetail;
    private Timestamp appealDate;


    public Timestamp getAppealDate() {
        return appealDate;
    }

    public void setAppealDate(Timestamp appealDate) {
        this.appealDate = appealDate;
    }

    public Integer getAppealId() {
        return appealId;
    }

    public void setAppealId(Integer appealId) {
        this.appealId = appealId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getAppealUserId() {
        return appealUserId;
    }

    public void setAppealUserId(Integer appealUserId) {
        this.appealUserId = appealUserId;
    }

    public String getAppealPhoto() {
        return appealPhoto;
    }

    public void setAppealPhoto(String appealPhoto) {
        this.appealPhoto = appealPhoto;
    }

    public String getAppealDetail() {
        return appealDetail;
    }

    public void setAppealDetail(String appealDetail) {
        this.appealDetail = appealDetail;
    }
}
