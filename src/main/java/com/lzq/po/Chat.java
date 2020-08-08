package com.lzq.po;

import java.sql.Timestamp;

public class Chat {
    private Integer chatId;
    private Integer userId;
    private Integer chatUserId;
    private Timestamp addDate;
    private Integer chatTypeId;
    private Integer userChecked;
    private Integer chatUserChecked;


    public Integer getUserChecked() {
        return userChecked;
    }

    public void setUserChecked(Integer userChecked) {
        this.userChecked = userChecked;
    }

    public Integer getChatUserChecked() {
        return chatUserChecked;
    }

    public void setChatUserChecked(Integer chatUserChecked) {
        this.chatUserChecked = chatUserChecked;
    }

    public Integer getChatTypeId() {
        return chatTypeId;
    }

    public void setChatTypeId(Integer chatTypeId) {
        this.chatTypeId = chatTypeId;
    }

    public Integer getChatId() {
        return chatId;
    }

    public void setChatId(Integer chatId) {
        this.chatId = chatId;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getChatUserId() {
        return chatUserId;
    }

    public void setChatUserId(Integer chatUserId) {
        this.chatUserId = chatUserId;
    }

    public Timestamp getAddDate() {
        return addDate;
    }

    public void setAddDate(Timestamp addDate) {
        this.addDate = addDate;
    }
}
