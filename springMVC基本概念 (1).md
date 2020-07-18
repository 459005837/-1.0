@[TOC]
#### 第一部分
**springMVC和Struts2的区别：**
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200716210938570.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NTg0MjQ3Nw==,size_16,color_FFFFFF,t_70)

**前端控制器 DispatcherServlet**
		前端的控制器，相当于一个指挥中心，点击超链接后首先会经过他，就是一个分配和找路径的一个控制器，当前端点击超链接然后就会先判断MVC注解后找到要执行的方法，执行后返回一个success，又因为配置文件中有视图解析器，所以视图解析器就会根据配置文件中所配置的目录后缀等找到那个jsp然后给前端控制器，前端控制器再返回结果给页面。
	
**web.xml中配置DispatcherServlet，springMVC.xml**
```java
    <!--配置前端控制器-->
    <servlet>
        <servlet-name>dispatcherServlet</servlet-name>
        <servlet-class>org.springframework.web.servlet.DispatcherServlet</servlet-class>
        <init-param>
            <param-name>contextConfigLocation</param-name>
            <param-value>classpath:springmvc.xml</param-value>
        </init-param>
        <load-on-startup>1</load-on-startup>
    </servlet>
    <servlet-mapping>
        <servlet-name>dispatcherServlet</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>
```

**springMVC中的各种组件**
		前端控制器、视图解析器、处理器适配器、处理器映射器、Controller。其中视图解析器在springMVC.xml中配置，处理器映射器和处理器适配器在配置springMVC开启注解的时候已经一起配置了。
		客户端发送请求后通过DispatcherServlet，然后通过映射器查到对应类的执行方法，返回，在通过适配器请求执行，适配器相当于USB接口，不管另一端是哪个类哪个方法都能进行适配。然后controller执行后返回字符串，字符串即对应跳转路径，然后通过视图解析器进行解析返回jsp，后由前端控制器再返回客户端。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200716211835600.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NTg0MjQ3Nw==,size_16,color_FFFFFF,t_70)

**执行流程：**
第一步：发起请求到前端控制器(DispatcherServlet) 
第二步：前端控制器请求HandlerMapping查找 Handler，可以根据xml配置、注解进行查找 
第三步：处理器映射器HandlerMapping向前端控制器返回Handler 
第四步：前端控制器调用处理器适配器去执行Handler 
第五步：处理器适配器去执行Handler 
第六步：Handler执行完成给适配器返回ModelAndView 
第七步：处理器适配器向前端控制器返回ModelAndView，ModelAndView是springmvc框架的一个底层对象，包括Model和View 
第八步：前端控制器请求视图解析器去进行视图解析，根据逻辑视图名解析成真正的视图(jsp) 
第九步：视图解析器向前端控制器返回View 
第十步：前端控制器进行视图渲染，视图渲染将模型数据(在ModelAndView对象中)填充到request域 
第十一步：前端控制器向用户响应结果

**组件说明：**
1、前端控制器DispatcherServlet（不需要程序员开发） 
作用：接收请求，响应结果，相当于转发器，中央处理器。 
有了DispatcherServlet减少了其它组件之间的耦合度。

2、处理器映射器HandlerMapping(不需要程序员开发) 
作用：根据请求的url查找Handler

3、处理器适配器HandlerAdapter 
作用：按照特定规则（HandlerAdapter要求的规则）去执行Handler

4、处理器Handler(需要程序员开发) 
注意：编写Handler时按照HandlerAdapter的要求去做，这样适配器才可以去正确执行Handler

5、视图解析器View resolver(不需要程序员开发) 
作用：进行视图解析，根据逻辑视图名解析成真正的视图

6、视图View(需要程序员开发jsp) 
View是一个接口，实现类支持不同的View类型（jsp、freemarker、pdf...）

————————————————
原文链接：https://blog.csdn.net/q982151756/article/details/79718008

**springMVC.xml的配置**

```java
<!--开启注解扫描-->
    <context:component-scan base-package="com.test.www" />

<!--视图解析对象-->
    <bean id="internalResourceViewResolver" class="org.springframework.web.servlet.view.InternalResourceViewResolver">
        <property name="prefix" value="/WEB-INF/pages/"/>
        <property name="suffix" value=".jsp"/>
    </bean>
<!--开启springMVC框架注解支持-->
<!--相当于开启了适配器和映射器-->
    <mvc:annotation-driven conversion-service="conversionService"/>

```

**RequestMapping注解**
		放在方法上，也可以放在类上，当有很多模块的时候就可以放在类上，用来起到一个区分的作用
```java
@Controller
@RequestMapping(value = "/user")
public class HelloMVC {

    @RequestMapping(value = "/test")
    public String testMVC(){
        System.out.println("开始执行了");
        return "success";
    }
}
```

**requestMapping注解的属性**
1.method属性，用来指定特定的接收方式，其中，超链接是get请求方式，主要的请求方式有以下这些种类
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200717203206218.png)![在这里插入图片描述](https://img-blog.csdnimg.cn/20200717203309655.png)
2.params属性：用于指定必须传什么参数给方法，同时也可以指定参数的值必须为多少
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200717203448336.png)
3.headers属性：用于指定必须携带有请求头信息
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200717203553248.png)
4.value属性和path属性一致，都是给方法配置路径使得能一一映射

**参数的传递获取，类的包装以及集合属性**
		springMVC框架的底层会通过反射的机制拿到参数然后再传给所对应的方法，那么只要在对应路径的方法中配置好对应的参数，就可以直接获得，其中参数如果是类的话，框架会自动封装好。
		
form表单的写法：
```java
   <form action="${pageContext.request.contextPath}/user/test"   method="post">
       用户名<input type="text" name="username"><br>
       密码<input type="text" name="password"><br>
       学校名<input type="text" name="sname"><br>
       学校年龄<input type="text" name="sage"><br>
       学校名<input type="text" name="list[0].sname"><br>
       学校年龄<input type="text" name="list[0].sage"><br>
       学校名<input type="text" name="map['one'].sname"><br>
       学校年龄<input type="text" name="map['one'].sage"><br>
       提交 <input type="submit" value="提交"><br>
   </form>
```
user实体类还有school实体类（省略get和set）

```java
public class User {
    private String username;
    private String password;

    private School school;
    private List<School> list;
    private Map<String,School> map;

    @Override
    public String toString() {
        return "User{" +
                "username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", school=" + school +
                ", list=" + list +
                ", map=" + map +
                '}';
    }
}
```
```java
public class School {

    private String sname;
    private String sage;

    @Override
    public String toString() {
        return "School{" +
                "sname='" + sname + '\'' +
                ", sage='" + sage + '\'' +
                '}';
    }
}
```
**解决中文乱码问题，配置过滤器**
在web.xml中配置中文乱码过滤器
```java
    <filter>
        <filter-name>characterEncodingFilter</filter-name>
        <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
        <init-param>
            <param-name>encoding</param-name>
            <param-value>UTF-8</param-value>
        </init-param>
    </filter>
    <filter-mapping>
        <filter-name>characterEncodingFilter</filter-name>
        <url-pattern>/*</url-pattern>
    </filter-mapping>
```

**自定义类型转换器**
		在参数的传递中，页面的参数都是由string类型再进行转换为int或其他类型，但是当出现参数的转换模式和类型所要求的不一样时就会出错，这个时候就可以配置自定义类型转换器
		![在这里插入图片描述](https://img-blog.csdnimg.cn/2020071721090747.png)前一种可以，后一种不可以完成转换封装。
设置自定义类型转换的类;
```java
public class StringToDateConverter implements Converter<String, Date> {
    /**
     * 传进来的字符串
     * @param s
     * @return
     */
    public Date convert(String s) {
        //判断
        if(s == null ){
            throw new RuntimeException("请输入数据");
        }

        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");

        try {
            return df.parse(s);
        } catch (ParseException e) {
            throw new RuntimeException("数据类型转换出错");
        }
    }
}
```
在springMVC.xml中配置：（需要开启对应的conversionService注解）
```java
    <!--配置自定义类型转换器-->
    <bean id="conversionService" class="org.springframework.context.support.ConversionServiceFactoryBean">
        <property name="converters">
        <set>
            <bean class="com.test.www.util.StringToDateConverter"></bean>
        </set>
        </property>
    </bean>
    <!--开启springMVC框架注解的支持-->
    <mvc:annotation-driven conversion-service="conversionService"></mvc:annotation-driven>
```

**如何获得原生的servletAPI**
		直接在方法的参数上获即可
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200717213013868.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NTg0MjQ3Nw==,size_16,color_FFFFFF,t_70)
#### 第二部分注解
**springMVC的注解**
1.@RequestParam注解，即前端所传过来的参数中必须有uuname这个名字的参数，才能与此方法映射，required属性true表示必须有，false表示可以没有，不会报错。
```java
    @RequestMapping(value = "/test" )
    public String testMVC(@RequestParam(name = "uuname",required = true) String username){
        System.out.println("开始执行了");
        System.out.println(username);
        return "success";
    }
```

2.@RequestBody注解，表示拿到请求体，超链接是get请求，没有请求体
```java
    @RequestMapping(value = "/test" )
    public String testMVC(@RequestBody String body){
        System.out.println("开始执行了");
        System.out.println(body);
        return "success";
    }
```

**restful风格**
![在这里插入图片描述](https://img-blog.csdnimg.cn/2020071721543138.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NTg0MjQ3Nw==,size_16,color_FFFFFF,t_70)
3.@PathVariable注解，用来适应restfull风格，直接在前端链接后面加 /数字 不需要参数名称
```java
    @RequestMapping(value = "/test/{sid}" )
    public String testMVC(@PathVariable(name = "sid") String id){
        System.out.println("开始执行了");
        System.out.println(id);
        return "success";
    }
```

4.@RequestHeader注解，获得请求头的值
```java
    @RequestMapping(value = "/test" )
    public String testMVC(@RequestHeader(name = "Accept") String header){
        System.out.println("开始执行了");
        System.out.println(header);
        return "success";
    }
```

5.@CookieValue注解获得cookie
```java
    @RequestMapping(value = "/test" )
        public String testMVC(@CookieValue(name = "JSESSIONID") String cookieValue){
        System.out.println("开始执行了");
        System.out.println(cookieValue);
        return "success";
    }
```

6.@ModelAttribute注解，表示在任何控制器之前执行，当表单内的数据欠缺时，可以先拿到表单数据然后根据表单所提供的数据从数据库中查询全部的数据，然后再返回一个user，这个时候配置路径的方法就可以拿到此时的user。
以下情况中，若前端表格中有username，password。经过以下过程后，user中的date属性就会被赋值，然后username还有password属性还是表单提交的数据，不会改变。
```java
    @RequestMapping(value = "/test" )
        public String testMVC(User user){
        System.out.println("开始执行了");
        System.out.println(user);
        return "success";
    }

    @ModelAttribute
    public User setUser(String username){
        System.out.println("1111111111");
        User user = new User();
        user.setUsername(username);
        user.setPassword("123");
        user.setDate(new Date());
        return user;
    }
```
@ModelAttribute注解的另一个用法，当方法的返回值是void时，可以从map中拿到user

```java
    @RequestMapping(value = "/test" )
        public String testMVC(@ModelAttribute("abc") User user){
        System.out.println("开始执行了");
        System.out.println(user);
        return "success";
    }

    @ModelAttribute
    public void setUser(String username, Map<String,User> map) {
        System.out.println("1111111111");
        User user = new User();
        user.setUsername(username);
        user.setPassword("123");
        user.setDate(new Date());

        map.put("abc",user);
    }
```

7.@SessionAttritubes注解，以及Model类，Moerl类可以做到存放信息进入request共享域，当在类上上添加sessionAttributes注解的时候表示也可以把信息存放到session共享域
```java
@Controller
@RequestMapping(value = "/user")
@SessionAttributes(value = {"msg"})//放在session
public class HelloMVC {
    @RequestMapping(value = "/test" )
    public String testMVC(Model model){
        System.out.println("开始执行了");
        model.addAttribute("msg","123");//放在request
        return "success";
    }
}
```
关于删除和拿到共享域信息
```java
    //获得共享域的内容
    @RequestMapping(value = "/test1" )
    public String testMVC(ModelMap modelmap){
        System.out.println("开始执行了");
        System.out.println(modelmap.getAttribute("msg"));
        return "success";
    }


    //删除共享域的内容
    @RequestMapping(value = "/test2" )
    public String testMVC(SessionStatus sessionStatus){
        System.out.println("开始执行了");
        sessionStatus.setComplete();
        return "success";
    }
```
#### 第三部分响应
转发重定向和响应，不会调用到视图解析器
```java
    @RequestMapping(value = "/test" )
    public void testMVC(HttpServletRequest request, HttpServletResponse response) throws Exception, IOException {
        System.out.println("开始执行了");
//        request.getRequestDispatcher("/WEB-INF/jsp/success.jsp").forward(request,response);
        //重定向会跳转路径
//        response.sendRedirect(request.getContextPath()+"/index.jsp");

        //设置中文乱码
 response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        response.getWriter().print("你好");
    }

```


当所配置的方法的返回类型时void的时候，则前端控制器会去找对应的路径下的jsp页面
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200717231154283.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NTg0MjQ3Nw==,size_16,color_FFFFFF,t_70)

**ModelAndView对象**
返回字符串底层实现也是用这个类，既可以存放到request共享域，也可以进行页面的跳转
```java
    @RequestMapping(value = "/test" )
    public ModelAndView testMVC(HttpServletRequest request, HttpServletResponse response) throws Exception, IOException {
        ModelAndView mv = new ModelAndView();
        System.out.println("zhixingle...");
        User user = new User();
        user.setUsername("张三");
        user.setPassword("123");
        //会把user对象存到request共享域中
        mv.addObject("user",user);
        //相当于 return"success"
        mv.setViewName("success");
        return mv;
    }
```

**使用关键字进行转发和重定向**
```java
    @RequestMapping(value = "/test" )
    public String testMVC() {
        System.out.println("执行了");

//        return "forward:/WEB-INF/jsp/success.jsp";

        return "redirect:/index.jsp";
    }
```

**@RequestBody和@ResponseBody在异步请求中的作用**
利用RequestBody注解拿到请求体里面的json数据；Ajax异步请求过来发送json数据利用RequestBody获得封装成对象，然后返回一个对象，利用responseBody注解将对象返回，实现简易的异步过程。

```java
    @RequestMapping(value = "/test" )
    public @ResponseBody User testMVC(@RequestBody User user) {
        System.out.println(user);
        user.setUsername("赵小强");
        return user;
    }
```

```java
    $(function () {
        $("#btu").click(function () {
            $.ajax({
                // 编写json格式，设置属性和值
                url:"user/test",
                contentType:"application/json;charset=UTF-8",
                data:'{"username":"hehe","password":"123","age":30}',
                dataType:"json",
                type:"post",
                success:function(data){
                    // data服务器端响应的json的数据，进行解析
                    alert(data);
                    alert(data.username);
                    alert(data.password);
                    alert(data.age);
                    }
            })
        })
    })
```
这里需要接触静态资源js的拦截
```java
    <mvc:resources mapping="/js/**" location="/js/"/>

```

#### 第四部分文件上传
文件上传表单：(form表单提交方式默认get方式的话是会上传失败的)
```java
   <h1>测试5</h1>
   <form action="${pageContext.request.contextPath}/user/test" method="post" enctype="multipart/form-data">
     上传文件 <input type="file" name="upload">
       <input type="submit" value="上传">
   </form>
```

springMVC下的接收文件：

```java
    @RequestMapping(value = "/test" )
    public String testMVC(HttpServletRequest request, MultipartFile upload) throws IOException {
        System.out.println("文件上传");
        //设置上传地址
        String path = request.getSession().getServletContext().getRealPath("/uploads/");
        System.out.println(path);
        //判断
        File file = new File(path);
        if(!file.exists()){
            file.mkdirs();//不存在则创建
        }

        //获取名称
        String filename = upload.getOriginalFilename();
        String uuid = UUID.randomUUID().toString().replace("-","");
        filename = uuid+"_"+filename;
        //完成文件上传
        upload.transferTo(new File(path,filename));
        return "success";
    }
```

springMVC.xml中配置文件上传解析器

```java
<!--配置文件解析器对象-->
    <bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
        <property name="maxUploadSize" value="10485760"/>
    </bean>
```
