package com.lzq;

import com.lzq.po.User;
import com.lzq.service.UserService;
import com.lzq.service.impl.UserServiceImpl;
import org.junit.Test;

public class UserServiceTest {

    UserService userService = new UserServiceImpl();

    @Test
    public void test1() throws Exception {
        User user = new User();
        user.setUsername("小李");
        user.setPassword("123123");
        User user1 = userService.userLogin(user, null);
        System.out.println(user1);
    }
}
