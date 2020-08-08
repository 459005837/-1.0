package com.lzq.bean;

public class ArticleList {
    private Integer articleId;
    private Integer id;
    private String username;
    private String articleTitle;
    private String articleTitlePhoto;
    private String summary;
    private Integer likeNum;
    private Integer commentNum;

    @Override
    public String toString() {
        return "ArticleList{" +
                "articleId=" + articleId +
                ", id=" + id +
                ", username='" + username + '\'' +
                ", articleTitle='" + articleTitle + '\'' +
                ", articleTitlePhoto='" + articleTitlePhoto + '\'' +
                ", summary='" + summary + '\'' +
                ", likeNum=" + likeNum +
                ", commentNum=" + commentNum +
                '}';
    }

    public Integer getArticleId() {
        return articleId;
    }

    public void setArticleId(Integer articleId) {
        this.articleId = articleId;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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

    public String getSummary() {
        return summary;
    }

    public void setSummary(String summary) {
        this.summary = summary;
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
}
