package com.lzq.po;

import java.sql.Timestamp;

public class CollectLike {
    private Integer id;
    private Integer articleId;
    private Integer userId;
    private String likeChecked;
    private String collectChecked;
    private Timestamp likeDate;
    private Timestamp collectDate;

    public CollectLike() {
    }

    public CollectLike(Integer id) {
        this.id = id;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getArticleId() {
        return articleId;
    }

    public void setArticleId(Integer articleId) {
        this.articleId = articleId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getLikeChecked() {
        return likeChecked;
    }

    public void setLikeChecked(String likeChecked) {
        this.likeChecked = likeChecked;
    }

    public String getCollectChecked() {
        return collectChecked;
    }

    public void setCollectChecked(String collectChecked) {
        this.collectChecked = collectChecked;
    }

    public Timestamp getLikeDate() {
        return likeDate;
    }

    public void setLikeDate(Timestamp likeDate) {
        this.likeDate = likeDate;
    }

    public Timestamp getCollectDate() {
        return collectDate;
    }

    public void setCollectDate(Timestamp collectDate) {
        this.collectDate = collectDate;
    }
}
