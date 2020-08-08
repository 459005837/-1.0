@[toc]
**java中创建对象的方式：**
构造方法new ...()；反射机制；序列化；克隆；ioc容器，创建对象；动态代理；

**MVC三层架构：**
表现层：展示数据；业务层：处理业务；持久层：数据库交互

**各个框架所使用的区域：**
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200713073113942.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NTg0MjQ3Nw==,size_16,color_FFFFFF,t_70)
**1.spring的两大内核：**
	IOC(反转控制)和AOP(面向切面编程)
	
**2.spring的优势:**
	1.方便解耦，简化开发		2.AOP编程的支持	3.声明式事务的支持	4.方便程序的测试	5.方便集合各种框架	6.降低JavaEE API的难度（JDBC，javaMail，远程调用等）7.源码

##### 1、ioc控制反转
**ioc的体现例子**：servlet，继承HttpServlet，也是在web.xml中去配置，或者是使用注解的方式；tomcat作为一个容器创建servlet对象，Listener对象，Filter对象；
**原理**：把对象的创建，属性的赋值，交托给spring容器（是一个map容器），把对象的控制权给转移；
**方式**：重要技术实现DI（依赖注入），底层实现的反射机制，其中有基于xml的DI注入还有基于注解的DI注入；

##### 1.1基于xml的DI
**基本操作**：1.导包；2.设置xml配置文件；3.为对象配置bean；4.在程序中获取spring容器并拿到配置的对象

要创建的接口的实现类：
```java
public class serviceImpl implements service {
    /**
     * spring默认调用无参构造函数
     * 如果没有无参构造函数会报错
     */
    @Override
    public void doService() {
        System.out.println("service来了。。。");
    }
}
```
在xml中的配置方式：

```java
    <bean id="service" class="com.test2.www.Impl.serviceImpl"></bean>

```
如何拿到spring容器：
（容器创建对象的原理：当程序执行到加载配置文件的时候，当遇到bean的时候就已经创建了对象，且在后面的引用类型中并不需要担心配置顺序的问题，先扫描一遍再寻找一遍对象）
```java
        //路径
        String path = "beans.xml";
        //获取spring容器
        ApplicationContext ac = new ClassPathXmlApplicationContext(path);
        //类型转换为对应的
        service service = (com.test2.www.service) ac.getBean("service");
        //执行业务
        service.doService();
```

如何在spring容器中获取对象数量
```java
        //获取数量
        System.out.println("数量为："+ac.getBeanDefinitionCount());
```

如何在spring容器中获取对象的名称
```java
        //获取对象名字
        String names[] = ac.getBeanDefinitionNames();
        for (String name : names){
            System.out.println(name);
        }
```

**spring也可以创建非自定义的对象**
```java
    <bean id="date" class="java.util.Date"></bean>
```

**为属性赋值**
1.set注入
简单类型（java基本类型还有String）还有引用类型（类对象）
```java
        <bean id="student" class="com.test3.www.student">
            <property name="age" value="12" />
            <property name="name" value="张三" />
            <property name="school" ref="**school**"/>
        </bean>

        <bean id="**school**" class="com.test3.www.school">
            <property name="age" value="12" />
            <property name="name" value="张三" />
        </bean>
```

2.构造注入
可以使用name属性，或者是index属性指定，执行类的构造方法

```java
        <bean id="student" class="com.test3.www.student">
                <constructor-arg name="name" value="李四" />
                <constructor-arg name="age" value="11"/>
                <constructor-arg name="school" ref="school"/>
        </bean>

        <!--进行声明-->
        <bean id="school" class="com.test3.www.school">
            <constructor-arg name="name" value="李四" />
            <constructor-arg name="age" value="11"/>
        </bean>
```
ps：如创建文件对象也可以构造注入，需要先了解File中的构造器的两个参数

**理解**
项目中，对象间的关联的有controller到service，service到dao，这样的话就可以在service中将dao置为null，这个时候dao对象在service类中就相当于一个属性，那么在配置文件中就可以先创建service对象然后再给dao对象属性进行赋值，方法跟上面一样。

**引用类型的自动注入**
byName：在bean属性中加上：autowire="byName"，引用对象的属性名需要和指定对象的bean id一致，这样的话在扫描配置文件的时候就会根据名字di去注入

byType：是根据具有同源关系的类型注入，同源关系：
1.引用类型和配置文件中的类有相同；
2.引用类型是配置文件中的类的父类；
3.引用类型是配置文件中的类的接口；
ps：byType的声明中在配置文件中只能有一个是符合的，不然会报错；

**设置多个配置文件**
按功能模块或按类的功能来划分配置文件

```java
    <import resource="bean1.xml" />
    <import resource="bean2.xml"/>
```
最后在总配置文件中去导入其他的配置文件

##### 1.2基于注解的DI
**基本操作**
就是先在配置文件中台南佳组件扫描器，在类中添加注解，使用的时候还是一样先扫描配置文件，然后配置文件再去扫描类的注解，获取类对象
组件扫描器：
```java
    <context:component-scan base-package="com.www" />
```
扫描多个包的方式：1.添加多个扫描器；2.再路劲后用分号隔开；3.扫描一个大包

**定义 Bean 的注解@Component(掌握)**
@Component: 创建类的对象，等同于<bean />，默认是单例对象
属性： value 表示对象的名称（的id）
位置： 在类定义的上面，表示创建此类的对象。

例如：@Component(value = "myStudent")等价于<bean id="myStudent" class="com.bjpowernode.ba01.Student"/>

另外，Spring 还提供了 3 个创建对象的注解：
➢ @Repository 用于对 DAO 实现类进行注解
➢ @Service 用于对 Service 实现类进行注解
➢ @Controller 用于对 Controller 实现类进行注解 这三个注解与@Component 都可以创建对象，但这三个注解还有其他的含义，@Service 创建业务层对象，业务层对象可以加入事务功能，@Controller 注解创建的对象可以作为处理器接收用户的请求。
@Repository，@Service，@Controller 是对@Component 注解的细化，标注不同层的对象。即持久层对象，业务层对象，控制层对象。
@Component 不指定 value 属性，bean 的 id 是类名的首字母小写。

**简单类型属性注入@Value**

```java
@Component("myStudent")
public class Student {
    /**
     * @Value: 简单类型的属性赋值
     *   属性： value 是String类型的， 表示简单类型的属性值
     *   位置：
     *       1.在属性定义的上面， 无需set方法，常用的方式
     *       2.在set方法上面
     */
    @Value("张三01")
    private String name;


    private int age;

    public void setName(String name) {
        this.name = name;
    }

    @Value("28")
    public void setAge(int age) {
        System.out.println("setAge:"+age);
        this.age = age;
    }

    @Override
    public String toString() {
        return "Student{" +
                "name='" + name + '\'' +
                ", age=" + age +
                '}';
    }
}
```

**byType 自动注入@Autowired**
需要在引用属性上使用注解@Autowired，该注解默认使用按类型自动装配Bean的方式。
使用该注解完成属性注入时，类中无需 setter。当然，若属性有 setter，则也可将其加 到 setter 上。 举例：
School类：
```java
package com.bjpowernode.ba03;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component("mySchool")
public class School {
   @Value("人民大学")
   private  String name;
   @Value("北京的海淀")
   private  String address;

```
Student类：

```java
package com.bjpowernode.ba03;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component("myStudent")
public class Student {

    @Value("张三")
    private String name;

	@Value("23")
    private int age;


    /**
     * 引用类型
     * @Autowired:引用类型的自动注入， 支持byName, byType.默认是byType
     *       位置:
     *         1.属性定义的上面，无需set方法，常用方式
     *         2.在set方法的上面
     */
    //byType
    @Autowired
    private School school;
    
    @Override
    public String toString() {
        return "Student{" +
                "name='" + name + '\'' +
                ", age=" + age +
                ", school=" + school +
                '}';
    }
}
```

**byName 自动注入@Autowired 与@Qualifier**
需要在引用属性上联合使用注解@Autowired 与@Qualifier。@Qualifier 的 value 属性用 于指定要匹配的 Bean 的 id 值。类中无需 set 方法，也可加到 set 方法上。 举例：
如果Student要自动注入2.4.3中的School类，只需在school属性前添加注解：
```java
 	//byName
    @Autowired
    @Qualifier("mySchool")//与School类的@component注解value值相同
    private School school;

```
@Autowired 还有一个属性 required，默认值为 true，表示当匹配失败后，会终止程序运 行。若将其值设置为 false，则匹配失败，将被忽略，未匹配的属性值为 null。

 **JDK 注解@Resource 自动注入**
Spring提供了对jdk中@Resource注解的支持。@Resource注解既可以按名称匹配Bean， 也可以按类型匹配 Bean。默认是按名称注入。使用该注解，要求 JDK 必须是 6 及以上版本。 @Resource 可在属性上，也可在 set 方法上。
个人认为，本质就是用@Resource一个注解代替@Autowired和@Qualifier两个注解。

一、byType 注入引用类型属性
@Resource 注解若不带任何参数，采用默认按类型的方式注入，按名称不能注入 bean， 则会按照类型进行 Bean 的匹配注入。
如果Student要自动注入2.4.3中的School类，只需在school属性前添加注解：
```java
	@Resource
    private School school;

```
二、byName 注入引用类型属性
@Resource 注解指定其 name 属性，则 name 的值即为按照名称进行匹配的 Bean 的 id。
如果Student要自动注入2.4.3中的School类，只需在school属性前添加注解：

```java
	@Resource("mySchool")
    private School school;
```

