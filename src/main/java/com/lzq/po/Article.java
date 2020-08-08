package com.lzq.po;

import java.sql.Timestamp;

public class Article {
    private Integer articleId;
    private Integer typeId;
    private Integer userId;
    private String content;
    private String articleTitle;
    private String articleTitlePhoto;
    private Timestamp updateDate;
    private String time;
    private Integer likeNum;
    private Integer commentNum;
    private Integer collectNum;
    private String summary;
    private String keyWord;
    private String articleChecked;
    private Integer uploadChecked;
    private String mdDb;
    private Timestamp articleDate;

    public Timestamp getArticleDate() {
        return articleDate;
    }

    public void setArticleDate(Timestamp articleDate) {
        this.articleDate = articleDate;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public String getMdDb() {
        return mdDb;
    }

    public void setMdDb(String mdDb) {
        this.mdDb = mdDb;
    }

    public Integer getUploadChecked() {
        return uploadChecked;
    }

    public void setUploadChecked(Integer uploadChecked) {
        this.uploadChecked = uploadChecked;
    }

    public String getArticleChecked() {
        return articleChecked;
    }

    public void setArticleChecked(String articleChecked) {
        this.articleChecked = articleChecked;
    }

    public String getKeyWord() {
        return keyWord;
    }

    public void setKeyWord(String keyWord) {
        this.keyWord = keyWord;
    }

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
    }

    public Integer getArticleId() {
        return articleId;
    }

    public void setArticleId(Integer articleId) {
        this.articleId = articleId;
    }

    public Integer getTypeId() {
        return typeId;
    }

    public void setTypeId(Integer typeId) {
        this.typeId = typeId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getArticleTitle() {
        return articleTitle;
    }

    public void setArticleTitle(String articleTitle) {
        this.articleTitle = articleTitle;
    }

    public String getArticleTitlePhoto() {
        return articleTitlePhoto;
    }

    public void setArticleTitlePhoto(String articleTitlePhoto) {
        this.articleTitlePhoto = articleTitlePhoto;
    }


    public Timestamp getUpdateDate() {
        return updateDate;
    }

    public void setUpdateDate(Timestamp updateDate) {
        this.updateDate = updateDate;
    }

    public Integer getLikeNum() {
        return likeNum;
    }

    public void setLikeNum(Integer likeNum) {
        this.likeNum = likeNum;
    }

    public Integer getCommentNum() {
        return commentNum;
    }

    public void setCommentNum(Integer commentNum) {
        this.commentNum = commentNum;
    }

    public Integer getCollectNum() {
        return collectNum;
    }

    public void setCollectNum(Integer collectNum) {
        this.collectNum = collectNum;
    }
}
