@[toc]
#### aop基础理解
**AOP概念**：
		面向切面编程，AOP对业务逻辑的各个部分进行了隔离，降低代码的耦合度。即可通过不改变原代码的情况下，在原业务功能上添加新的功能。例如：登录权限，转账权限，在登录的时候需要进行权限判断，那么就可以通过动态代理的方式来对这个登录方法进行增强，获得代理类，然后在代理类上进行操作，而spring中的AOP底层原理正是动态代理，后面就是用注解的方式简化了生成代理对象的方式。
		有两种代理模式，JDK的动态代理：有接口的动态代理，创建接口的实现类的代理对象；CGLIB动态代理：没有接口的动态代理，则创建当前类的子类的代理对象。


**代理对象的创建方法（JDK）**
		通过Proxy动态代理类中的newProxyInstance()方法来创建代理类；
		其中，newProxyInstance()方法有三个参数：类加载器；增强的方法所在的类的接口；InvocationHandler的实现类（用来创建代理对象，写增强的方法）
```java
public class JDKProxy {
    public static void main(String[] args) {
        Class[] interfaces = {UserDao.class};

        //要被代理的对象
        UserDao dao = new UserDaoImpl();
        //先创建代理对象
        UserDao userDaoProxy = (UserDao) Proxy.newProxyInstance(JDKProxy.class.getClassLoader(), interfaces, new UserDaoProxy(dao));

        System.out.println(userDaoProxy.add(1,2));

    }
}
class UserDaoProxy implements InvocationHandler{

    Object obj;

    /**
     * ，有参构造函数，目的是获得所要代理的类
     */
    public UserDaoProxy(Object obj) {
        this.obj = obj;
    }

    /**
     * 这里可以获得执行的方法名，所以可以在这里做判断是要
     * 执行哪个方法
     */
    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        //执行前
        System.out.println("哈哈增强了。。。");

        //代理对象还有参数
        Object res = method.invoke(obj,args);

        //执行后
        System.out.println("呵呵可以了。。。");

        return res;
    }
}
```

**AOP术语**
1.连接点：类里面哪里方法可以被增强，则为连接点；
2.切入点：实际增强的方法，称切入点；
3.通知：即增强的部分，如权限的判断；通知有多种类型：前置通知，后置通知，环绕通知(前后执行)，异常通知(异常执行)，最终通知(一定执行);
4.切面：一个过程，把通知应用到切入点。

**AspectJ**：独立的AOP框架，不属于spring的一部分；

**AOP的配置还有注解**

配置文件的配置：
```java
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
http://www.springframework.org/schema/context
       http://www.springframework.org/schema/context/spring-context.xsd
       http://www.springframework.org/schema/aop
       http://www.springframework.org/schema/aop/spring-aop.xsd">
	<!--组件扫描器-->
    <context:component-scan base-package="com.aop.www"/>

	<!--开启aspectj生成代理对象-->
    <aop:aspectj-autoproxy/>
</beans>
```
代理类的注解：
```java
@Component
@Aspect
@Order(2)
public class UserProxy {

    /**
     * 抽取出来的相同切入点
     */
    @Pointcut(value = "execution(* com.aop.www.User.add(..))")
    public void pointDemo(){

    }

    @Before(value = "pointDemo()")
    public void before(){
        System.out.println("before执行了。。。");
    }

    //不管异常还是不异常最后一定会执行
    @After(value = "pointDemo()")
    public void after(){
        System.out.println("after执行了。。。");
    }

    //方法后执行
    @AfterReturning(value = "pointDemo()")
    public void afterReturning(){
        System.out.println("afterReturning执行了。。。");
    }

    //当出现异常后执行
    @AfterThrowing(value = "pointDemo()")
    public void afterThrowing(){
        System.out.println("afterThrowing执行了。。。");
    }

    //环绕执行
    @Around(value = "pointDemo()")
    public void around(ProceedingJoinPoint proceedingJoinPoint) throws Throwable {
        System.out.println("环绕前执行了。。。");

        proceedingJoinPoint.proceed();

        System.out.println("环绕后执行了。。。");

    }

}
```
当有多个代理类时，可以在类名上用@Order(number)注解，其中number的数字越小则优先级更前。

执行：

```java
    public static void main(String[] args) {
        ApplicationContext ac = new ClassPathXmlApplicationContext("bean.xml");
        User user = ac.getBean("user",User.class);
        user.add();
    }
```
#### jdbcTemplate
**在xml中配置数据库还有jdbcTemplate**

```java
    <!-- 数据库连接池 -->
    <bean id="dataSource" class="com.alibaba.druid.pool.DruidDataSource"
          destroy-method="close">
        <property name="url" value="jdbc:mysql:///user" />
        <property name="username" value="root" />
        <property name="password" value="1234" />
        <property name="driverClassName" value="com.mysql.jdbc.Driver" />
    </bean>

    <!--注入jdbcTemplate-->
    <bean id="jdbcTemplate" class="org.springframework.jdbc.core.JdbcTemplate">
        <!--注入dataSource  set注入-->
        <property name="dataSource" ref="dataSource"/>
    </bean>

```
**jdbcTemplate具体的api**

```java
    /**
     * 更新
     */
    @Override
    public void updateUser(User user) {
        int update = jdbcTemplate.update("update user set username = ? ,password = ? where user_id = ?",
                new Object[]{user.getUsername(),user.getPassword(),user.getUserId()});
        System.out.println(update);
    }

    /**
     * 查询一个对象
     */
    @Override
    public User findUser(int id) {
        User user = jdbcTemplate.queryForObject("select * from user where user_id = ? ",
                new BeanPropertyRowMapper<User>(User.class), id);
        System.out.println(user);
        return user;
    }

    /**
     * 查询一个值
     */
    @Override
    public int userCount() {
        Integer integer = jdbcTemplate.queryForObject("select count(*) from user", Integer.class);
        System.out.println(integer);
        return integer;
    }

    /**
     * 批量查询
     */
    @Override
    public List<User> userList() {
        List<User> query = jdbcTemplate.query("select * from user", new BeanPropertyRowMapper<User>(User.class));
        System.out.println(query);
        return query;
    }

    /**
     * 批量添加
     */
    @Override
    public void addUserMore(List<Object[]> list) {
        int[] ints = jdbcTemplate.batchUpdate("insert into user (username,password) values(?,?)", list);
        System.out.println(ints);
    }
```

