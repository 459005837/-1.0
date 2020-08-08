<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html >
<html>
  <head>
    <title>MarkDown</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<link rel="stylesheet" href="editormd/examples/css/style.css" />
    <link rel="stylesheet" href="editormd/css/editormd.css" />
      <script src="js/jquery-3.3.1.js"></script>
      <script src="editormd/editormd.min.js"></script>
      <script src="js/getParameter.js"></script>
      <style>
          .inp{ width:280px; height:30px; line-height:30px; border:1px solid #999; padding:5px 10px;  font-size:14px; border-radius:6px;}
          .login{ width:120px; height:42px;  border-radius:3px; margin:10px auto;}
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
                      c();
                  }
              });
          }
          function c(){
              var articleId = getParameter("articleId");
              if(articleId!=null && articleId!=''){
                  //回显信息,查询文章信息
                  jQuery.ajax({
                      type: "POST",
                      url:"${pageContext.request.contextPath}/article/updateArticle?articleId="+articleId,
                      contentType: false,
                      processData: false,
                      success: function(data) {
                          //回显内容，图片标题等等
                          jQuery("#editormd").html(data.mdDb);
                          jQuery("#title").attr('value',data.articleTitle)
                          jQuery("#summary").attr('value',data.summary)
                          jQuery("#keyWord").attr('value',data.keyWord)
                          jQuery("#selectInfo").html('文章类型恢复默认，请再次选择');
                          jQuery("#img").html('<img src="'+data.articleTitlePhoto+'" width="50" height="50" alt="">\n');
                      }
                  });
              }
          }
      </script>
  </head>
  <body>
  <div align="center">
      <span style="color: darkorange; font-size: 25px ">简书</span>&nbsp;
          欢迎，<font style="color: darkorange">${user.username}</font>&nbsp;&nbsp;文章编辑页面
  </div>
  <hr>
  <br>
  标题：<input type="text"id="title" class="inp" placeholder="4到10个汉字"> 摘要：<input type="text"id="summary" placeholder="8到12个汉字" class="inp">
  用户搜索关键字：<input type="text"id="keyWord" class="inp" ><br>
  标题配图：<input type="file"id="head" >
  文章类别：  <select name="" id="select"></select><span style="color:red;" id="selectInfo"></span>
  <div align="center">
      <span id="img"></span>
          <input type="submit" value="发布" class="login" onclick="ok(1)"/>
      <input type="submit" value="保存草稿" class="login" onclick="ok(0)"/>
  </div>
  <div id="layout">
            <header></header>
      <div id="test-editormd">
                <textarea style="display:none;" class="editormd-html-textarea" id="editormd"></textarea>
				<textarea class="editormd-html-textarea" name="text" id="editormdhtml"></textarea>
            </div>
        </div>
  <script type="text/javascript">
			var testEditor;
            jQuery(function() {
                testEditor = editormd("test-editormd", {
                    width   : "90%",
                    height  : 600,
                    syncScrolling : "single",
                    htmlDecode      : "style,script,iframe",
                    path    : "editormd/lib/",
                    taskList        : true,
                    emoji           : true,
                    tex             : true,  // 默认不解析
                    flowChart       : true,  // 默认不解析
                    sequenceDiagram : true,  // 默认不解析
                    imageUpload : true,
                    imageFormats : ["jpg","jpeg","gif","png","bmp","webp"],
                    imageUploadURL : "${pageContext.request.contextPath}/PicSvl",
                    saveHTMLToTextarea : true
                });
                select();
            });
            //保存，发布文章
            function ok(check){
            	var htmlco = " "+jQuery("#editormdhtml").val();
            	var mdco = jQuery("#editormd").val();
            	var title = jQuery("#title").val();
            	var summary = jQuery("#summary").val();
            	var keyWord = jQuery("#keyWord").val();
                var type = jQuery("#select option:selected").val();


                var reg_username1 = /^[\u4E00-\u9FA5]{4,10}$/;
                var reg_username2 = /^[\u4E00-\u9FA5]{8,12}$/;
                if(!reg_username1.test(title)){
                    alert("文章标题请按置顶规格填写");return;
                }
                if(!reg_username2.test(summary)){
                    alert("文章摘要请按置顶规格填写");return;
                }



                if(mdco==null||mdco==''){alert("您还未编写文章！");return;}
                if(title==null||title==''){alert("请填写文章标题");return;}
                if(summary==null||summary==''){alert("请输入文章摘要");return;}
                if(keyWord==null||keyWord==''){alert("请输入关键词");return;}



                var file = jQuery("#head")[0].files[0];
                var formData = new FormData();
                formData.append('upload',jQuery("#head")[0].files[0]);
                formData.append('content',htmlco);
                formData.append('mdDb',mdco);
                var articleId = getParameter("articleId");
                if(articleId==null||articleId==''){
                    if(!file){
                        alert("请选择文章标题配图");return;
                    }
                }if(file) {
                    var imgStr = /\.(jpg|jpeg|png|bmp|BMP|JPG|PNG|JPEG)$/;
                    if (!imgStr.test(file.name)) {
                        alert("图片格式错误！");
                        return;
                    }
                    jQuery.ajax(
                        {   data:formData,
                            dataType:"text",
                            type:"post",
                            contentType: false,
                            processData: false,
                            success: function(data){
                                    alert("文章发布成功！");
                                    location.reload();
                                },
                            type:'post',
                            url:"${pageContext.request.contextPath}/userAct/editorArticle?articleTitle="+title+"&summary="+summary+"&keyWord="+keyWord +
                                                       "&typeId="+type+"&check=0&uploadChecked="+check+"&articleId="+articleId,
                        }
                    );
                }
                else{
                    jQuery.ajax(
                        {data:formData,
                            contentType: false,
                            processData: false,
                            success: function(data){
                                if(data.flag){
                                    alert(data.msg);
                                    location.reload();
                                }else{
                                    alert(data.msg);
                                }                            },
                            type:'post',
                            url:"${pageContext.request.contextPath}/userAct/editorArticle?mdDb="+mdco+"&articleTitle="+title+"&summary="+summary+"&keyWord="+keyWord +
                                "&typeId="+type+"&check="+0+"&uploadChecked="+check+"&articleId="+articleId,
                        }
                    );
                }
            }
        </script>

  </body>
</html>
