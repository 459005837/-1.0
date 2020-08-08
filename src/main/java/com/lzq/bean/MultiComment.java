package com.lzq.bean;

import java.sql.Date;

/**
 * 多级评论的前端数据展示类
 */
public class MultiComment {
    private Integer topperId;
    private Integer upperId;
    private String frontUsername;
    private String behindUsername;
    private String content;
    private Date commentDate;
    private Integer likeNum;
    private String likeChecked;

    public Integer getLikeNum() {
        return likeNum;
    }

    public void setLikeNum(Integer likeNum) {
        this.likeNum = likeNum;
    }

    public String getLikeChecked() {
        return likeChecked;
    }

    public void setLikeChecked(String likeChecked) {
        this.likeChecked = likeChecked;
    }

    public Integer getTopperId() {
        return topperId;
    }

    public void setTopperId(Integer topperId) {
        this.topperId = topperId;
    }

    public Integer getUpperId() {
        return upperId;
    }

    public void setUpperId(Integer upperId) {
        this.upperId = upperId;
    }


    public Date getCommentDate() {
        return commentDate;
    }

    public void setCommentDate(Date commentDate) {
        this.commentDate = commentDate;
    }

    public String getFrontUsername() {
        return frontUsername;
    }

    public void setFrontUsername(String frontUsername) {
        this.frontUsername = frontUsername;
    }

    public String getBehindUsername() {
        return behindUsername;
    }

    public void setBehindUsername(String behindUsername) {
        this.behindUsername = behindUsername;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
