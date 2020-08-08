package com.lzq.po;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;

import java.sql.Timestamp;

public class User {

    @TableId(type= IdType.AUTO)
    private Integer id;
    private String username;
    private String password;
    private String email;
    private String code;
    private String status;
    private String userChecked;
    private String headAddress;
    private String introduction;
    private String nickName;
    private Integer age;
    private Timestamp userDate;

    public Timestamp getUserDate() {
        return userDate;
    }

    public void setUserDate(Timestamp userDate) {
        this.userDate = userDate;
    }

    @Override
    public String toString() {
        return "User{" +
                "id=" + id +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", email='" + email + '\'' +
                ", code='" + code + '\'' +
                ", status='" + status + '\'' +
                ", userChecked='" + userChecked + '\'' +
                ", headAddress='" + headAddress + '\'' +
                ", introduction='" + introduction + '\'' +
                ", nickName='" + nickName + '\'' +
                ", age=" + age +
                '}';
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

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getUserChecked() {
        return userChecked;
    }

    public void setUserChecked(String userChecked) {
        this.userChecked = userChecked;
    }

    public String getHeadAddress() {
        return headAddress;
    }

    public void setHeadAddress(String headAddress) {
        this.headAddress = headAddress;
    }

    public String getIntroduction() {
        return introduction;
    }

    public void setIntroduction(String introduction) {
        this.introduction = introduction;
    }

    public String getNickName() {
        return nickName;
    }

    public void setNickName(String nickName) {
        this.nickName = nickName;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }
}
