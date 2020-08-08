package com.lzq.po;

import java.sql.Timestamp;

public class Board {
    private Integer boardId;
    private Integer userId;
    private Integer boardUserId;
    private Timestamp boardDate;
    private String content;

    public Integer getBoardId() {
        return boardId;
    }

    public void setBoardId(Integer boardId) {
        this.boardId = boardId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getBoardUserId() {
        return boardUserId;
    }

    public void setBoardUserId(Integer boardUserId) {
        this.boardUserId = boardUserId;
    }

    public Timestamp getBoardDate() {
        return boardDate;
    }

    public void setBoardDate(Timestamp boardDate) {
        this.boardDate = boardDate;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
