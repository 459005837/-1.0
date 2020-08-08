<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>首页</title>
  </head>
  <script src="js/jquery-3.3.1.js"></script>
  <style>
    *{ margin:0; padding:0;}
    .login{ width:120px; height:42px;  border-radius:6px; display: block; margin:20px auto; cursor: pointer;}
    .popOutBg{ width:100%; height:100%; position: fixed; left:0; top:0; background:rgba(0,0,0,.6); display: none;}
    .popOut{ position:fixed; width:550px; height:400px; top:45%; left:52%; margin-top:-150px; margin-left:-300px; background: aliceblue; border-radius:8px; overflow: hidden; display: none;}
    .popOut > span{ position: absolute; right:10px; top:0; height:42px; line-height:42px; color:#000; font-size:30px; cursor: pointer;}
    .popOut table{ display: block; margin:42px auto 0; width:520px;}
    .popOut caption{ width:520px; text-align: center; font-size:18px; line-height:42px;}
    .popOut table tr td{ color:#666; padding:6px; font-size:14px;}
    .popOut table tr td:first-child{ text-align: right;}
    .inp{ width:280px; height:30px; line-height:30px; border:1px solid #999; padding:5px 10px;  font-size:14px; border-radius:6px;}
    .inp:focus{ border-color:#f40;}
    @keyframes ani{
      from{
        transform:translateX(-100%) rotate(-60deg) scale(.5);
      }
      50%{
        transform:translateX(0) rotate(0) scale(1);
      }
      90%{
        transform:translateX(20px) rotate(0) scale(.8);
      }
      to{
        transform:translateX(0) rotate(0) scale(1);
      }
    }
    .ani{ animation:ani .5s ease-in-out;}
  </style>
  <script>
    function select() {
      jQuery.ajax({
        type: "POST",
        url:"${pageContext.request.contextPath}/article/articleType",
        contentType: false,
        processData: false,
        success: function(data) {
          for ( i = 0;i<data.length;i++){
            jQuery("#select").append('<option value ="'+data[i].typeId+'">'+data[i].typeName+'</option>');
          }
        dayArticle();
        }
      });
    }
    function dayArticle() {
      jQuery.ajax({
        type: "POST",
        url:"${pageContext.request.contextPath}/article/dayArticle",
        contentType: false,
        processData: false,
        success: function(data) {
          for ( i = 0;i<data.length;i++){
            var article = data[i];
            jQuery("#day").append('<tr>\n' +
                    '      <td>\n' +
                    '        <img src="'+article.articleTitlePhoto+'" width="50" height="50" alt="">\n' +
                    '      </td>\n' +
                    '      <td>\n' +
                    '         <a href="${pageContext.request.contextPath}/articleDetail.jsp?userId='+article.id+'&articleId='+article.articleId+'" target="_blank" >'+article.articleTitle+'</a>\n' +
                    '      </td>\n' +
                    '      <td colspan="3">\n' +
                    '        '+article.summary+'\n' +
                    '      </td>\n' +
                    '      <td>\n' +
                    '        作者:'+article.username+' 评论数:'+article.commentNum+' 点赞数:'+article.likeNum+'\n' +
                    '      </td>\n' +
                    '    </tr>');
          }
          load(1,null,1);
        }
      });
    }
    load(1,null,1);
    function load(currentPage,findStr,findType){
      jQuery.ajax({
        type: "POST",
        url: "${pageContext.request.contextPath}/articleList/articleListByPage?currentPage="+currentPage
                +"&findStr="+findStr+"&findType="+findType,
        contentType: false,
        processData: false,
        success: function(pb) {
          if(pb.list==null){
            alert("无符合此条件的数据，请重新查询");
            return;
          }
          jQuery("#total").html('共'+pb.totalCount+'条记录，共'+pb.totalPage+'页\n');
          var lis = "";
          //计算上一页的页码
          var beforeNum = pb.currentPage - 1;
          if (beforeNum <= 0) {
            beforeNum = 1;
          }
          var firstPage = '<a href="javascript:void(0);" onclick="load('+beforeNum+',\''+findStr+'\',\''+findType+'\')">上一页</a>&nbsp;';
          lis += firstPage;
          var begin; // 开始位置
          var end; //  结束位置
          //1.要显示10个页码
          if (pb.totalPage < 10) {
            //总页码不够10页
            begin = 1;
            end = pb.totalPage;
          } else {
            //总页码超过10页
            begin = pb.currentPage - 5;
            end = pb.currentPage + 4;
            //2.如果前边不够5个，后边补齐10个
            if (begin < 1) {
              begin = 1;
              end = begin + 9;
            }
            //3.如果后边不足4个，前边补齐10个
            if (end > pb.totalPage) {
              end = pb.totalPage;
              begin = end - 9;
            }
          }

          for (var i = begin; i <= end; i++) {
            var li;
            li = '<a href="javascript:void(0);" onclick="load('+i+',\''+findStr+'\',\''+findType+'\')">'+i+'</a>&nbsp;';
            //拼接字符串
            lis += li;
          }
          //计算下一页的页码
          var nextNum = pb.currentPage + 1;
          if (nextNum >= pb.totalPage) {
            nextNum = pb.totalPage;
          }
          var nextPage = '<a href="javascript:void(0);" onclick="load('+nextNum+',\''+findStr+'\',\''+findType+'\')">下一页</a>&nbsp;';
          lis += nextPage;
          //将lis内容设置到 ul
          jQuery("#pageNum").html(lis);
          //2.列表数据展示
          var route_lis = "";
          for (var i = 0; i < pb.list.length; i++) {
            var article = pb.list[i];
            var li = '    <tr>\n' +
                    '      <td>\n' +
                    '        <img src="'+article.articleTitlePhoto+'" width="50" height="50" alt="">\n' +
                    '      </td>\n' +
                    '      <td>\n' +
                    '         <a href="${pageContext.request.contextPath}/articleDetail.jsp?userId='+article.id+'&articleId='+article.articleId+'"  target="_blank" >'+article.articleTitle+'</a>\n' +
                    '      </td>\n' +
                    '      <td colspan="3">\n' +
                    '        '+article.summary+'\n' +
                    '      </td>\n' +
                    '      <td>\n' +
                    '        作者:'+article.username+' 评论数:'+article.commentNum+' 点赞数:'+article.likeNum+'\n' +
                    '      </td>\n' +
                    '    </tr>\n\n';
            route_lis += li;
          }
          jQuery("#list").html("");
          jQuery("#list").append('      <tr><td align="center">文章图片</td><td align="center">标题</td><td align="center" colspan="3">摘要</td><td align="center">相关信息</td></tr>\n');
          jQuery("#list").append(route_lis);
        }
      });
    }
        select();
  </script>
  <body>
<div align="center">
  <span style="color: darkorange; font-size: 25px ">简书</span>&nbsp;
  <a href="javascript:void(0);" onclick="at();">主页</a>&nbsp;
  <script>
    function at() {
        location.reload();
    }
  </script>
  <a href="javascript:void(0);" onclick="att();">关注</a>&nbsp;
  <script>
    function att() {
      if(${user==null}){
        alert("您还未登录！");return;
      }else{
        window.open("${pageContext.request.contextPath}/attention.jsp");
      }
    }
  </script>
  <a href="javascript:void(0);" onclick="mess();">消息</a>&nbsp;
  <script>
    function mess() {
      if(${user==null}){
        alert("您还未登录！");return;
      }else{
        window.open("${pageContext.request.contextPath}/message.jsp");
      }
    }
  </script>
  <c:if test="${user==null}">
  <a href="javascript:void(0)" onclick="ll();">登录</a>&nbsp;
    <a href="javascript:void(0)" onclick="RR();">注册</a>&nbsp;
  </c:if>
  <c:if test="${user!=null}">
    欢迎，<font style="color: darkorange">${user.username}</font>&nbsp;
    <a href="javascript:void(0);" onclick="exist();">退出</a>&nbsp;
  </c:if>
  <a href="javascript:void(0);" onclick="home();">我的主页</a>&nbsp;
  <script>
    function home() {
      if(${user==null}){
        alert("您还未登录！");return;
      }else{
         window.open("${pageContext.request.contextPath}/userMain.jsp");
      }
    }
  </script>
  <a href="javascript:void(0)" onclick="likeArticle();">喜欢的文章</a>
  <script>
    function likeArticle() {
      if(${user==null}){
        alert("您还未登录！");return;
      }else{
        window.open("${pageContext.request.contextPath}/likeArticle.jsp");
      }
    }
  </script>
  <a href="javascript:void(0)" onclick="collectArticle();">收藏的文章</a>&nbsp;
  <script>
    function collectArticle() {
      if(${user==null}){
        alert("您还未登录！");return;
      }else{
        window.open("${pageContext.request.contextPath}/collectArticle.jsp");
      }
    }
  </script>
  <a href="javascript:void(0);"onclick="writeAA();">写文章</a>&nbsp;
  <script>
    function writeAA() {
      if(${user==null}){
        alert("您还未登录！");return;
      }else{
        window.open("${pageContext.request.contextPath}/ediArticle.jsp");
      }
    }
  </script>
  <a href="javascript:void(0);"onclick="mm();">管理员入口</a>&nbsp;
</div>
  <hr>
<br>
<div align="center">
  <input type="text" id="findStr" placeholder="请输入关键词">
  <select name="" id="select">

  </select>
  <button id="find" onclick="findA();" >查找</button>
  <script>
    function exist() {
      jQuery.ajax({
        type: "POST",
        url:"${pageContext.request.contextPath}/user/exit",
        contentType: false,
        processData: false,
        success: function(data) {
          location.reload();
        }
      });
    }
    function findA() {
      //获取类型，获取查找关键词
      var findStr = jQuery("#findStr").val();
      var findType = jQuery("#select option:selected").val();
      load(1,findStr,findType);
    }
  </script>
  <br>
  <span style="color:darkorange">每日推荐</span>
    <table border="1" id="day">
      <tr><td align="center">文章图片</td><td align="center">标题</td><td align="center" colspan="3">摘要</td><td align="center">相关信息</td></tr>
  </table>
  <br>
  <span style="color: darkorange">更多文章</span>

  <table id="list" border="1" >

  </table>

  <ul class="pagination" >
    <div id="pageNum">
    </div>
    <span style="font-size: 25px;margin-left: 5px;" id="total">
        </span>
  </ul>
</div>

  <div class="popOutBg"></div>
  <div class="popOut">
    <span title="关闭"> x </span>
    <div id="table"></div>
  </div>


  <script type="text/javascript">
    function changeCheckCode(img) {
      img.src="checkCodeServlet?"+new Date().getTime();
    }
    //登录
    function L() {
      var username = jQuery("#username").val();
      var password = jQuery("#password").val();
      var code = jQuery("#code").val();
      if(username==null||username==''){alert("用户名不能为空");return;}
      if(password==null||password==''){alert("密码不能为空");return;}
      if(code==null||code==''){alert("验证码不能为空");return;}
      jQuery.ajax({
        type: "POST",
        url:"${pageContext.request.contextPath}/user/login?username="+username+"&password="+password+"&code="+code,
        contentType: false,
        processData: false,
        success: function(data) {
          if(data.flag){
            location.reload();
          }else{
            jQuery("#imgL").trigger("onclick");
            alert(data.msg)
          }
        }
      });
    }
    function checkUsername() {
      //1.获取用户名值
      var usernameRegister = jQuery("#usernameR").val();
      if(usernameRegister!=null&&usernameRegister!='') {
        //2.定义正则
        var reg_username = /^[\u4E00-\u9FA5]{2,5}$/;
        //3.判断，给出提示信息
        var flag = reg_username.test(usernameRegister);
        if (flag) {
          //提示绿色对勾
          jQuery("#s_username").html("<img width='35' height='25' src='/img/gou.png'/>")
        } else {
          //提示红色用户名有误
          alert("用户名格式错误！（请输入3-5位中文用户名）")
        }
        return flag;
      }
    }

    //校验密码
    function checkPassword() {
      //1.获取密码值
      var passwordRegister = jQuery("#passwordNew").val();
      if(passwordRegister!=null&&passwordRegister!='') {
        //2.定义正则
        var reg_password = /^\w{6,12}$/;
        //3.判断，给出提示信息
        var flag = reg_password.test(passwordRegister);
        //4.提示信息
        if (flag) {
          //提示绿色对勾
          jQuery("#s_password").html("<img width='35' height='25' src='/img/gou.png'/>");
        } else {
          //提示密码有误
          alert("密码格式错误！(请输入6至12位字符密码！)");
        }
        return flag;
      }
    }

    function checkPasswordAgain() {
      //1.获取密码二次值
      var passwordAgainRegister = jQuery("#passwordNewAgain").val();
      //1.获取密码值
      var passwordRegister = jQuery("#passwordNew").val();
      if((passwordRegister!=null)&&passwordAgainRegister!=null&&passwordRegister!=''&&passwordAgainRegister!='') {
        if (passwordAgainRegister == passwordRegister) {
          //提示绿色对勾
          jQuery("#s_passwordAgain").html("<img width='35' height='25' src='/img/gou.png'/>");
          return true;
        } else {
          //提示红色用户名有误
          alert("输入密码不一致!");
          return false;
        }
      }
      if(passwordAgainRegister!=null&&passwordAgainRegister!=''&&(passwordRegister==null||passwordRegister=='')){
        alert("请先输入密码");
        return false;
      }
    }

    //校验邮箱
    function checkEmail(){
      //1.获取邮箱
      var emailRegister = jQuery("#email").val();
      if(emailRegister!=null&&emailRegister!='') {
        //2.定义正则		itcast@163.com
        var reg_email = /^\w+@\w+\.\w+$/;
        //3.判断
        var flag = reg_email.test(emailRegister);
        if (flag) {
          //提示绿色对勾
          jQuery("#s_email").html("<img width='35' height='25' src='/img/gou.png'/>");
        } else {
          //提示红色用户名有误
          alert("邮箱格式不正确！(请输入人本人邮箱，以进行用户激活)");
        }
        return flag;
      }
    }
    //注册
    function R() {
      if(checkPasswordAgain()&&checkEmail()&&checkUsername()&&checkPassword()){
        var usernameRe = jQuery("#usernameR").val();
        var passwordRe = jQuery("#passwordNew").val();
        var passwordAgainRe = jQuery("#passwordNewAgain").val();
        var emailRe = jQuery("#email").val();
        var codeRe = jQuery("#codeR").val();
        if(usernameRe==null||usernameRe==''){
          alert("请输入用户名");
        }else if(passwordRe==null||passwordRe==''){
          alert("请输入密码");
        }else if(passwordAgainRe==null||passwordAgainRe==''){
          alert("请再次输入密码");
        }else if(emailRe==null||emailRe==''){
          alert("请输入本人邮箱（以进行账号激活！）");
        }else if(codeRe==null||codeRe=='') {
          alert("请输入验证码");
        }else{
          jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/user/register?username="+usernameRe+"&password="+passwordRe+"&code="+codeRe+"&email="+emailRe,
            contentType: false,
            processData: false,
            success: function(data) {
              if (data.flag) {
                alert("注册成功！请登录对应的邮箱，点击激活链接进行账户激活！若无法直接点击，请复制后查询打开");
                hh();
              }else {
                alert(data.msg);
              }
            }
          });
        }
      }
    }
    //找回密码功能
    function findP() {
        var username = jQuery("#usernameFind").val();
        var email = jQuery("#emailFind").val();
        if(username==null||username==''){alert("请输入用户名");return;}
        if(email==null||email==''){alert("请输入邮箱");return;}
        //2.定义正则		itcast@163.com
        var reg_email = /^\w+@\w+\.\w+$/;
        //3.判断
        var flag = reg_email.test(email);
        if(!flag){alert("输入邮箱格式不正确！");return;}
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/user/findPassword?username="+username+"&email="+email,
            contentType: false,
            processData: false,
            success: function(data) {
                if (data.flag) {
                    alert(data.msg);
                    hh();
                }else {
                    alert(data.msg);
                }
            }
        });

    }
  </script>

  <script type="text/javascript">
    function loginButton() {
      //当某一个组件失去焦点是，调用对应的校验方法
      jQuery("#usernameR").blur(checkUsername);
      jQuery("#passwordNew").blur(checkPassword);
      jQuery("#email").blur(checkEmail);
      jQuery("#passwordNewAgain").blur(checkPasswordAgain);
    }
    function $(param){
      if(arguments[1] == true){
        return document.querySelectorAll(param);
      }else{
        return document.querySelector(param);
      }
    }
    function ani(){
      $(".popOut").className = "popOut ani";
    }
    function RR(){
      jQuery("#table").html('');
      jQuery("#table").append('        <table>\n' +
              '            <caption>用户注册</caption>\n' +
              '            <tr>\n' +
              '                <td>用户名</td>\n' +
              '                <td><input type="text" class="inp"  id="usernameR" placeholder="请输入用户名，中文字符2-5位" /><span id="s_username"></span></td>\n' +
              '            </tr>\n' +
              '            <tr>\n' +
              '                <td>输入密码</td>\n' +
              '                <td><input type="password" class="inp"  id="passwordNew" placeholder="请输入密码，字符密码6-12位" /><span id="s_password"></span></td>\n' +
              '            </tr>\n' +
              '            <tr>\n' +
              '                <td>再次密码</td>\n' +
              '                <td><input type="password" class="inp"  id="passwordNewAgain" placeholder="请输入密码" /><span id="s_passwordAgain"></span></td>\n' +
              '            </tr>\n' +
              '            <tr>\n' +
              '                <td>邮箱</td>\n' +
              '                <td><input type="text" class="inp"  id="email" placeholder="请输入邮箱" /><span id="s_email"></span></td>\n' +
              '            </tr>\n' +
              '            <tr>\n' +
              '                <td>验证码</td>\n' +
              '                <td><input type="text" class="inp"  id="codeR" placeholder="请输入验证码"></td>\n' +
              '                <td><img src="checkCodeServlet" id="imgR" height="32px" alt="" onclick="changeCheckCode(this)">\n</td>\n' +
              '            </tr>\n' +
              '            <tr>\n' +
              '                <td colspan="2"><input type="button"  onclick="R();" class="login" value="完成" /></td>\n' +
              '            </tr>\n' +
              '        </table>')
      jQuery("#imgR").trigger("onclick");
      $(".popOut").style.display = "block";
      ani();
      $(".popOutBg").style.display = "block";
      loginButton();
    };
    function ML() {
        //获取用户名和密码
        var username = jQuery("#usernameM").val();
        var password = jQuery("#passwordM").val();
        if(username==null||username==''){alert("请填写用户名");return};
        if(password==null||password==''){alert("请输入密码");return;};
      jQuery.ajax({
        type: "POST",
        url:"${pageContext.request.contextPath}/manager/login?username="+username+"&password="+password,
        contentType: false,
        processData: false,
        success: function(data) {
            if(data.flag){
              window.open("${pageContext.request.contextPath}/manage.jsp");
              hh();
            }else{
              alert(data.msg);
            }
        }
      });
    }
    function mm(){
      jQuery("#table").html('');
      jQuery("#table").append('        <table>\n' +
              '            <caption>管理员登录</caption>\n' +
              '            <tr>\n' +
              '                <td>用户名</td>\n' +
              '                <td><input type="text" class="inp"  id="usernameM" placeholder="请输入用户名" /></td>\n' +
              '            </tr>\n' +
              '            <tr>\n' +
              '                <td>密码</td>\n' +
              '                <td><input type="password" class="inp"  id="passwordM" placeholder="请输入密码" /></td>\n' +
              '            </tr>\n' +
              '            <tr>\n' +
              '                <td colspan="2"><input type="button" onclick="ML();" class="login" value="登录" /></td>\n' +
              '            </tr>\n' +
              '        </table>')
      jQuery("#imgL").trigger("onclick");
      $(".popOut").style.display = "block";
      ani();
      $(".popOutBg").style.display = "block";
    };
    function ll(){
      jQuery("#table").html('');
      jQuery("#table").append('        <table>\n' +
              '            <caption>用户登录</caption>\n' +
              '            <tr>\n' +
              '                <td>用户名</td>\n' +
              '                <td><input type="text" class="inp"  id="username" placeholder="请输入用户名" /></td>\n' +
              '            </tr>\n' +
              '            <tr>\n' +
              '                <td>密码</td>\n' +
              '                <td><input type="password" class="inp"  id="password" placeholder="请输入密码" /></td>\n' +
              '            </tr>\n' +
              '            <tr>\n' +
              '                <td>验证码</td>\n' +
              '                <td><input type="text" class="inp" name="code" id="code" placeholder="请输入验证码"></td>\n' +
              '                <td><img src="checkCodeServlet" height="32px" id="imgL" alt="" onclick="changeCheckCode(this)">\n</td>\n' +
              '            </tr>\n' +
              '            <tr>\n' +
              '                <td colspan="2"><input type="button" onclick="L();" class="login" value="登录" /></td>\n' +
           '            </tr>\n' +
          '            <tr>\n' +
          '                <td colspan="2"><input type="button" onclick="findPassword();" class="login" value="找回密码" /></td>\n' +
          '            </tr>\n' +
          '        </table>')
      jQuery("#imgL").trigger("onclick");
      $(".popOut").style.display = "block";
      ani();
      $(".popOutBg").style.display = "block";
    };
    function findPassword(){
        hh();
        jQuery("#table").html('');
        jQuery("#table").append('        <table>\n' +
            '            <caption>找回密码</caption>\n' +
            '            <tr>\n' +
            '                <td>用户名</td>\n' +
            '                <td><input type="text" class="inp"  id="usernameFind" placeholder="请输入用户名" /></td>\n' +
            '            </tr>\n' +
            '            <tr>\n' +
            '                <td>邮箱</td>\n' +
            '                <td><input type="text" class="inp"  id="emailFind" placeholder="请输入邮箱" /></td>\n' +
            '            </tr>\n' +
            '            <tr>\n' +
            '                <td colspan="2"><input type="button" onclick="findP();" class="login" value="传输临时密码" /></td>\n' +
            '            </tr>\n' +
            '            <tr>\n' +
            '                <td>注意事项</td>\n' +
            '                <td><span style="color: #999999; font-size: 15px">邮箱账号为该用户名注册时所绑定的邮箱！</span>\n</td>\n' +
            '            </tr>\n' +
            '        </table>')
        jQuery("#imgL").trigger("onclick");
        $(".popOut").style.display = "block";
        ani();
        $(".popOutBg").style.display = "block";
    };
    function hh(){
      $(".popOut").style.display = "none";
      $(".popOutBg").style.display = "none";
    }
    $(".popOut > span").onclick = function(){
      $(".popOut").style.display = "none";
      $(".popOutBg").style.display = "none";
    };
    $(".popOutBg").onclick = function(){
      $(".popOut").style.display = "none";
      $(".popOutBg").style.display = "none";
    };
  </script>
  </body>
</html>
