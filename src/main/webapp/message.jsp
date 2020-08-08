<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <script src="js/jquery-3.3.1.js"></script>
    <title>消息界面</title>
</head>
<style>
    *{ margin:0; padding:0;}
    .login{ width:120px; height:42px;  border-radius:6px; display: block; margin:20px auto; cursor: pointer;}
    .popOutBgA{ width:100%; height:100%; position: fixed; left:0; top:0; background:rgba(0,0,0,.6); display: none;}
    .popOutA{ position:fixed; width:650px; height:400px; top:35%; left:52%; margin-top:-150px; margin-left:-300px; background: aliceblue; border-radius:8px; overflow: hidden; display: none;}
    .popOutA > span{ position: absolute; right:10px; top:0; height:42px; line-height:42px; color:#000; font-size:30px; cursor: pointer;}
    .popOutA table{ display: block; margin:42px auto 0; width:520px;}
    .popOutA caption{ width:520px; text-align: center; font-size:18px; line-height:42px;}
    .popOutA table tr td{ color:#666; padding:6px; font-size:14px;}
    .popOutA table tr td:first-child{ text-align: center;}
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
    *{ margin:0; padding:0;}
    .login{ width:120px; height:42px;  border-radius:6px; display: block; margin:20px auto; cursor: pointer;}
    .popOutBg{ width:100%; height:100%; position: fixed; left:0; top:0; background:rgba(0,0,0,.6); display: none;}
    .popOut{ position:fixed; width:650px; height:600px; top:25%; left:52%; margin-top:-150px; margin-left:-300px; background: aliceblue; border-radius:8px; overflow: hidden; display: none;}
    .popOut > span{ position: absolute; right:10px; top:0; height:42px; line-height:42px; color:#000; font-size:30px; cursor: pointer;}
    .popOut table{ display: block; margin:42px auto 0; width:520px;}
    .popOut caption{ width:520px; text-align: center; font-size:18px; line-height:42px;}
    .popOut table tr td{ color:#666; padding:6px; font-size:14px;}
    .popOut table tr td:first-child{ text-align: center;}
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
    function newType() {
        var str = prompt("请输入新增的分组","分组名称，1到4个汉字！");
        if(str==null||str==''){
            alert("请输入分组名称！");return;
        }
        var reg_username = /^[\u4E00-\u9FA5]{2,4}$/;
        //3.判断，给出提示信息
        var flag = reg_username.test(str);
        if(!flag){
            alert("分组名称长度为一至四个汉字");return;
        }
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/newChatType?typeName="+str,
            contentType: false,
            processData: false,
            success: function(data) {
                if(data.flag){
                    alert(data.msg);
                    jQuery("#12").html('');
                    chatType();
                }else{
                    alert(data.msg);
                }
            }
        });
    }
    function chatType() {
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/userChatType",
            contentType: false,
            processData: false,
            success: function(data) {
                jQuery("#12").append('<button onclick="chatUser(0)">全部</button>\n')
                if(data==null){
                    jQuery("#12").append('<a href="javascript:void(0);" onclick="newType();">新建分组</a>\n\n');
                    chatUser(0);
                    return;
                }
                //遍历回显
                for (i=0;i<data.length;i++){
                    var user = data[i];
                    jQuery("#12").append('<button onclick="chatUser('+user.chatTypeId+')">'+user.typeName+'</button>\n')
                }
                jQuery("#12").append('<a href="javascript:void(0);" onclick="newType();">新建分组</a>\n\n');
                chatUser(0);
            }
        });
    }
    chatType();
    function chatUser(typeId) {
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/userChat?chatTypeId="+typeId,
            contentType: false,
            processData: false,
            success: function(data) {
                if(data==null){
                    jQuery("#table1").html('该分组中未有好友');return;
                }
                jQuery("#table1").html('');
                jQuery("#table1").append('<tr><td align="center">用户头像</td><td align="center">发送用户</td><td align="center">最新消息</td><td align="center">操作</td></tr>\n')
                //遍历回显
                for (i=0;i<data.length;i++){
                    var user = data[i];
                    jQuery("#table1").append('<tr><td><img src="'+user.headAddress+'" width="50" height="50" alt=""></td>' +
                        '<td align="center">'+user.username+'</td>' +
                        '<td align="center">'+user.message+'</td>' +
                        '<td align="center">'+user.checked+'</td>' +
                        '<td align="center"><a href="javascript:void(0);" onclick="Amessage(\''+user.username+'\',\''+user.chatId+'\','+user.chatUserId+')">发消息</a>&nbsp;' +
                        '<a href="javascript:void(0);" onclick="appealUser('+user.chatUserId+')">举报</a>&nbsp;' +
                        '<a href="javascript:void(0);" onclick="ABC('+user.chatUserId+',\''+user.checked+'\')">拉黑</a>&nbsp;' +
                        '<a href="javascript:void(0);" onclick="CBA('+user.chatUserId+',\''+user.checked+'\')">解除拉黑</a>&nbsp;' +
                        '</td></tr>')
                }
            }
        });
    }
    function ABC(userId,checked) {
        if(checked!='正常'){
            alert("该用户已处于拉黑状态");return;
        }
        if(confirm("您确定将该用户拉黑吗，拉黑后对方将无法关注您，将自动从您的粉丝中移除，且无法给您发消息")){
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/userAct/blockUser?userId="+userId,
                contentType: false,
                processData: false,
                success: function(data) {
                    alert("拉黑成功！");
                    chatUser(0);
                }
            });
        }
    }
    function CBA(userId,checked) {
        if(checked=='正常'){
            alert("该用户为正常状态");return;
        }
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/okBlock?userId="+userId,
            contentType: false,
            processData: false,
            success: function(data) {
                alert("解除成功！");
                chatUser(0);
            }
        });

    }
    function Amessage(username,chatId,userId) {
        //先判断用户是否已经在黑名单
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/judgeBlock?userId="+userId,
            contentType: false,
            processData: false,
            success: function(data) {
                if(data.flag){
                    alert("对方已经把你拉进黑名单！不能发消息！");return;
                }else{
                    Bmessage(username,chatId);
                }
            }
        });
    }
    function accept(chatId) {
        //根据id查找消息
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/chatMessage?chatId="+chatId+"&start="+start,
            contentType: false,
            processData: false,
            success: function(data) {
                if(data!=null && data!=''){
                    //先拿到第一次查询的总记录数
                    if(start==0){
                        start = data[0].count;
                    }else{
                        start = start + 1;
                    }
                    //遍历回显
                    for (i=0;i<data.length;i++){
                        var user = data[i];
                        jQuery("#messageT").prepend(user.username+":&#10;"+user.message+" "+user.time+"&#10;&#10;");
                    }
                }
            }
        });
    }
    //发送消息
    function sendM(chatId) {
        //停止定时
        clearInterval(timer1);
        var message = jQuery("#sedMessage").val();
        if(message==null||message==''){alert("请输入消息!");return;}
        jQuery.ajax({
            type: "POST",
            url:"${pageContext.request.contextPath}/userAct/sendMessage?chatId="+chatId+"&message="+message,
            contentType: false,
            processData: false,
            success: function(data) {
                if(data.flag){
                    jQuery("#sedMessage").val("");
                }else{
                    alert(data.msg);
                }
            }
        });
        timer1 = setInterval(function(){accept(chatId)}, 500);　　　　// 要给函数用闭包的形
    }
</script>
<body>
<div align="center">
    <span style="color: darkorange; font-size: 25px ">简书</span>&nbsp;
    欢迎，<font style="color: darkorange">${user.username}</font>&nbsp;&nbsp;
    <hr>
    <span id="title">好友信息</span> <br>
    <br>好友分组：
    <span id="12"></span>
    <table border="1" id="table1">
    </table>
    <div class="popOutBg"></div>
    <div class="popOut">
        <span title="关闭"> x </span>
        <div id="table"></div>
    </div>

    <div class="popOutBgA"></div>
    <div class="popOutA">
        <span title="关闭"> x </span>
        <div id="tableA"></div>
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
    function Bmessage(username,chatId){
        jQuery("#table").html('');
        jQuery("#table").append('        <table>\n' +
            '            <caption>与'+username+'的对话</caption>\n' +
            '            <tr>\n' +
            '                <td><textarea disabled style="width: 500px;height: 300px;background: white; font-size: 25px" id="messageT"></textarea></td>\n' +
            '            </tr>\n' +
            '            <tr>\n' +
            '                <td ><input type="text" class="inp" id="sedMessage" /></td>\n' +
            '            </tr>\n' +
            '            <tr>\n' +
            '                <td ><input type="button" onclick="sendM('+chatId+')" class="login" value="发送" /></td>\n' +
            '            </tr>\n' +
            '        </table>')
        start = 0;
        accept(chatId);
        timer1 = setInterval(function(){accept(chatId)}, 500);　　　　// 要给函数用闭包的形势
        $(".popOut").style.display = "block";
        ani();
        $(".popOutBg").style.display = "block";
    };
    function hh(){
        $(".popOut").style.display = "none";
        $(".popOutBg").style.display = "none";
    }
    $(".popOut > span").onclick = function(){
        clearInterval(timer1);
        $(".popOut").style.display = "none";
        $(".popOutBg").style.display = "none";
    };
    $(".popOutBg").onclick = function(){
        clearInterval(timer1);
        $(".popOut").style.display = "none";
        $(".popOutBg").style.display = "none";
    };
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
        $(".popOutA").className = "popOutA ani";
    }
    function appeall(userId) {
        //获取详情
        var detail = jQuery("#detail").val();
        if(detail==null||detail==''){alert("请输入详细描述！");return;}
        //获取配图
        var formData = new FormData();
        formData.append('file',jQuery("#file")[0].files[0]);
        var file = jQuery("#file")[0].files[0];
        if(file) {
            var imgStr = /\.(jpg|jpeg|png|bmp|BMP|JPG|PNG|JPEG)$/;
            if (!imgStr.test(file.name)) {
                alert("头像图片格式错误！");
                return;
            }
            jQuery.ajax({
                type: "POST",
                url:"${pageContext.request.contextPath}/userAct/appealUser?appealUserId="+userId+"&appealDetail="+detail,
                contentType: false,
                processData: false,
                data:formData,
                success: function(data) {
                    alert("举报成功！管理员将根据实际情况进行封号处理!");hhh();
                }
            });
        }else{
            alert("请选择配图");return;
        }
    }
    function appealUser(userId){
        jQuery("#tableA").html('');
        jQuery("#tableA").append('        <table>\n' +
            '            <caption>举报用户</caption>\n' +
            '            <tr>\n' +
            '                <td>举报配图</td><td ><input type="file" id="file" /></td>\n' +
            '            </tr>\n' +
            '            <tr>\n' +
            '                <td>举报详情</td><td ><input type="text" class="inp" id="detail" /></td>\n' +
            '            </tr>\n' +
            '            <tr>\n' +
            '                <td colspan="2" align="center"><input type="button" onclick="appeall('+userId+')" class="login" value="提交" /></td>\n' +
            '            </tr>\n' +
            '        </table>')
        $(".popOutA").style.display = "block";
        ani();
        $(".popOutBgA").style.display = "block";
    };
    function hhh(){
        $(".popOutA").style.display = "none";
        $(".popOutBgA").style.display = "none";
    }
    $(".popOutA > span").onclick = function(){
        $(".popOutA").style.display = "none";
        $(".popOutBgA").style.display = "none";
    };
    $(".popOutBgA").onclick = function(){
        $(".popOutA").style.display = "none";
        $(".popOutBgA").style.display = "none";
    };
</script>
</body>
</html>
