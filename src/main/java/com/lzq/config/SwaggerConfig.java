package com.lzq.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.Environment;
import org.springframework.core.env.Profiles;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.service.Contact;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;

import java.util.ArrayList;

@Configuration//配置类
@EnableSwagger2//开启swagger2自动配置
@EnableWebMvc
public class SwaggerConfig {


    @Bean   //配置docket 来配置swagger的具体参数
    public Docket docket(Environment environment){

//        //设置要显示swagger的环境
//        Profiles of = Profiles.of("dev","test");
//        //判断当前是否属于该环境， 使用enable接收该flag进行开关
//        boolean flag = environment.acceptsProfiles(of);
//
//        System.out.println(flag);

        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .groupName("lzq")
//                .enable(flag)
                //select() build() 是一套
                .select()//通过select（）方法，去扫描接口， RequestHandlerSelectors 配置如何扫描
//                .apis(RequestHandlerSelectors.basePackage("com.lzq.hello"))//扫描指定包下的接口
//                .apis(RequestHandlerSelectors.any())//扫描全部接口
//                .apis(RequestHandlerSelectors.none())//不扫描
//                .apis(RequestHandlerSelectors.withClassAnnotation(RestController.class))//扫描指定注解下的类
//                .apis(RequestHandlerSelectors.withMethodAnnotation(GetMapping.class))//扫描指定注解的方法
                .apis(RequestHandlerSelectors.basePackage("com.lzq.controller"))
//                .paths(PathSelectors.ant("/lzq/**"))//过滤扫描路径
                .build();
    }

    //配置文档信息
    private ApiInfo apiInfo(){

        Contact contact = new Contact("李泽强", "https://blog.csdn.net/weixin_45842477", "459005837@qq.com");
        return new ApiInfo(
                "Swagger学习",
                "配置Swagger文档信息",
                "1.0",
                "https://blog.csdn.net/weixin_45842477",
                contact,
                "Apache 2.0",
                "http://www.apache.org/licenses/LICENSE-2.0",
                new ArrayList());
    }
}


