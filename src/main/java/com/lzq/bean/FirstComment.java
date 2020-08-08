package com.lzq.bean;

import java.sql.Date;

/**
 * 一级评论的前端数据展示类
 */
public class FirstComment {
    private String username;
    private String content;
    private Integer commentId;
    private Integer productId;
    private Integer userId;
    private String type;
    private Date commentDate;
    private Integer topperId;
    private Integer upperId;
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

    public Integer getUpperId() {
        return upperId;
    }

    public void setUpperId(Integer upperId) {
        this.upperId = upperId;
    }

    public Integer getTopperId() {
        return topperId;
    }

    public void setTopperId(Integer topperId) {
        this.topperId = topperId;
    }


    public Date getCommentDate() {
        return commentDate;
    }

    public void setCommentDate(Date commentDate) {
        this.commentDate = commentDate;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getCommentId() {
        return commentId;
    }

    public void setCommentId(Integer commentId) {
        this.commentId = commentId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }
}
