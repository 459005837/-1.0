<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>管理员首页</title>
</head>
<script src="js/jquery-3.3.1.js"></script>
<style>
    *{ margin:0; padding:0;}
    .login{ width:120px; height:42px;  border-radius:6px; display: block; margin:20px auto; cursor: pointer;}
    .popOutBg{ width:100%; height:100%; position: fixed; left:0; top:0; background:rgba(0,0,0,.6); display: none;}
    .popOut{ position:fixed; width:550px; height:250px; top:45%; left:52%; margin-top:-150px; margin-left:-300px; background: aliceblue; border-radius:8px; overflow: hidden; display: none;}
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
<body>
<script>
    function select() {
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/article/articleType",
            contentType: false,
            processData: false,
            success: function(data) {
                jQuery("#title").html('文章管理');
                jQuery("#findx").html('<input type="text" id="findStr" placeholder="请输入关键词">');
                jQuery("#buttonA").html('<button id="find" onclick="findA();" >查找</button>');
                for ( i = 0;i<data.length;i++){
                    jQuery("#select").append('<option value ="'+data[i].typeId+'">'+data[i].typeName+'</option>');
                }
                load(1,null,1);
            }
        });
    }
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
                        '      <td>\n' +
                        '         <a href="javascript:void(0)" onclick="topArticle('+article.articleId+')">置顶文章</a> <a href="javascript:void(0)" onclick="deleteA(\''+article.articleId+'\',\''+article.articleTitle+'\')">删除文章</a>\n' +
                        '      </td>\n' +
                        '    </tr>\n\n';
                    route_lis += li;
                }
                jQuery("#list").html("");
                jQuery("#list").append('      <tr><td align="center">文章图片</td><td align="center">标题</td><td align="center" colspan="3">摘要</td><td align="center">相关信息</td><td align="center">操作</td></tr>\n');
                jQuery("#list").append(route_lis);
            }
        });
    }
    select();
    function findA() {
        //获取类型，获取查找关键词
        var findStr = jQuery("#findStr").val();
        var findType = jQuery("#select option:selected").val();
        load(1,findStr,findType);
    }

    //设置置顶文章
    function topArticle(articleId) {
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/manager/topArticle?articleId="+articleId,
            contentType: false,
            processData: false,
            success: function(data) {
                alert("置顶成功！用户首页会展示最近置顶的三篇文章！");
            }
        });
    }
    //删除文章
    function deleteA(articleId,title) {
        alert(articleId)
        if(confirm("您确定删除 "+title+" 这篇文章吗？")){
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/manager/deleteArticle?articleId="+articleId,
                contentType: false,
                processData: false,
                success: function(data) {
                    if(data.flag){
                        alert(data.msg);
                        load(1,null,1);
                    }else{
                        alert(data.msg);
                    }
                }
            });
        }
    }
    function findUser() {
        var username = jQuery("#findUser").val();
        if(username==null||username==''){alert("请先输入用户！");return};
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/manager/findUser?username="+username,
            contentType: false,
            processData: false,
            success: function(data) {
                if(data == null ||data == ''){
                    alert("查无此人！");return;
                }
                jQuery("#list").html('');
                for (i=0;i<data.length;i++){
                    var user = data[i];
                    jQuery("#list").append('<tr><td><img src="'+user.headAddress+'" width="50" height="50" alt=""></td>' +
                        '<td align="center">'+user.username+'</td>' +
                        '<td align="center">关注：'+user.followsNum+'，粉丝：'+user.fansNum+'，文章：'+user.articlesNum+'，收获的喜欢：'+user.likesNum+'</td>' +
                        '<td align="center"><a href="javascript:void(0);" onclick="RR('+user.userId+')">封号</a>&nbsp;' +
                        '<a href="javascript:void(0);" onclick="BB('+user.userId+')">解封</a>' +
                        '</td></tr>')
                }
            }
        });
    }
function actionA(userId) {
    //获取封号天数
    var number = jQuery("#number").val();
    if(number<1 || number > 365){alert("请选择合理的封号天数");return;}
    jQuery.ajax({
        type: "POST",
        url:"${pageContext.request.contextPath}/manager/sealUser?userId="+userId+"&number="+number,
        contentType: false,
        processData: false,
        success: function(data) {
            alert("封号成功！");hh();
        }
    });
}
function BB(userId) {
    jQuery.ajax({
        type: "POST",
        url:"${pageContext.request.contextPath}/manager/sealUserOK?userId="+userId,
        contentType: false,
        processData: false,
        success: function(data) {
            alert(data.msg);
        }
    });
}
function userA() {
    jQuery.ajax({
        type: "POST",
        url:"${pageContext.request.contextPath}/manager/userDisplay",
        contentType: false,
        processData: false,
        success: function(data) {
            //先把其他的内容清空
            jQuery("#title").html('用户管理');
            jQuery("#findx").html('<input type="text" id="findUser" placeholder="请输入用户名">');
            jQuery("#select").html(' ');
            jQuery("#buttonA").html('<button id="find" onclick="findUser();" >查找</button>');
            jQuery("#total").html('');
            jQuery("#pageNum").html('');
            //设置用户的显示
            jQuery("#list").html('');
            //遍历回显
            for (i=0;i<data.length;i++){
                var user = data[i];
                jQuery("#list").append('<tr><td><img src="'+user.headAddress+'" width="50" height="50" alt=""></td>' +
                    '<td align="center"><a href="${pageContext.request.contextPath}/userHome.jsp?userId='+user.userId+'" target="_blank">'+user.username+'</a></td>' +
                    '<td align="center">关注：'+user.followsNum+'，粉丝：'+user.fansNum+'，文章：'+user.articlesNum+'，收获的喜欢：'+user.likesNum+'</td>' +
                    '<td align="center"><a href="javascript:void(0);" onclick="RR('+user.userId+')">封号</a>&nbsp;' +
                    '<a href="javascript:void(0);" onclick="BB('+user.userId+')">解封</a>' +
                    '</td></tr>')
            }
        }
    });
}
function appealA() {
    jQuery.ajax({
        type: "POST",
        url:"${pageContext.request.contextPath}/manager/appealDisplay",
        contentType: false,
        processData: false,
        success: function(data) {
            //先把其他的内容清空
            jQuery("#title").html('用户举报管理');
            jQuery("#findx").html('');
            jQuery("#select").html('');
            jQuery("#buttonA").html(' ');
            jQuery("#total").html('');
            jQuery("#pageNum").html('');
            jQuery("#list").html('');
            if(data==null || data==''){
                jQuery("#list").html('尚未有用户举报');return;
            }
            jQuery("#list").append('<tr><td align="center">举报配图</td><td align="center">用户</td><td align="center">举报对象</td><td align="center">详情</td><td align="center">操作</td></tr>')
            //遍历回显
            for (i=0;i<data.length;i++){
                var appeal = data[i];
                jQuery("#list").append('<tr><td><img src="'+appeal.appealPhoto+'" width="50" height="50" alt=""></td>' +
                    '<td align="center">'+appeal.username+'</td>' +
                    '<td align="center">'+appeal.appealUsername+'</td>' +
                    '<td align="center">'+appeal.appealDetail+'</td>' +
                    '<td align="center">' +
                    '<a href="javascript:void(0);" onclick="deleteAppeal('+appeal.appealId+')">删除</a>' +
                    '</td></tr>')
            }
        }
    });
}
function deleteAppeal(appealId) {
    if(confirm("您确定删除这条举报信息吗！")){
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/manager/deleteAppeal?appealId="+appealId,
            contentType: false,
            processData: false,
            success: function(data) {
                if(data.flag){
                    alert(data.msg);appealA();return;
                }else{
                    alert(data.msg);
                }
            }
        });
    }
}
</script>
<div align="center">
    <span style="color: darkorange; font-size: 25px ">简书</span>&nbsp;
    管理员界面</font>&nbsp;&nbsp;
    <a href="javascript:void(0);" onclick="select()">文章管理</a>&nbsp;
    <a href="javascript:void(0);" onclick="userA()">用户管理</a>&nbsp;
    <a href="javascript:void(0);" onclick="appealA()" >举报管理</a>&nbsp;
    <hr>
    <span id="title">

    </span>
    <div id="findx">

    </div>

    <select name="" id="select">

    </select>
    <div id="buttonA">

    </div>

    <table id="list" border="1" >

    </table>
    <ul class="pagination" >
        <div id="pageNum">

        </div>
        <span style="font-size: 25px;margin-left: 5px;" id="total">

        </span>
    </ul>

    <div class="popOutBg"></div>
    <div class="popOut">
        <span title="关闭"> x </span>
        <div id="table"></div>
    </div>
</div>
<script>
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
        //现根据用户id查询用户是否已处于封号状态
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/manager/findUserSeal?userId="+userId,
            contentType: false,
            processData: false,
            success: function(data) {
                if(data.flag){
                    alert("用户已处于封号状态！请勿重复封号！");return;
                }
            }
        });
        jQuery("#table").html('');
        jQuery("#table").append('        <table>\n' +
            '            <caption>封号处理</caption>\n' +
            '            <tr>\n' +
            '                <td>请选择封号天数</td>\n' +
            '                <td><input type="number" class="inp" id="number" min="1" max="365"/></td>\n' +
            '            </tr>\n' +
            '            <tr>\n' +
            '                <td colspan="2"><input type="button"  onclick="actionA('+userId+');" class="login" value="完成" /></td>\n' +
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
