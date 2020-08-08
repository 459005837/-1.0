package com.lzq.bean;

public class UserNums {
    private Integer userId;
    private String username;
    private String headAddress;
    private Integer followsNum;
    private Integer fansNum;
    private Integer ArticlesNum;
    private Integer likesNum;
    private String  checked;

    public String getChecked() {
        return checked;
    }

    public void setChecked(String checked) {
        this.checked = checked;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getHeadAddress() {
        return headAddress;
    }

    public void setHeadAddress(String headAddress) {
        this.headAddress = headAddress;
    }

    public Integer getFollowsNum() {
        return followsNum;
    }

    public void setFollowsNum(Integer followsNum) {
        this.followsNum = followsNum;
    }

    public Integer getFansNum() {
        return fansNum;
    }

    public void setFansNum(Integer fansNum) {
        this.fansNum = fansNum;
    }

    public Integer getArticlesNum() {
        return ArticlesNum;
    }

    public void setArticlesNum(Integer articlesNum) {
        ArticlesNum = articlesNum;
    }

    public Integer getLikesNum() {
        return likesNum;
    }

    public void setLikesNum(Integer likesNum) {
        this.likesNum = likesNum;
    }
}
