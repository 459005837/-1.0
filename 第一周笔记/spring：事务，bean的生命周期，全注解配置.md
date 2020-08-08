#### 事务
**事务的概念**
数据库操作上最基本的单元，即为一组动作是前后牵连的，要么同时一起完成，要么一起失败，如：银行转账，一方转出，一方转入；

spring中的AOP事务图解：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200718152127390.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NTg0MjQ3Nw==,size_16,color_FFFFFF,t_70)

事务的四个特性：
1.原子性：不可分割，要么都成功要么都失败；2.一致性：操作前和操作后总量不变；3.隔离性：当前事务操作时不会产生其他影响；4.持久性：事务提交后发生的变化；

**xml配置事务管理**
```java
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xmlns:context="http://www.springframework.org/schema/context"
       xmlns:aop="http://www.springframework.org/schema/aop"
       xmlns:tx="http://www.springframework.org/schema/tx"

       xsi:schemaLocation="http://www.springframework.org/schema/beans
       http://www.springframework.org/schema/beans/spring-beans.xsd
http://www.springframework.org/schema/context
       http://www.springframework.org/schema/context/spring-context.xsd
       http://www.springframework.org/schema/aop
       http://www.springframework.org/schema/aop/spring-aop.xsd
       http://www.springframework.org/schema/tx
       http://www.springframework.org/schema/tx/spring-tx.xsd">

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

    <!--组件扫描器-->
    <context:component-scan base-package="com.test.www"/>

    <!--创建事务管理器-->
    <bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
        <!--注入数据源-->
        <property name="dataSource" ref="dataSource"/>
    </bean>

    <!--开启事务注解-->
    <tx:annotation-driven transaction-manager="transactionManager"/>

</beans>
```

**添加注解**
```java
@org.springframework.stereotype.Service
@Transactional(propagation = Propagation.REQUIRED,isolation = Isolation.REPEATABLE_READ)//事务的属性
public class ServiceImpl implements Service {

    @Autowired
    private Dao dao;

    @Override
    public void addUser() {
        dao.addUser();
//        int i = 10 / 0 ;
        dao.addUserMore();
    }
```

**属性**
1.propagation：（事务的传播行为）
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200715233809433.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NTg0MjQ3Nw==,size_16,color_FFFFFF,t_70)
2.ioslation：（事务的隔离级别）
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200715234112282.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NTg0MjQ3Nw==,size_16,color_FFFFFF,t_70)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200715234135404.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NTg0MjQ3Nw==,size_16,color_FFFFFF,t_70)
#### bean的生命周期
**bean的生命周期**
为bean添加后置处理器，生命周期一共有七步：1.执行无参数构造创建bean；2.调用set方法注值；（初始化前执行的方法）3.执行初始化方法（初始化后执行的方法）4.获取创建bean实例对象；5.执行销毁的方法

xml的配置方式：
```java
    <bean id="user" class="com.test.www.User" init-method="init" destroy-method="destroy">
        <property name="username" value="小明" />
    </bean>

    <!--后置处理器-->
    <bean id="myBeanPost" class="com.test.www.MyBeanPost"></bean>
```

创建和销毁的注解方式：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200718143416658.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NTg0MjQ3Nw==,size_16,color_FFFFFF,t_70)

后置处理器：
```java
//后置处理器。实际bean的生命周期有七步。
public class MyBeanPost implements BeanPostProcessor {
    @Override
    public Object postProcessBeforeInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("在初始化前执行的方法");
        return bean;
    }

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) throws BeansException {
        System.out.println("在初始化后执行的方法");
        return bean;
    }

}
```
#### 全注解配置
**全注解配置方式（代替xml）**


IOC：
```java
@Configuration //作为配置类，替代 xml 配置文件
@ComponentScan(basePackages = {"com.atguigu"})
public class SpringConfig {
}
```


AOP：
```java
@Configuration
@ComponentScan(basePackages = {"com.atguigu"})
@EnableAspectJAutoProxy(proxyTargetClass = true)
public class ConfigAop {
}
```


事务：
```java
@Configuration//配置类
@ComponentScan(basePackages = "test")//组件扫描器
@EnableTransactionManagement//开启事务 注解
public class SpringConfig {
    //创建数据库连接池
    @Bean
    public DruidDataSource getDruidDataSource(){
        DruidDataSource dataSource = new DruidDataSource();
        dataSource.setDriverClassName("com.mysql.jdbc.Driver");
        dataSource.setUrl("jdbc:mysql:///user");
        dataSource.setUsername("root");
        dataSource.setPassword("1234");

        return dataSource;
    }

    //Jdbc创建
    @Bean                               //因为dataSource已经创建在了容器中。所以直接用就可以了。
    public JdbcTemplate getJdbcTemplate(DruidDataSource dataSource){
        JdbcTemplate jdbcTemplate = new JdbcTemplate();
        jdbcTemplate.setDataSource(dataSource);
        return jdbcTemplate;
    }

    //创建事务管理器
    @Bean
    public DataSourceTransactionManager dataSourceTransactionManager(DruidDataSource dataSource){
        DataSourceTransactionManager dataSourceTransactionManager = new DataSourceTransactionManager();
        dataSourceTransactionManager.setDataSource(dataSource);
        return dataSourceTransactionManager;
    }
}
```

