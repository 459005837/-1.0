<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>个人主页</title>
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
<style>
    .inpI{ width:280px; height:30px; line-height:30px; border:1px solid #999; padding:5px 10px;  font-size:14px; border-radius:6px;}
    .loginI{ width:120px; height:42px;  border-radius:6px; display: block; margin:20px auto; cursor: pointer;}
     .login{ width:120px; height:42px;  border-radius:3px; margin:10px auto;}
</style>
<script>
    //查询登录用户的关注人数还有粉丝数，还有文章数,以及收获的喜欢
    function nums() {
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/userNums?userId=0",
            contentType: false,
            processData: false,
            success: function(data) {
                jQuery("#follow").html(data.followsNum);
                jQuery("#fans").html(data.fansNum);
                jQuery("#article").html(data.articlesNum);
                jQuery("#likeNum").html(data.likesNum);
                follow = data.followsNum;
                fans = data.fansNum;
            }
        });
    }
    nums();
    function fuser(check) {
        jQuery("#1").html('');
        jQuery("#2").html('');
        if(check==0){
            if(follow==0){
                alert("您还没有任何关注！");return;
            }
        }else{
            if(fans==0){
                alert("您还没有粉丝！");return;
            }
        }
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/followUser?check="+check+"&userId=0",
            contentType: false,
            processData: false,
            success: function(data) {
                if(check==0){
                    jQuery("#title").html("关注的用户");
                }else{
                    jQuery("#title").html("我的粉丝");
                }
                jQuery("#table1").html('');
                jQuery("#table1").append('<tr><td>头像</td><td align="center">用户名</td><td align="center">相关信息</td><td align="center">操作</td></tr>\n')
                //遍历回显
                for (i=0;i<data.length;i++){
                    var user = data[i];
                    jQuery("#table1").append('<tr><td><img src="'+user.headAddress+'" width="50" height="50" alt=""></td>' +
                        '<td align="center"> <a href="${pageContext.request.contextPath}/userHome.jsp?userId='+user.userId+'" target="_blank">'+user.username+'</a></td>' +
                        '<td align="center">关注：'+user.followsNum+'，粉丝：'+user.fansNum+'，文章：'+user.articlesNum+'，收获的喜欢：'+user.likesNum+'</td>' +
                        '<td align="center"><a href="javascript:void(0);" onclick="cancelFollow(\''+i+'\',\''+user.userId+'\',\''+user.checked+'\')" id="con'+i+'">'+user.checked+'</a></td></tr>')
                }
            }
        });
    }
    //取消关注和关注
    function cancelFollow(i,userId,action) {

        if(confirm("您确定"+action+"吗？")){
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/userAct/updateFollow?userId="+userId+"&action="+action,
                contentType: false,
                processData: false,
                success: function(data) {
                    if(data.flag){
                        alert(data.msg);
                        //修改操作标签中的内容，还有方法
                        if(action=='取消关注'){
                            jQuery("#con"+i).html('关注');
                            jQuery("#con"+i).attr('onclick','cancelFollow('+i+','+userId+',"关注用户")');
                        }else{
                            jQuery("#con"+i).attr('onclick','cancelFollow('+i+','+userId+',"取消关注")');
                            jQuery("#con"+i).html('取消关注');
                        }
                    }else{
                        alert(data.msg);return;
                    }
                }
            });
        }
    }
    function myArticle() {
        jQuery("#title").html('文章管理')
        //先查询获得文章数据分为草稿箱还有已发布
        jQuery("#1").html('<input type="submit" value="已发布" onclick="finda(1)" class="login" />');
        jQuery("#2").html('<input type="submit" value="草稿箱" onclick="finda(0)" class="login" />&nbsp;\n')
        finda(1);
    }
    function finda(check) {
        //check 1表示查询已经发布的，0表示查询草稿箱的
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/article/userArticle?check="+check+"&userId=0",
            contentType: false,
            processData: false,
            success: function(data) {
                jQuery("#table1").html('');
                if(data==null){
                    if(check==1){
                        jQuery("#table1").html('您还未发布文章！');
                    }else{
                        jQuery("#table1").html('您还未保存草稿！');
                    }
                    return;
                }
                jQuery("#table1").append('<tr><td>图片</td><td align="center">文章名称</td><td align="center">文章摘要</td><td align="center">上传时间</td><td align="center">操作</td></tr>\n')
                //遍历回显
                for (i=0;i<data.length;i++){
                    var a = data[i];
                    jQuery("#table1").append('<tr><td><img src="'+a.articleTitlePhoto+'" width="50" height="50" alt=""></td>' +
                        '<td align="center">'+a.articleTitle+'</td>' +
                        '<td align="center">'+a.summary+'</td>' +
                        '<td align="center">'+a.time+'</td>' +
                        '<td align="center"><a href="${pageContext.request.contextPath}/ediArticle.jsp?articleId='+a.articleId+'" target="_blank">修改</a>&nbsp;' +
                        '<a href="javascript:void(0);" onclick="deleteArticle(\''+a.articleId+'\')">删除</a>&nbsp;' +
                        '<a href="${pageContext.request.contextPath}/articleDetail.jsp?articleId='+a.articleId+'&userId=${user.id}" target="_blank" >浏览</a>&nbsp;</td></tr>')
                }
            }
        });
    }
    function deleteArticle(id) {
        //根据id删除文章
        if(confirm("您确定删除此篇文章吗？")){
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/userAct/deleteArticle?articleId="+id,
                contentType: false,
                processData: false,
                success: function(data) {
                    if(data.flag){
                        alert("删除成功！");
                        myArticle();
                    }else{
                        alert("操作异常！");
                    }
                }
            });
        }
    }
    //显示我的动态
    function AAAA() {
        jQuery("#1").html('');
        jQuery("#2").html('');
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/userAction?userId=0",
            contentType: false,
            processData: false,
            success: function(data) {
                jQuery("#title").html("我的动态");
                jQuery("#table1").html('');
                if(data==null || data==''){
                        jQuery("#table1").html('您还没有动态！');return;
                }
                jQuery("#table1").append('<tr><td align="center">动态</td><td align="center">时间</td></tr>\n')
                //遍历回显
                for (i=0;i<data.length;i++){
                    var a = data[i];
                    jQuery("#table1").append('<tr>' +
                        '<td align="center">'+a.action+'&nbsp;<a href="javascript:void(0);" onclick="MM('+a.userId+','+a.articleId+','+a.addId+')">'+a.content+'</a></td>' +
                        '<td align="center">'+a.time+'</td>' +
                        '</tr>')
                }
            }
        });
    }
    function MM(userId,articleId,addId) {
        if(userId==0){
            //说明是文章
            window.open("${pageContext.request.contextPath}/articleDetail.jsp?articleId="+articleId+"&userId="+addId);
        }else{
            window.open("${pageContext.request.contextPath}/userHome.jsp?userId="+userId);
        }
    }
    function BBB() {
        jQuery("#1").html('');
        jQuery("#2").html('');
        //查找最新评价
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/mostNewComment?userId=0",
            contentType: false,
            processData: false,
            success: function(data) {
                jQuery("#title").html('最新评价文章');
                jQuery("#table1").html('');
                if(data==null || data==''){
                    jQuery("#table1").html('您目前的文章尚未有最新评价');return;
                }
                jQuery("#table1").append('<tr><td>图片</td><td align="center">文章名称</td><td align="center">文章摘要</td><td align="center">上传时间</td><td align="center">操作</td></tr>\n')
                //遍历回显
                for (i=0;i<data.length;i++){
                    var a = data[i];
                    jQuery("#table1").append('<tr><td><img src="'+a.articleTitlePhoto+'" width="50" height="50" alt=""></td>' +
                        '<td align="center">'+a.articleTitle+'</td>' +
                        '<td align="center">'+a.summary+'</td>' +
                        '<td align="center">'+a.time+'</td>' +
                        '<td  align="center"><a href="${pageContext.request.contextPath}/articleDetail.jsp?articleId='+a.articleId+'&userId=${user.id}" target="_blank" >浏览</a>&nbsp;</td>' +
                        '' +
                        '</tr>')
                }
            }
        });
    }
    function boardU(userId) {
        //先获取留言内容
        var board = jQuery("#board").val();
        if(board==null || board==''){alert("请先输入留言内容");return};
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/userToBoard?userId="+userId+"&content="+board,
            contentType: false,
            processData: false,
            success: function(data) {
                alert("留言成功！");
                CCC();
            }
        });
    }
    //留言版功能
    function CCC() {
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/userBoard?userId=0",
            contentType: false,
            processData: false,
            success: function(data) {
                jQuery("#title").html('我的留言版');
                jQuery("#1").html('');
                jQuery("#2").html('');
                jQuery("#table1").html('');
                //先加一个留言框
                jQuery("#2").append('<br><textarea id="board" style="background: white;" placeholder="请输入留言信息"></textarea><br>\n' +
                    '    <button class="login" onclick="boardU('+data[0].userId+');">上传</button>\n')
                if(data==null || data==''){
                    jQuery("#table1").append('尚未有用户给您留言');return;
                }
                jQuery("#table1").append('<tr><td>留言用户</td><td >留言内容</td><td >留言时间</td></tr>\n')
                //遍历回显
                for (i=0;i<data.length;i++){
                    var a = data[i];
                    jQuery("#table1").append('<tr>' +
                        '<td align="center">'+a.username+'</td>' +
                        '<td align="center"><textarea cols="30" rows="5" style="background: white;border: none;font-size: 20px" disabled>'+a.content+'</textarea></td>' +
                        '<td align="center">'+a.time+'</td>' +
                        '</tr>')
                }
            }
        });
    }
</script>
<body>
<div align="center">
    <span style="color: darkorange; font-size: 25px ">简书</span>&nbsp;
    欢迎，<font style="color: darkorange">${user.username}</font>&nbsp;&nbsp;
    <a href="${pageContext.request.contextPath}/userMain.jsp">个人信息</a>&nbsp;
    <a href="javascript:void(0);" onclick="fuser(0);">关注用户</a><span style="color: black" id="follow"></span>&nbsp;&nbsp;
    <a href="javascript:void(0);" onclick="fuser(1);">我的粉丝</a><span style="color: black" id="fans"></span>&nbsp;&nbsp;
    <a href="javascript:void(0);" onclick="myArticle();">我的文章</a><span style="color: black" id="article"></span>&nbsp;
    <span>收获的喜欢</span><span style="color: black" id="likeNum"></span>&nbsp;&nbsp;
    <a href="javascript:void(0);" onclick="AAAA();">动态</a>&nbsp;
    <a href="javascript:void(0);" onclick="BBB();">最新评价</a>&nbsp;
    <a href="javascript:void(0);" onclick="CCC();">留言版</a>&nbsp;
    <hr>
    <br>
    <span id="title" style="color: blue">个人信息</span>
    <span id="1"></span><span id="2"></span>
    <div>
        <table border="1" id="table1">
            <tr>
                <td width="120">头像：</td>
                <td><input type="file" id="headAddress"/>
                    </td>
                <td><img src="${user.headAddress}" style="width: 100px; height: 100px"  alt="">
                </td>
            </tr>
            <tr>
                <td width="120">用户名：</td>
                <td><input type="text" class="inpI" id="username" value="${user.username}" disabled/>
                </td>
            </tr>
            <tr>
                <td>邮箱：</td>
                <td><input type="text" class="inpI" id="email" value="${user.email}" disabled/></td>
            </tr>
            <tr>
                <td>昵称：</td>
                <td><input type="email" class="inpI" id="nickName" value="${user.nickName}"/></td>
            </tr>
            <tr>
                <td>年龄：</td>
                <td><input type="age" class="inpI" id="age" value="${user.age}" /></td>
            </tr>
            <tr>
                <td>个人简介：</td>
                <td><textarea id="introduction" style="width: 280px;height: 60px;border: 1px;border:1px solid #999; padding:5px 10px;  font-size:14px; border-radius:6px;" >${user.introduction}</textarea></td>
            </tr>
            <tr>
                <td colspan="2"><input type="button" onclick="updateInfo();" class="loginI" value="完成修改" /></td>
            </tr>
            <tr>
                <td colspan="2"><input type="button" onclick="password();" class="login" value="修改密码" /></td>
            </tr>
        </table>

    </div>
</div>

<div class="popOutBg"></div>
<div class="popOut">
    <span title="关闭"> x </span>
    <div id="table"></div>
</div>

<script>
    function updatePassword() {
        var passwordOld = jQuery("#passwordOld").val();
        var passwordNew = jQuery("#passwordNew").val();
        var passwordNewAgain = jQuery("#passwordNewAgain").val();
        if(passwordOld==null||passwordOld==''){alert("请输入原密码！");return}
        if(passwordNew==null||passwordNew==''){alert("请输入新密码！");return}
        if(passwordNewAgain==null||passwordNewAgain==''){alert("请再次输入密码！");return}
        //2.定义正则
        var reg_password = /^\w{6,12}$/;
        //3.判断，给出提示信息
        var flag = reg_password.test(passwordNew);
        if(!flag){alert("请输入6-12位的字符密码！");return;}
        if(passwordNew!=passwordNewAgain){alert("新密码输入不一致！");return;};
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/user/updatePassword?passwordOld="+passwordOld+"&passwordNew="+passwordNew+"&passwordNewAgain="+passwordNewAgain,
            contentType: false,
            processData: false,
            success: function(data) {
                if(data.flag){
                    alert(data.msg);
                    hh();
                }else{
                    alert(data.msg);
                }
            }
        });

    }
    //修改个人信息
    function updateInfo() {
        var nickName = jQuery("#nickName").val();
        var age = jQuery("#age").val();
        var introduction = jQuery("#introduction").val();
        if(nickName==null||nickName==''){alert("输入用昵称！");return;}
        if(age==null||age==''){alert("请输入年龄！");return;}
        if(introduction==null||introduction==''){alert("请输入个人简介！");return;}
        //修改头像
        var formData = new FormData();
        formData.append('upload',jQuery("#headAddress")[0].files[0]);
        var file = jQuery("#headAddress")[0].files[0];
        if(file) {
            var imgStr = /\.(jpg|jpeg|png|bmp|BMP|JPG|PNG|JPEG)$/;
            if (!imgStr.test(file.name)) {
                alert("头像图片格式错误！");
                return;
            }
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/user/updateInfo?nickName="+nickName+"&age="+age+"&introduction="+introduction+"&check=1",
                contentType: false,
                processData: false,
                data:formData,
                success: function(data) {
                    if(data.flag){
                        alert(data.msg);
                        location.reload();
                    }else{
                        alert(data.msg);
                    }
                }
            });
        }
        else{
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/user/updateInfo?nickName="+nickName+"&age="+age+"&introduction="+introduction+"&check=0",
                contentType: false,
                processData: false,
                success: function(data) {
                    if(data.flag){
                        alert(data.msg);
                        location.reload();
                    }else{
                        alert(data.msg);
                    }
                }
            });
        }
    }

</script>
<script type="text/javascript">
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
    function password(){
        jQuery("#table").append('        <table>\n' +
            '            <caption>修改密码</caption>\n' +
            '            <tr>\n' +
            '                <td>原密码</td>\n' +
            '                <td><input type="password" class="inp"  id="passwordOld" placeholder="请输入密码" /></td>\n' +
            '            </tr>\n' +
            '            <tr>\n' +
            '                <td>新密码</td>\n' +
            '                <td><input type="password" class="inp"  id="passwordNew" placeholder="请输入密码，字符密码6-12位" /></td>\n' +
            '            </tr>\n' +
            '            <tr>\n' +
            '                <td>再次输入密码</td>\n' +
            '                <td><input type="password" class="inp"  id="passwordNewAgain" placeholder="请输入密码" /></td>\n' +
            '            </tr>\n' +
            '            <tr>\n' +
            '                <td colspan="2"><input type="button" onclick="updatePassword()" class="login" value="提交" /></td>\n' +
            '            </tr>\n' +
            '        </table>')
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
