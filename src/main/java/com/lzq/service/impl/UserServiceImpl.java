package com.lzq.service.impl;


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.lzq.mapper.UserDao;
import com.lzq.po.User;
import com.lzq.po.utilBean.ResultInfo;
import com.lzq.service.UserService;
import com.lzq.util.MailUtils;
import com.lzq.util.Md5Util;
import com.lzq.util.UuidUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao dao;

    private QueryWrapper<User> wrapper;
    /**
     * 用户登录
     */
    @Override
    public User userLogin(User user, User sessionUser) throws Exception {

        //select * from user where username = ? and password = ?
        wrapper = new QueryWrapper<User>()
                .eq("username",user.getUsername())
                .eq("password", Md5Util.encodeByMd5(user.getPassword()));

        if(sessionUser!=null){
            //共享域中的用户信息和登录信息一致，不用再查询数据库
            if(user.getUsername().equals(sessionUser.getUsername())&& Md5Util.encodeByMd5(user.getPassword()).equals(sessionUser.getPassword())){
                return sessionUser;
            }else{
                //对密码进行加密后在传到数据库做判断
                return dao.selectOne(wrapper);
            }
        }else{
            User user1 = dao.selectOne(wrapper);
            return user1;
        }
    }


    /**
     * 用户注册
     */
    @Override
    public boolean userRegister(User user, String contextPath) {
        //select * from user where username = ?
        wrapper = new QueryWrapper<User>()
                .eq("username",user.getUsername());

        //先判断用户名是否已被注册
        User user1 = dao.selectOne(wrapper);
        if(user1!=null){
            //已被注册
            return false;
        }
        //设置激活码，激活状态，将信息存表
        user.setCode(UuidUtil.getUuid());
        user.setStatus("N");
        //对密码进行加密
        try {
            user.setPassword(Md5Util.encodeByMd5(user.getPassword()));
        } catch (Exception e) {
            e.printStackTrace();
        }
        //insert into user (...)values()
        System.out.println("333222");
        System.out.println(user);
        dao.insert(user);
        System.out.println("333444");
        //发送邮件
        String content="http://localhost:8080"+contextPath+"/user/active?code="+user.getCode()+"  点击连接激活 简书 网账户";
        MailUtils.sendMail(user.getEmail(),content,"激活邮件");
        return true;
    }

    /**
     * 用户激活账号
     */
    @Override
    public boolean active(String code) {
        System.out.println("111");
        dao.userActive(code);

        System.out.println("222");
        return true;
    }

    /**
     * 用户找回密码
     */
    @Override
    public ResultInfo userFindPassword(String username, String email) throws Exception {
        wrapper = new QueryWrapper<User>()
                .eq("username",username)
                .eq("email",email);

        ResultInfo info = new ResultInfo();
        //先判断该用户名和邮箱是否匹配
        User user = dao.selectOne(wrapper);

        if(user==null){
            info.setFlag(false);
            info.setMsg("用户名和邮箱不匹配，请重新输入！");
            return info;
        }
        //获得临时密码
        String password = UuidUtil.getUuid();
        //更改对应用户的密码
        user.setPassword(Md5Util.encodeByMd5(password));
        dao.updateById(user);

        //发送临时密码
        MailUtils.sendMail(email,"简书： 用户名："+username+"，临时密码："+password+"，请登录主页修改密码！","密码找回");
        info.setFlag(true);
        info.setMsg("传输成功！请及时登录查看！");
        return info;
    }

    /**
     * 用户更改个人信息
     */
    @Override
    public boolean updateInfo(User user) { dao.updateInfo(user);return true; }

    /**
     * 用户更改密码
     */
    @Override
    public ResultInfo updatePassword(Integer id, String passwordOld, String passwordNew, String passwordNewAgain) throws Exception {
        ResultInfo info = new ResultInfo();
        //先判断原密码正不正确
        wrapper = new QueryWrapper<User>()
                .eq("id",id)
                .eq("password", Md5Util.encodeByMd5(passwordOld));

        User user = dao.selectOne(wrapper);
        if(user==null){
            info.setFlag(false);
            info.setMsg("原密码输入错误！");
            return info;
        }

        //完成密码的更改
        user.setPassword(Md5Util.encodeByMd5(passwordNew));
        dao.updateById(user);

        info.setFlag(true);
        info.setMsg("更改密码成功！");

        return info;
    }

    /**
     * 解封了
     */
    @Override
    public void userCheckedOk(Integer id) {
        dao.userCheckedOK(id);
    }
}
