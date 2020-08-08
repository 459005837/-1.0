<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>文章详情页</title>
    <script src="js/jquery-3.3.1.js"></script>
    <script src="js/getParameter.js"></script>

    <script>
        //查询作家信息
        function user() {
            var userId = getParameter("userId");
            var articleId = getParameter("articleId");
            //根据用户的id查询信息
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/userAct/userNums?userId="+userId,
                contentType: false,
                processData: false,
                success: function(data) {
                    jQuery("#username").html('<a href="${pageContext.request.contextPath}/userHome.jsp?userId='+data.userId+'" target="_blank">'+data.username+'</a>');
                    jQuery("#follow").html(data.followsNum);
                    jQuery("#fans").html(data.fansNum);
                    jQuery("#article").html(data.articlesNum);
                    if(${user!=null}){
                        var username = "${user.username}"
                    }
                    if(${user==null}){
                        jQuery("#attention").html('<a href="#" id="con1" onclick="cancelFollow(1,\''+userId+'\',\''+data.checked+'\')" >关注</a>');
                    }else
                    if(username!=data.username){
                        jQuery("#attention").html('<a href="#" id="con1" onclick="cancelFollow(1,\''+userId+'\',\''+data.checked+'\')" >'+data.checked+'</a>');
                    }
                    articleF()
                }
            });
        }
        //取消关注和关注
        function cancelFollow(i,userId,action) {
            if(${user==null}){
                alert("您还未登录！请先登录！");return;
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
                            alert(data.msg);
                            return;
                        }
                    }
                });
            }
        }
        function collectLike(typeId) {
            if(${user==null}){
                jQuery("#like").html('<input type="submit" value="点赞" onclick="like1(\'点赞\',\''+0+'\')" class="login" />\n');
                jQuery("#collect").html('<input type="submit" value="收藏"  onclick="collect1(\'收藏\',\''+0+'\')" class="login" />&nbsp;\n')
            }
            var articleId = getParameter("articleId");
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/article/articleLikeCollect?articleId="+articleId,
                contentType: false,
                processData: false,
                success: function(data) {
                    if(data.id==0){
                        jQuery("#like").html('<input type="submit" value="点赞" onclick="like1(\'点赞\',\''+0+'\')" class="login" />\n');
                        jQuery("#collect").html('<input type="submit" value="收藏"  onclick="collect1(\'收藏\',\''+0+'\')" class="login" />&nbsp;\n')
                    }else{
                        jQuery("#like").html('<input type="submit" value="'+data.likeChecked+'" onclick="like1(\''+data.likeChecked+'\',\''+data.id+'\')" class="login" />\n');
                        jQuery("#collect").html('<input type="submit" value="'+data.collectChecked+'" onclick="collect1(\''+data.collectChecked+'\',\''+data.id+'\')" class="login" />&nbsp;\n')
                    }
                    AAA(typeId);
                }
            });
        }
        //用户点赞文章
        function like1(likeCheck,id) {
            if(${user==null}){
                alert("您还未登录，请先登录！");return;
            }
            var articleId = getParameter("articleId");
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/article/userLikeArticle?likeChecked="+likeCheck+"&id="+id+"&articleId="+articleId,
                contentType: false,
                processData: false,
                success: function(data) {
                    if(data.flag){
                        alert(likeCheck+"成功!");
                        if(likeCheck=='点赞'){
                            jQuery("#like").html('<input type="submit" value="取消点赞" onclick="like1(\'取消点赞\',\''+id+'\')" class="login" />\n');
                        }else{
                            jQuery("#like").html('<input type="submit" value="点赞" onclick="like1(\'点赞\',\''+id+'\')" class="login" />\n');
                        }
                    }else{
                        alert("操作异常！");
                    }
                }
            });
        }
        //用户收藏文章
        function collect1(collectCheck,id) {
            if(${user==null}){
                alert("您还未登录，请先登录！");return;
            }
            var articleId = getParameter("articleId");
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/article/userCollectArticle?collectChecked="+collectCheck+"&id="+id+"&articleId="+articleId,
                contentType: false,
                processData: false,
                success: function(data) {
                    if(data.flag){
                        alert(collectCheck+"成功!");
                        if(collectCheck=='收藏'){
                            jQuery("#collect").html('<input type="submit" value="取消收藏" onclick="collect1(\'取消收藏\',\''+id+'\')" class="login" />\n');
                        }else{
                            jQuery("#collect").html('<input type="submit" value="收藏" onclick="collect1(\'收藏\',\''+id+'\')" class="login" />\n');
                        }
                    }else{
                        alert("操作异常！");
                    }
                }
            });
        }
        //查询文章信息
        function articleF() {
            var articleId = getParameter("articleId");
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/article/updateArticle?articleId="+articleId,
                contentType: false,
                processData: false,
                success: function(data) {
                    jQuery("#commentNum").html(data.commentNum);
                    jQuery("#attentionNum").html(data.collectNum);
                    jQuery("#likeNum").html(data.likeNum);
                    jQuery("#time").html(data.time);
                    jQuery("#content").html(data.content);
                    jQuery("#title").html(data.articleTitle);
                    collectLike(data.typeId);
                }
            });
        }
        user()
    </script>
</head>
<body>
<style>
    .login{ width:120px; height:42px;  border-radius:3px; margin:10px auto;}
</style>
<div align="center">
    <span style="color: darkorange; font-size: 25px ">简书</span>&nbsp;
    欢迎，<font style="color: darkorange">${user.username}</font>&nbsp;&nbsp;文章详情页面
</div>
<hr>
<br>
<div align="center">
    作者信息: <br>
    <span style="color:blue;">作家:</span><span id="username"></span>&nbsp;
    <span style="color:blue;">关注:</span><span id="follow"></span>&nbsp;
    <span style="color:blue;">粉丝:</span><span id="fans"></span>&nbsp;
    <span style="color:blue;">文章:</span><span id="article"></span>&nbsp;
    <span id="attention"></span>
    <br>
    文章信息：<br>
    <span style="color:blue;">评论数:</span><span id="commentNum"></span>&nbsp;
    <span style="color:blue;">点赞数:</span><span id="likeNum"></span>&nbsp;
    <span style="color:blue;">收藏数:</span><span id="attentionNum"></span>&nbsp;
    <span style="color:blue;">创作时间:</span><span id="time"></span>&nbsp;
    <br>
    <hr width="50%">

    <span style="color: blue;">文章标题:</span><span id="title"></span>&nbsp;
    <div id="content"> </div><br>
    <div style="padding-left: 330px;padding-bottom: 20px;padding-top: 10px">
        <div class="bshare-custom">
            <span id="like"> </span>
            <span id="collect"> </span>
            <a title="分享到QQ空间" class="bshare-qzone"></a>
            <a title="分享到新浪微博" class="bshare-sinaminiblog"></a>
            <a title="分享到人人网" class="bshare-renren"></a>
            <a title="分享到腾讯微博" class="bshare-qqmb"></a>
            <a title="分享到网易微博" class="bshare-neteasemb"></a>
            <a title="更多平台" class="bshare-more bshare-more-icon more-style-addthis"></a>
            <span class="BSHARE_COUNT bshare-share-count">0</span>
        </div><script type="text/javascript" charset="utf-8" src="http://static.bshare.cn/b/buttonLite.js#style=-1&amp;uuid=&amp;pophcol=1&amp;lang=zh"></script>
        <script type="text/javascript" charset="utf-8" src="http://static.bshare.cn/b/bshareC0.js"></script>
    </div>
    <br>
    <hr width="50%">
    相关阅读 <br>
    <table border="1" id="day">
        <tr><td align="center">文章图片</td><td align="center">标题</td><td align="center" colspan="3">摘要</td><td align="center">相关信息</td></tr>

    </table>
    <script>
        function AAA(typeId) {
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/article/relevantArticle?typeId="+typeId,
                contentType: false,
                processData: false,
                success: function(data) {
                    if(data== null || data==''){
                        jQuery("#day").html(' ');
                        jQuery("#day").html('暂无相关类型的文章');return;
                    }
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
                    x();
                }
            });
        }
    </script>
    <hr width="50%">
    <script>
        function x() {
            var articleId = getParameter("articleId");
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/article/findComment?articleId="+articleId,
                contentType: false,
                processData: false,
                success: function(data) {
                    if(data==null || data== ''){
                        jQuery("#comment").html("该文章尚无评论");
                        return;
                    }
                    //遍历
                    for (i = 0; i<data.length ;i++){
                        var commentId = data[i].commentId;
                        var content = data[i].content;
                        var username = data[i].username;
                        jQuery("#comment").append('<tr><td>'+data[i].username+'</td><td>&nbsp;评论时间：<span style="color: blue">'+data[i].commentDate+'</span></td></tr>\n' +
                            '        <tr>\n' +
                            '            <td colspan="2">\n' +
                            '                <textarea name="输入评论" disabled style="height: 60px; width: 400px; background: white;color: blue" >'+data[i].content+'</textarea>\n' +
                            '            </td>\n' +
                            '            <td><a href="javascript:void(0);" onclick="reply(\''+commentId+'\',\''+commentId+'\',\''+content+'\',\''+username+'\');">回复</a>&nbsp;' +
                            '<a href="javascript:void(0);" onclick="commentMore('+data[i].commentId+')" >查看更多</a>&nbsp;' +
                            '<a href="javascript:void(0);" id="'+commentId+'1" onclick="likeComment111(\''+commentId+'\',\''+data[i].likeChecked+'\',\''+data[i].likeNum+'\')">'+data[i].likeChecked+'</a>' +
                            '<span id="'+commentId+'num">'+data[i].likeNum+'</span></td>\n' +
                            '        </tr>');
                        jQuery("#comment").append('<div id="'+data[i].commentId+'" style="vertical-align: middle" ></div>')
                    }
                }
            });
        }
        function commentMore(id) {
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/article/findCommentMore?commentId="+id,
                contentType: false,
                processData: false,
                success: function(data) {
                    if(data==null){
                        jQuery("#"+id).html("暂无回复！");
                        return;
                    }
                    //遍历
                    for (i = 0; i<data.length ;i++){
                        jQuery("#"+id).append('<tr><td>'+data[i].frontUsername+'<span style="color: blue">回复</span>'+data[i].behindUsername+'</td>\n' +
                            '            <td colspan="2" align="right">评论时间：<span style="color: blue">'+data[i].commentDate+'</span></td>\n' +
                            '        </tr>\n' +
                            '        <tr>\n' +
                            '            <td colspan="2">\n' +
                            '                <textarea name="输入评论" disabled style="height: 60px; width: 400px; background: white;color: blue" >'+data[i].content+'</textarea>\n' +
                            '            </td>\n' +
                            '            <td><a href="javascript:void(0);" id="'+data[i].upperId+'1" onclick="likeComment111('+data[i].upperId+',\''+data[i].likeChecked+'\',\''+data[i].likeNum+'\')">'+data[i].likeChecked+'</a><span id="'+data[i].upperId+'num">'+data[i].likeNum+'</span>&nbsp;<a href="javascript:void(0);" onclick="reply('+data[i].topperId+','+data[i].upperId+',\''+data[i].content+'\',\''+data[i].frontUsername+'\')">回复</a>&nbsp;</td>\n' +
                            '        </tr>')
                    }
                }
            });
        }
        function likeComment111(id,likeChecked,num){
            if(${user==null}){
                alert("您还未登录！请先登录！");return;
            }
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/userAct/likeComment?commentId="+id+"&action="+likeChecked,
                contentType: false,
                processData: false,
                success: function(data) {
                    alert(likeChecked+"成功！");
                    if(likeChecked=='点赞'){
                        var newnum =  parseInt(num)+1;
                        jQuery("#"+id+"num").html(newnum);
                        jQuery("#"+id+"1").html('取消点赞');
                        jQuery("#"+id+"1").attr('onclick','likeComment111(\''+id+'\',"取消点赞",\''+newnum+'\')');
                    }else{
                        var newnum =  parseInt(num)-1;
                        jQuery("#"+id+"num").html(newnum);
                        jQuery("#"+id+"1").html('点赞');
                        jQuery("#"+id+"1").attr('onclick','likeComment111(\''+id+'\',"点赞",\''+newnum+'\')');
                    }
                }
            })
        }
        //回复功能
        function reply(topperId,upperId,comment,username) {
            jQuery("#commentText").html('');
            //将回复 username的字样添加到品论框中
            jQuery("#commentText").attr('placeholder','回复 '+username+'：'+comment+'');
            jQuery("#takeComment").attr('onclick','comment('+topperId+','+upperId+')');
        }
        //回复
        function comment(topperId,upperId) {
            //先判断是否已经登录
            if(${user==null}){
                alert("您还未登录，不能回复评论！请先登录！");
                return;
            }
            var comment = jQuery("#commentText").val();
            var articleId = getParameter("articleId");
            if(comment==null||comment==''){
                alert("请先输入评论再提交！");
                return;
            }
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/userAct/comment?content="+comment+"&articleId="+articleId+"&topperId="+topperId+"&upperId="+upperId,
                contentType: false,
                processData: false,
                success: function(data) {
                    alert("评论成功！");
                    jQuery("#comment").html("");
                    jQuery("#commentText").attr('placeholder','请输入评论');
                    jQuery("#takeComment").attr('onclick','comment(0,0)');
                    x();
                }
            })
        }
    </script>
    评论详情：
    <table>
        <tr><td><textarea name="输入评论" placeholder="请输入评论" style="height: 100px; width: 500px" id="commentText"></textarea></td>
            <td><button onclick="comment(0,0);" id="takeComment">发布评论</button></td>
        </tr>
    </table>
    <table id="comment" style="border-collapse: separate;border-spacing: 0px 20px"></table>

</div>
</body>
</html>
