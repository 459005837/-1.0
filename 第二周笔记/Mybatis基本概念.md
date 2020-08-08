@[toc]
#### 第一部分，Mybatis简介		
   mybatis 持久层框架，是用来对dao层，即数据库查询这一层的封装，不需要编写dao接口实体类，不需要手写数据库连接，主要是通过配置xml的方式。
   
   首先需要一个Mybatis-config.xml配置文件，用来配置数据库的连接，配置dao层的mapper.xml的路径，为实体类开启别名，这样在mapper.xml中就可以直接用类名去写，不需要全限定类名，还有开启延迟加载等全局功能。
	
   其次每一个dao接口都需要对应一个xxxMapper.xml的实现类，这里首先需要指定对应的是哪个dao接口的配置文件，其次里面用来写增删查改等sql语句，可以指定传入的参数，指定返回的参数，还可以对类的属性名进行取别名后能够与数据库的列名对应从而拿到值。


#### 第二部分，工具类即Mybatis中的xml的配置

**工具类，加载Mybatis-config.xml，创建dao代理对象**
```java
    private InputStream in;
    private SqlSession sqlSession;
    private UserDao userDao;

    @Before
    public void init() throws Exception {
        //1.读取配置文件
        in = Resources.getResourceAsStream("mybatis.xml");
        //2.创建SqlSessionFactory工厂
        SqlSessionFactory factory= new SqlSessionFactoryBuilder().build(in);
        //3.使用SqlSession生产工厂对象
        sqlSession = factory.openSession();
        //4.使用sqlSession创建dao接口的代理对象
        userDao = sqlSession.getMapper(UserDao.class);
    }

    @After
    public void destroy() throws Exception {
        sqlSession.commit(true);
        //6.释放资源
        sqlSession.close();
        in.close();
    }
```


**Mybatis-config.xml的配置：**

```java
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">
<configuration>
    
    
    <!--    通过属性引用外部的数据库配置文件-->
    <properties resource="druid.properties"></properties>
    
    <!--    开启Mybatis支持延迟加载-->
    <settings>
        <setting name="mapUnderscoreToCamelCase" value="true"/>
        <setting name="lazyLoadingEnabled" value="true"></setting>
        <setting name="aggressiveLazyLoading" value="false"></setting>
    </settings>

    
    <!--    使用typeAliases标签配置别名，只能配置domain中类的别名-->
    <typeAliases>
        <!-- 单个别名定义 -->
        <!--typeAlias用于配置别名。type属性指定的是实体类全限定类名。alias属性指定别名，当指定了别名就不再区分大小写-->
<!--        <typeAlias type="com.mybatis.domain.User" alias="user"/>-->
        <!-- 批量别名定义，扫描整个包下的类，别名为类名（首字母大写或小写都可以） -->
        <!-- 用于指定要配置别名的包，指定后，该包下的实体类都会注册别名，并且类名就是别名，不再区分大小写 -->
        <package name="com.mybatis.domain"/>
    </typeAliases>

<!--    配置环境-->
    <environments default="mysql">
<!--        配置mysql的环境-->
        <environment id="mysql">
<!--            配置事务的类型-->
            <transactionManager type="JDBC"></transactionManager>
<!--            配置连接池-->
            <dataSource type="POOLED">
                <property name="url" value="${url}" />
                <property name="username" value="${username}" />
                <property name="password" value="${password}" />
                <property name="driver" value="${driver}" />
            </dataSource>
        </environment>
    </environments>

<!--指定配置文件-->
    <mappers>
<!--        用package这个标签指定哪个包下的mapper的dao接口，这样也可以自动找到对应的xml配置文件-->
        <package name="com.mybatis.dao"></package>
<!--        <mapper resource="com/mybatis/dao/*.xml" />-->
    </mappers>

```

properties标签 用来配置外部的配置文件，这里引用外部的数据库连接的配置文件，然后在数据库连接的配置中用 ${value}的形式获取值；

typeAliases标签 用来为实体类的bean取别名，type表示全限定类名，alias表示别名；
package标签 批量定义别名，用来指定对应的包下的类，而且别名就是类名；
（以上两个标签取的别名都不区分大小写，这样子在XxxMapper.xml中配置映射对象就可以直接用别名。）



**XxxMapper.xml的配置：**

**1.**  **先是如何给实体类的属性起别名，通过resultMap标签来定义，其中如果实体类中有引用其他类的属性，又需要通过collection标**    
 **签**（eg：List<User> user 这样的属性）**，或者是association标签**（eg：User user 这样的属性）

```java
<!--    配置查询要用到的列名和实体类的属性名  给属性名起别名-->
    <resultMap id="userMap" type="UseR" >
<!--        主建-->
        <id property="id" column="id"></id>
<!--        非主建-->
        <result property="userName" column="username"></result>
        <result property="userPassword" column="password"></result>
        <result property="userAge" column="age"></result>
<!--       如果是集合就使用collection这个标签，需要指定类型 ofType-->
<!--       查询用户信息，如果有账号信息要查出来，用左外连接，如果一个用户有多个账号
           那么mybatis会自动识别后封装在list中-->
        <collection property="accounts" ofType="account">
            <id property="id" column="aid"></id>
            <result property="number" column="number"></result>
            <result property="uid" column="uid"></result>
        </collection>
    </resultMap>
```

```java
<!--    先配置account各个属性和列名的关系-->
    <resultMap id="accountMap" type="Account">
        <id property="id" column="aid"></id>
        <result property="number" column="number"></result>
        <result property="uid" column="uid"></result>
<!--        user属性是根据uid查来的,需要加上javaType标签，不然会报错-->
        <association property="user" column="uid" javaType="user" >
            <id property="id" column="id"></id>
            <result column="username" property="userName"></result>
            <result column="password" property="userPassword"></result>
            <result column="age" property="userAge"></result>
        </association>
    </resultMap>
```

result标签和id标签中 column属性表示要起的别名，一般就是和数据库列名对应，property属性就是实体类的属性名；
在collection标签和association标签中 column标签表示用来查出该对应信息的条件，然后collection中需要指定ofType用来表示所映射的对象，association中就需要设置javaType；

需要注意的是给resultMap标签起一个id值，同时要指定type，即返回值的类；其次由于在Mybatis-config.xml中已经配置了实体类的别名是类名，且大小写不影响，所以可以直接用类名去写。

**2.** **基本的对数据的CRUD操作，在sql语句上的编写的方式跟以前是完全一样的，什么多表查询，聚合，子查询等都是不变的，会变的就是设定参数的方式，要用 #{param} 的方式添加。**

基本的增删查改
```java
    <insert id="addUser" parameterType="User">
        insert into User (username,password,age)values(#{username},#{password},#{age});
    </insert>

    <delete id="deleteUser" parameterType="int">
            delete from user where id = #{id}
    </delete>

    <update id="updateUser" parameterType="User">
        update user set username = #{username} ,password=#{password},age = #{age}
        where id = #{id}
    </update>

    <select id="selectUser" parameterType="int" resultType="com.ssmTest.pojo.User" >
        select * from user where id = #{id}
    </select>

--  这里是需要修改类的属性名的操作，就是将resultType换成所配置的resultMap，同时加上对应的id
    <select id="selectUsers" resultMap = "userMap" >
        select * from user
    </select>
```

**3.** **特殊的操作：如动态sql，模糊查询，抽取相同部分的sql，使用selectKey标签实现先后同时执行sql语句获取内容**

动态sql语句，即不知道是要根据哪些条件查询，需要使用if标签，where标签，或foreach标签
```java
    <select id="findUser" resultMap="userMap" parameterType="User">
-- 这是没有使用where标签的时候就需要在后面加一个1 =1
        select * from user where 1=1
        <if test="userName != null">
            and username = #{userName}
        </if>
--         在java中会自动给没有赋值的int类型的属性赋予0，所以这里不能写null
        <if test="userAge != 0">
            and age = #{userAge}
        </if>

-- 使用where标签可以去掉 1= 1
        select * from user
        <where>
                    <if test="userName != null">
                        and username = #{userName}
                    </if>
                    <if test="userAge != 0">
                        and age = #{userAge}
                    </if>
        </where>
    </select>
```

当要给定一个List<id>要根据里面的id 查出对应的数据select * from user where id in (?,?,?...)
```java
    <select id="selectUser" resultMap="userMap" parameterType="UserList">
-- 引入抽取的sql语句，这个时候可以在sql语句那里不要加 分号; 还有一些语句末尾要注意是否有空格隔开
-- 不然到时解析sql语句的时候会出现有一些sql语句是连在一起的
        <include refid="defaultSql"></include>
        <where>
            <if test=" ids != null and ids.size() > 0  " >
--             在open里，不需要再写where 这个关键字，因为where标签已经给sql语句附上一个where了
--              后面接上一个and 关键字的时候，解析语句的时候是没有and这个关键字的
--              select * from user where id in (?,?)
                <foreach collection="ids" open="and id in ( " close=" ) " item="id" separator=",">
                    #{id}
                </foreach>
            </if>
        </where>
    </select>
```

抽取出相同的sql语句，以及如何引用，这里需要注意的是前后留出空格问题，以及抽取出来的sql不要加分号
```java
<!--    抽取相同的sql-->
    <sql id="defaultSql">
            select * from user
    </sql>
```
```java
   <include refid="defaultSql"></include>
```

关于模糊查询的操作，第一种方式需要在填写传入参数的时候加上两个百分号，这个时候sql语句采用的是预处理的查询方式，第二种方式就直接传递参数，这个时候采用的是拼接的方式
```java
<!--模糊查询，第一种是传过来带有%%的参数，第二种是采用字符串拼接技术-->
<!--第一种是预处理的方式，比较好-->
    <select id="findUserByName" resultType="com.mybatis.domain.User" parameterType="String">
--         select * from user where username like #{string}   //第一种
        select * from user where username like '%${value}%'		//第二种
    </select>

```

使用selectkey标签在做到同时先后执行sql语句如：insert into user（..）values（..）；select last_insert_id（）；这样子可以得到插入的数据的自增长id值，可以直接创建一个类，然后设置好数据后执行插入操作，执行完后再打印一个这个类，就可以看到id已经被赋予值了
```java
<!--添加完后获得所对应的自增长的id值，然后直接打印这个参数user就能看到这个值-->
    <insert id="addUser" parameterType="com.mybatis.domain.User">
        <selectKey keyProperty="id" keyColumn="id" resultType="int" order="AFTER">
            select last_insert_id ()
        </selectKey>
        insert into user (username,password)values(#{username},#{password})
    </insert>
```

**4.** **Mybatis中的多表查询，一对多，一对一，多对一，多对多。	以前对多表联合查询没有什么感悟，没有用到内连接和外连接那些查询方式，多表查询的时候因为是两个表组合出的数据，然后就重新去创建一个实体类，把这些数据的属性给包含进去，然后在反射成实体类。**

举例说明1：一个账号表和一个用户表，一个用户可以有多个账号，一个账号只有一个用户；如果要查询所有用户的信息，包括如果有账号的要查出对应的账号信息，这个时候可以在User类中加一个List<Account>的引用，这个时候采用的查询方式是左外连接，用以下方式，查询出来如果一个用户有多个账户就会封装在List中，没有则为空，左边全部显示右边不足为null
```java
    <resultMap id="userAccount" type="user">
        <id property="id" column="id"></id>
        <result property="userName" column="username"></result>
        <result property="userPassword" column="password"></result>
        <result property="userAge" column="age"></result>
<!--        如果是集合就使用collection这个标签，需要指定类型 ofType-->
<!--        查询用户信息，如果有账号信息要查出来，用左外连接，如果一个用户有多个账号
            那么mybatis会自动识别后封装在list中-->
        <collection property="accounts" ofType="account">
            <id property="id" column="aid"></id>
            <result property="number" column="number"></result>
            <result property="uid" column="uid"></result>
        </collection>
    </resultMap>

    <select id="findUserAccount" resultMap="userAccount">
            select a.id aid ,a.uid,a.number ,u.* from user u left join account a on u.id = a.uid
    </select>
```

举例说明2：还是一个账户表和一个用户表，如果要查询每一个账户的信息，包括所对应的用户的信息，就可以在Account类中加上一个User类的引用，这样子查询出来的用户信息会自动封装在User的引用中
```java
<!--    先配置account各个属性和列名的关系-->
    <resultMap id="accountMap" type="Account" autoMapping="true">
        <id property="id" column="aid"></id>
        <result property="number" column="number"></result>
        <result property="uid" column="uid"></result>
<!--        user属性是根据uid查来的,需要加上javaType标签，不然会报错-->
        <association property="user" column="uid" javaType="user" >
            <id property="id" column="id"></id>
            <result column="username" property="userName"></result>
            <result column="password" property="userPassword"></result>
            <result column="age" property="userAge"></result>
        </association>
    </resultMap>
    
    <select id="findAccountByUid" resultMap="accountMap">
        select u.* ,a.id as aid ,a.uid,a.number from account a ,user u where a.uid = u.id
    </select>
```

举例说明3：关于多对多的情况，一个角色表，一个用户表，一个角色可以多个用户都是，一个用户可以是多个角色，那这个时候就需要一个中间表，将用户的id和角色的id关联起来。那这个时候如果要查询角色的所有信息，如果这个角色有用户的话要显示出来，包括多个用户的情况，那就还是可以理解为一对多的情况，在角色表中添加用户的List<User>的属性引用，只不过这个时候的查询方式有所改变，首先要角色表和中间表进行一个左外连接查询然后再和用户表进行一个左外连接。
```java
    <resultMap id="roleMap" type="role">
        <id property="id" column="rid"></id>
        <result property="roleName" column="rolename"></result>
        <collection property="users" ofType="user">
            <id property="id" column="id"></id>
            <result property="userName" column="username" ></result>
            <result property="userPassword" column="password" ></result>
            <result property="userAge" column="age" ></result>
        </collection>
    </resultMap>

    <select id="findRoleUser" resultMap="roleMap">
        select u.*, r.id rid,r.role_name from role r left join role_user ru on r.id = ru.role_id
        left join user u on ru.user_id = u.id
    </select>
```

ps：如果是以前的理解，可以采用继承实体类的方式，比如要的到用户名和密码和账号信息，那可以继承Account实体类，然后添加属性username和password，这样就不用再写账号的属性，然后在打印toString的时候再加上super.toString就行了。


#### 第三部分，延迟加载和缓存
**延迟加载**
理解：有时候比如查询用户和对应的账号信息，这个时候可能用户有多个账号，那还不需要完全显示出来，就可以采用延迟加载的方式，就是先执行查询用户信息的语句，然后等要打印对应的账号信息的时候再查询账号信息（过程）。不过配置方式就要有所改变，需要指定一个根据用户id查询账号信息的方法。

首先是Mybatis-config.xml需要配置的开启支持延迟加载：
```java
    <!--    开启Mybatis支持延迟加载-->
    <settings>
        <setting name="mapUnderscoreToCamelCase" value="true"/>
        <setting name="lazyLoadingEnabled" value="true"></setting>
        <setting name="aggressiveLazyLoading" value="false"></setting>
    </settings>
```

其次是指定方法的配置：（不管是association还是collection都要有一个column的属性，用来指定剩余部分要靠什么参数查询，然后再指定一个select属性指定对应的查询的方法）
```java
<!--    先配置account各个属性和列名的关系-->
    <resultMap id="accountMap" type="Account" autoMapping="true">
        <id property="id" column="aid"></id>
        <result property="number" column="number"></result>
        <result property="uid" column="uid"></result>
<!--        user属性是根据uid查来的,需要加上javaType标签，不然会报错-->
        <association property="user" column="uid" javaType="user" select="com.mybatis.dao.UserDao.findUserById">
        </association>
    </resultMap>
```

**一级缓存**
理解：就是利用sqlSession创建出来的代理类对象，当selSession还没有被清空，被关闭，或者是在中间没有执行什么增删改的方法，这个时候如果前后各有一次相同的方法的查询的时候，所查询返回得到的对象（user）是同一个对象，这就是一级缓存。
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200724220706902.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NTg0MjQ3Nw==,size_16,color_FFFFFF,t_70)

**二级缓存**
理解：就是在sqlSessionFactory中，本来是一个一个的sqlSession对象，但是如果开启二级缓存的话，当这些对象拿到数据后，会把数据存放在sqlSessionFactory中，这个时候存放的不是对象，而是数据。以下图片是二级缓存的开启方式：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200724221023116.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200724221028978.png)
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200724221120701.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80NTg0MjQ3Nw==,size_16,color_FFFFFF,t_70)

#### 第四部分，注解开发
Mybatis中的注解模式还是相对比较简单操作的，无需XxxMapper.xml的配置，只需在对应的Dao接口的每个方法上添加注解和sql语句，就可以执行，还有一些给属性起别名的操作的注解也是跟xml中的标签差不多，以下不再一 一做介绍，以一个dao接口为例：

```java
@CacheNamespace(blocking = true)
public interface UserDao {

    /**
     * 查找全部
     * @return
     */
    @Select("select * from user")
    List<User> selectUser(UserList userList);

    /**
     * 根据条件查找用户
     * @param user
     * @return
     */
    @Select("select * from user where username = #{userName}")
    @Results(id = "userMap",value = {
            @Result(id=true,column = "id",property = "id"),
            @Result(column = "username",property = "userName"),
            @Result(column = "password",property = "userPassword"),
            @Result(column = "age",property = "userAge"),

    })
    User findUser(User user);

    /**
     * 添加用户
     * @param user
     */

    @Insert("insert into user(username,password,age)values(#{userName},#{userPassword},#{userAge})")
    void addUser(User user);

    /**
     * 删除用户
     * @param id
     */
    @Delete("delete from user where id = #{id}")
    void deleteUser(int id);

    /**
     * 修改用户信息
     * @param user
     */
    @Update("update user set username = #{userName} where id = #{id}")
    void updateUser(User user);

    /**
     * 数据库模糊查询
     * @param name
     */
    @Select("select * from user where username like #{String}")
    @ResultMap(value = {"userMap"})
     List<User> findUserByName(String name);

    /**
     * 根据用户信息查询余额
     * @param user
     * @return
     */
    Account findAccountByid(User user);


    /**
     * 一对一查询，就是在user类中有account类的引用
     * @return
     */
    @Select("select * from user")
    @Results(value = {
            @Result(id=true,column = "id",property = "id"),
            @Result(column = "username",property = "userName"),
            @Result(column = "password",property = "userPassword"),
            @Result(column = "age",property = "userAge"),
            @Result(column = "id" ,property = "account" ,one = @One(select = "com.mybatis.dao.AccountDao.findAccountByUid",fetchType = FetchType.EAGER))
    })
    List<User> findUserAccount();

    /**
     * 一对一查询，就是在user类中有account类的引用
     * @return
     */
    @Select("select * from user")
    @Results(value = {
            @Result(id=true,column = "id",property = "id"),
            @Result(column = "username",property = "userName"),
            @Result(column = "password",property = "userPassword"),
            @Result(column = "age",property = "userAge"),
            @Result(column = "id" ,property = "accounts" , many= @Many(select = "com.mybatis.dao.AccountDao.findAccountByUid",fetchType = FetchType.LAZY))
    })
    List<User> findUserAccounts();


    /**
     * 根据用户的id查询用户
     * @param id
     * @return
     */
    User findUserById(int id);
}

```
 
其中通过Results注解来定义类的属性的别名，还是可以通过Results这个注解的id去引用到别的注解上，就不用每次都重复写别名配置。
最后的many和one分别表示引用属性是List类型还是单个类的类型，fetchType属性表示是否开启延迟加载。

注解形式开启二级缓存：
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200725085357933.png)
在接口中配置注解CacheNamespace
![在这里插入图片描述](https://img-blog.csdnimg.cn/20200725085346687.png)

ps：后续有更深入的内容会继续完善补充，包括MybatisPlus框架的相关功能。
