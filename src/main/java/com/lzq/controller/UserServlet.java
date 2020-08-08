package com.lzq.controller;

import com.lzq.po.User;
import com.lzq.po.utilBean.ResultInfo;
import com.lzq.service.UserService;
import io.swagger.annotations.Api;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Date;
import java.util.UUID;

@Controller
@RequestMapping("/user")
public class UserServlet {

    @Autowired
    private UserService service;

    private String imgPath = "F:\\ideaProject\\ssm\\src\\main\\webapp\\img";

    /**
     * 用户登录
     */
    @RequestMapping("/login" )
    public @ResponseBody
    ResultInfo login(User _user, String code, HttpSession session) throws Exception {
//        从session中获取验证码
        String checkCode = (String) session.getAttribute("CHECKCODE_SERVER");
        session.removeAttribute("CHECKABLE_SERVER");
        //比较
        if (!checkCode.equalsIgnoreCase(code)||checkCode==null) {
            //验证码错误
            ResultInfo info = new ResultInfo();
            info.setFlag(false);
            info.setMsg("验证码错误，请再次刷新验证码后登录！");
            return info;
        }

        //从共享域中先获取是否有用户对象
        User sessionUser = (User) session.getAttribute("user");
        //调用业务层
        User user = service.userLogin(_user, sessionUser);
        ResultInfo info = new ResultInfo();
        if (user != null) {
            //判断用户账户是否已经激活！
            if ("N".equals(user.getStatus())) {
                info.setFlag(false);
                info.setMsg("用户账号还未激活！请前往注册邮箱进行激活！");
            } else {
                info.setFlag(true);
            }
            //判断用户的状态
            if("封号中".equals(user.getUserChecked())){
                Timestamp ts = new Timestamp(new Date().getTime());
                Timestamp tt = user.getUserDate();
                if(tt.before(ts)){
                    //进行解封
                    service.userCheckedOk(user.getId());
                }else{
                    info.setFlag(false);
                    info.setMsg("您的账号被用户举报，管理员以进行封号处理，解封时间："+
                            user.getUserDate().toString().substring(0,user.getUserDate().toString().indexOf(".")));
                }
            }
        } else {
            info.setFlag(false);
            info.setMsg("登录失败,用户名或密码错误！");
        }

        //将用户信息存进共享域
        session.setAttribute("user",user);
        return info;
    }

    /**
     * 用户注册
     */
    @RequestMapping("/register")
    public @ResponseBody
    ResultInfo register(User user, String code, HttpSession session, HttpServletRequest request) {
        //从session中获取验证码
        String checkCode = (String)session.getAttribute("CHECKCODE_SERVER");
        session.removeAttribute("CHECKCODE_SERVER");
        //比较
        if (!checkCode.equalsIgnoreCase(code)) {
            //验证码错误
            ResultInfo info = new ResultInfo();
            //注册失败
            info.setFlag(false);
            info.setMsg("验证码错误");
            return info;
        }
        System.out.println("111222");
        //调用业务层
        boolean flag = service.userRegister(user,request.getContextPath());
        ResultInfo info = new ResultInfo();
        if (flag) {
            info.setMsg("用户名已被注册");
            info.setFlag(flag);
        } else {
            info.setFlag(flag);
        }
        return info;
    }

    /**
     * 激活账号功能
     */
    @RequestMapping("/active")
    public void active(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //1.获取激活码
        String code = request.getParameter("code");
        if (code != null) {
            //2.调用service完成激活
            boolean flag = service.active(code);
            //3.判断标记
            String msg = null;
            if (flag) {
                //激活成功
                msg = "激活成功，回到<a href='http://localhost:8080"+request.getContextPath()+"/index.jsp'>主页</a>进行登录";
            } else {
                //激活失败
                msg = "激活失败，由于网络问题或验证码已被更改！";
            }
            response.setContentType("text/html;charset=utf-8");
            response.getWriter().write(msg);
        }
    }

    /**
     * 退出登录
     */
    @RequestMapping("/exit")
    public @ResponseBody
    ResultInfo exit(HttpSession session) {
        //移除session中的user
        session.removeAttribute("user");
        return new ResultInfo(true);
    }

    /**
     * 找回密码
     */
    @RequestMapping("/findPassword")
    public @ResponseBody
    ResultInfo findPassword(String username, String email) throws Exception {
        return service.userFindPassword(username,email);
    }

    /**
     * 修改密码
     */
    @RequestMapping("/updatePassword")
    public @ResponseBody
    ResultInfo updatePassword(String passwordOld, String passwordNew, String passwordNewAgain, HttpSession session) throws Exception {
        //获取用户的id
        User user = (User) session.getAttribute("user");
        System.out.println(user);
        return service.updatePassword(user.getId(),passwordOld,passwordNew,passwordNewAgain);
    }


    /**
     * 更改用户信息
     */
    @RequestMapping(value = "/updateInfo")
    public @ResponseBody
    ResultInfo updateInfo(String check, User _user, HttpServletRequest request, MultipartFile upload) throws IOException {
        System.out.println(upload);
        String headAddress = null;
        User user = (User) request.getSession().getAttribute("user");
        if(Integer.parseInt(check)==1){//表示有重新上传头像
            //设置上传地址
            String path = imgPath;
            //判断
            File file = new File(path);
            if(!file.exists()){
                file.mkdirs();//不存在则创建
            }
            //获取名称
            String filename = upload.getOriginalFilename();
            System.out.println("文件名"+filename);
            String uuid = UUID.randomUUID().toString().replace("-","");
            //完成文件上传
            upload.transferTo(new File(path,filename));
            headAddress = "/img" + "/" + filename;
        }else{
            headAddress=user.getHeadAddress();
        }
        //获取用户id
        Integer id = user.getId();

        //设置用户id还有用户头像
        _user.setId(id);
        _user.setHeadAddress(headAddress);

        //调用service
        boolean flag = service.updateInfo(_user);
        ResultInfo info = new ResultInfo(flag);
        if(flag){
            info.setMsg("修改成功！");
            //更新共享域中的用户信息
            user.setHeadAddress(_user.getHeadAddress());
            user.setAge(_user.getAge());
            user.setIntroduction(_user.getIntroduction());
            user.setNickName(_user.getNickName());
            request.getSession().setAttribute("user",user);
            System.out.println("更改后的用户："+user);
        }else{
            info.setMsg("操作异常！");
        }
        return info;
    }

}
