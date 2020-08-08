package com.lzq.service;

import com.lzq.po.User;
import com.lzq.po.utilBean.ResultInfo;

public interface UserService {

    //用户登录
    User userLogin(User user, User sessionUser) throws Exception;
    //用户注册
    boolean userRegister(User user, String contextPath);
    //用户激活账号
    boolean active(String code);
    //用户找回密码
    ResultInfo userFindPassword(String username, String email) throws Exception;
    //用户更改个人信息
    boolean updateInfo(User user);
    //用户更改密码
    ResultInfo updatePassword(Integer id, String passwordOld, String passwordNew, String passwordNewAgain) throws Exception;
    //用户解封
    void userCheckedOk(Integer id);
}
