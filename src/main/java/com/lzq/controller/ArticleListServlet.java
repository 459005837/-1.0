package com.lzq.controller;

import com.lzq.bean.ArticleList;
import com.lzq.po.utilBean.PageBean;
import com.lzq.service.ArticleListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/articleList")
public class ArticleListServlet {

    @Autowired
    private ArticleListService service;

    /**
     * 首页文章数据的展示
     */
    @RequestMapping("/articleListByPage")
    public @ResponseBody
    PageBean<ArticleList> articleListByPage(@RequestParam(value = "currentPage",required = false) String currentPageStr, @RequestParam(value = "findStr",required = false)  String findStr, String findType) {

        //设置每页显示五条数据
        int pageSize = 10;
        //设置当前页码
        int currentPage = 0;
        if(currentPageStr != null && currentPageStr.length() > 0){
            currentPage = Integer.parseInt(currentPageStr);
        }else{
            currentPage = 1;
        }
        //调用service查询PageBean对象
        return service.articleList(currentPage, pageSize,findStr,findType);
    }

}
