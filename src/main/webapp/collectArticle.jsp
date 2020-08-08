<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>收藏的文章</title>
    <script src="js/jquery-3.3.1.js"></script>
    <script>
        function collectArticle() {
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/article/collectArticle",
                contentType: false,
                processData: false,
                success: function(data) {
                    if(data==null || data==''){
                        alert("您还未收藏文章");return;
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
                }
            });
        }
        collectArticle()
    </script>
</head>
<body>
<div align="center">
    <span style="color: darkorange; font-size: 25px ">简书</span>&nbsp;
    欢迎，<font style="color: darkorange">${user.username}</font>&nbsp;
    <hr>
    <br>
    收藏的文章：
<table border="1" id="day">
    <tr><td align="center">文章图片</td><td align="center">标题</td><td align="center" colspan="3">摘要</td><td align="center">相关信息</td></tr>
</table>

</div>
</body>
</html>
