package com.lzq.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.lzq.po.User;
import org.springframework.stereotype.Repository;

@Repository
public interface UserDao extends BaseMapper<User> {


    //用户激活账号
    void userActive(String code);

    //用户更改个人信息
    void updateInfo(User user);

    //用户解封了
    void userCheckedOK(Integer id);
}
