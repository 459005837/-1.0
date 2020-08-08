<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>用户主页</title>
</head>
<script src="js/jquery-3.3.1.js"></script>
<script src="js/getParameter.js"></script>
<style>
    .inpI{ width:280px; height:30px; line-height:30px; border:1px solid #999; padding:5px 10px;  font-size:14px; border-radius:6px;}
    .loginI{ width:120px; height:42px;  border-radius:6px; display: block; margin:20px auto; cursor: pointer;}
     .login{ width:120px; height:42px;  border-radius:3px; margin:10px auto;}
</style>
<script>
    //查询登录用户的关注人数还有粉丝数，还有文章数,以及收获的喜欢
    function nums() {
        var userId = getParameter("userId");
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/userNums?userId="+userId,
            contentType: false,
            processData: false,
            success: function(data) {
                jQuery("#follow").html(data.followsNum);
                jQuery("#fans").html(data.fansNum);
                jQuery("#article").html(data.articlesNum);
                jQuery("#likeNum").html(data.likesNum);
                follow = data.followsNum;
                fans = data.fansNum;
                userU();
            }
        });
    }
    nums();
    function userU() {
        var userId = getParameter("userId");
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/user?userId="+userId,
            contentType: false,
            processData: false,
            success: function(data) {
                jQuery("#useruser").html(data.username);
                jQuery("#username").attr('value',data.username);
                jQuery("#email").attr('value',data.email);
                jQuery("#age").attr('value',data.age);
                jQuery("#introduction").html(data.introduction);
                jQuery("#img").html('<img src="'+data.headAddress+'" style="width: 100px; height: 100px"  alt="">')
                jQuery("#nickName").attr('value',data.nickName);
            }
        });
    }

    function fuser(check) {
        var userId = getParameter("userId");
        jQuery("#1").html('');
        jQuery("#2").html('');
        if(check==0){
            if(follow==0){
                alert("该用户暂未关注作者！");return;
            }
        }else{
            if(fans==0){
                alert("该用户暂无粉丝！");return;
            }
        }
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/followUser?check="+check+"&userId="+userId,
            contentType: false,
            processData: false,
            success: function(data) {
                if(check==0){
                    jQuery("#title").html("关注的用户");
                }else{
                    jQuery("#title").html("粉丝");
                }
                jQuery("#table1").html('');
                jQuery("#table1").append('<tr><td>头像</td><td align="center">用户名</td><td align="center">相关信息</td><td align="center">操作</td></tr>\n')
                //遍历回显
                for (i=0;i<data.length;i++){
                    var user = data[i];
                    jQuery("#table1").append('<tr><td><img src="'+user.headAddress+'" width="50" height="50" alt=""></td>' +
                        '<td align="center"><a href="${pageContext.request.contextPath}/userHome.jsp?userId='+user.userId+'" target="_blank">'+user.username+'</a></td>' +
                        '<td align="center">关注：'+user.followsNum+'，粉丝：'+user.fansNum+'，文章：'+user.articlesNum+'，收获的喜欢：'+user.likesNum+'</td>' +
                        '<td align="center"><a href="javascript:void(0);" onclick="cancelFollow(\''+i+'\',\''+user.userId+'\',\''+user.checked+'\')" id="con'+i+'">'+user.checked+'</a></td></tr>')
                }
            }
        });
    }

    //取消关注和关注
    function cancelFollow(i,userId,action) {
        if(${user==null}){
            alert("您还未登录！");return;
        }
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
        jQuery("#title").html('文章信息')
        //先查询获得文章数据分为草稿箱还有已发布
        finda(1);
    }

    function finda(check) {
        var userId = getParameter("userId");
        //check 1表示查询已经发布的，0表示查询草稿箱的
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/article/userArticle?check="+check+"&userId="+userId,
            contentType: false,
            processData: false,
            success: function(data) {
                jQuery("#table1").html('');
                if(data==null){
                    if(check==1){
                        jQuery("#table1").html('该用户还未发布文章！');
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
                        '<td align="center">' +
                        '<a href="${pageContext.request.contextPath}/articleDetail.jsp?articleId='+a.articleId+'&userId=${user.id}" target="_blank" >浏览</a>&nbsp;</td></tr>')
                }
            }
        });
    }

    //显示我的动态
    function AAAA() {
        jQuery("#1").html('');
        jQuery("#2").html('');
        var userId = getParameter("userId");
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/userAction?userId="+userId,
            contentType: false,
            processData: false,
            success: function(data) {
                jQuery("#title").html("用户动态");
                jQuery("#table1").html('');
                if(data==null || data==''){
                        jQuery("#table1").html('该用户还没有动态！');return;
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
        var userId = getParameter("userId");
        //查找最新评价
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/mostNewComment?userId="+userId,
            contentType: false,
            processData: false,
            success: function(data) {
                jQuery("#title").html('最新评价文章');
                jQuery("#table1").html('');
                if(data==null || data==''){
                    jQuery("#table1").html('该用户目前的文章尚未有最新评价');return;
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
        if(${user==null}){
            alert("您还未登录！");return;
        }
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
        var userId = getParameter("userId");
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/userBoard?userId="+userId,
            contentType: false,
            processData: false,
            success: function(data) {
                jQuery("#title").html('留言版');
                jQuery("#1").html('');
                jQuery("#2").html('');
                jQuery("#table1").html('');
                //先加一个留言框
                if(data==null || data=='') {
                    jQuery("#2").append('<br><textarea id="board" style="background: white;" placeholder="请输入留言信息"></textarea><br>\n' +
                    '    <button class="login" onclick="boardU('+userId+');">上传</button>\n')
                }else{
                    jQuery("#2").append('<br><textarea id="board" style="background: white;" placeholder="请输入留言信息"></textarea><br>\n' +
                        '    <button class="login" onclick="boardU('+data[0].userId+');">上传</button>\n')
                }
                if(data==null || data==''){
                    jQuery("#table1").append('尚未有用户留言');return;
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
    function uuu() {
        location.reload();
    }
</script>
<body>
<div align="center">
    <span style="color: darkorange; font-size: 25px ">简书</span>&nbsp;
    欢迎<span id="useruser"> </span>主页 &nbsp;
    <a href="javascript:void(0);" onclick="uuu();">个人信息</a>&nbsp;
    <a href="javascript:void(0);" onclick="fuser(0);">关注</a><span style="color: black" id="follow"></span>&nbsp;&nbsp;
    <a href="javascript:void(0);" onclick="fuser(1);">粉丝</a><span style="color: black" id="fans"></span>&nbsp;&nbsp;
    <a href="javascript:void(0);" onclick="myArticle();">文章</a><span style="color: black" id="article"></span>&nbsp;
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
                <td id="img">
                </td>
            </tr>
            <tr>
                <td width="120">用户名：</td>
                <td><input type="text" class="inpI" id="username" disabled/>
                </td>
            </tr>
            <tr>
                <td>邮箱：</td>
                <td><input type="text" class="inpI" id="email" disabled/></td>
            </tr>
            <tr>
                <td>昵称：</td>
                <td><input type="email" class="inpI" id="nickName"  disabled/></td>
            </tr>
            <tr>
                <td>年龄：</td>
                <td><input type="age" class="inpI" id="age" disabled /></td>
            </tr>
            <tr>
                <td>个人简介：</td>
                <td><textarea id="introduction" style="width: 280px;height: 60px;border: 1px;border:1px solid #999; padding:5px 10px;  font-size:14px; border-radius:6px;" >/textarea></td>
            </tr>
        </table>

    </div>
</div>

<div class="popOutBg"></div>
<div class="popOut">
    <span title="关闭"> x </span>
    <div id="table"></div>
</div>

</body>
</html>
