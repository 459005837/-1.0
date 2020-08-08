<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="js/jquery-3.3.1.js"></script>
    <title>关注界面</title>
</head>
<body>
<style>
    *{ margin:0; padding:0;}
    .login{ width:120px; height:42px;  border-radius:6px; display: block; margin:20px auto; cursor: pointer;}
    .popOutBg{ width:100%; height:100%; position: fixed; left:0; top:0; background:rgba(0,0,0,.6); display: none;}
    .popOut{ position:fixed; width:600px; height:200px; top:45%; left:52%; margin-top:-150px; margin-left:-300px; background: aliceblue; border-radius:8px; overflow: hidden; display: none;}
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
    .login{ width:120px; height:42px;  border-radius:3px; margin:10px auto;}
</style>
<script>
    fuser(0)
    function fuser(check) {
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/followUser?check="+check+"&userId=0",
            contentType: false,
            processData: false,
            success: function(data) {
                str = 0;
                if(data==''){
                    jQuery("#table1").html('您还没有关注的作者');
                    str = 1;
                    return;
                }
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
                        '<td align="center">'+user.username+'</td>' +
                        '<td align="center">关注：'+user.followsNum+'，粉丝：'+user.fansNum+'，文章：'+user.articlesNum+'，收获的喜欢：'+user.likesNum+'</td>' +
                        '<td align="center"><a href="javascript:void(0);" onclick="addChat('+user.userId+')">添加简信</a>&nbsp;' +
                        '<a href="javascript:void(0);" onclick="">主页</a>' +
                        '</td></tr>')
                }
            }
        });
    }
    function addChat(userId) {
        RR(userId);
    }
    function aa(userId) {
        //接收类型
        var findType = jQuery("#select option:selected").val();
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/addChat?userId="+userId+"&chatTypeId="+findType,
            contentType: false,
            processData: false,
            success: function(data) {
                if(data.flag){
                    alert(data.msg);
                    hh()
                    window.open("${pageContext.request.contextPath}/message.jsp");
                }else{
                    alert(data.msg);
                    hh()
                }
            }
        });
    }
    function articleA() {
        if(str==1){
            jQuery("#table1").html('暂无相关作者的文章，请先关注！');return;
        }
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/followUserArticle",
            contentType: false,
            processData: false,
            success: function(data) {
                jQuery("#table1").html('');
                if(data==null){
                    jQuery("#table1").html('您关注的用户暂未发布文章');return;
                }
                jQuery("#table1").append('      <tr><td align="center">文章图片</td><td align="center">标题</td><td align="center" colspan="3">摘要</td><td align="center">相关信息</td></tr>\n\n')
                //遍历回显
                for ( i = 0;i<data.length;i++){
                    var article = data[i];
                    jQuery("#table1").append('<tr>\n' +
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
            }
        });
    }
</script>
<div align="center">
    <span style="color: darkorange; font-size: 25px ">简书</span>&nbsp;
    欢迎，<font style="color: darkorange">${user.username}</font>&nbsp;&nbsp;
    <hr>
    <br>
    <input type="submit" value="我的关注" onclick="fuser(0)" class="login" />
    <input type="submit" value="相关文章" onclick="articleA();" class="login" />
    <table border="1" id="table1">

    </table>

    <div class="popOutBg"></div>
    <div class="popOut">
        <span title="关闭"> x </span>
        <div id="table"></div>
    </div>

    <script>
        function select() {
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/userAct/userChatType",
                contentType: false,
                processData: false,
                success: function(data) {
                    for ( i = 0;i<data.length;i++){
                        jQuery("#select").append('<option value ="'+data[i].chatTypeId+'">'+data[i].typeName+'</option>');
                    }
                }
            });
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
        function RR(userId){
            jQuery("#table").html('');
            jQuery("#table").append('        <table>\n' +
                '            <caption>设置分组</caption>\n' +
                '            <tr>\n' +
                '                <td>选择分组</td>\n' +
                '                <td><select id="select"></select></td>\n' +
                '            </tr>\n' +
                '            <tr>\n' +
                '                <td colspan="2"><input type="button"  onclick="aa('+userId+');" class="login" value="确定" /></td>\n' +
                '            </tr>\n' +
                '        </table>')
            $(".popOut").style.display = "block";
            ani();
            $(".popOutBg").style.display = "block";
            select();
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

</div>

</body>
</html>
