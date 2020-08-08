package com.lzq.service;


import com.lzq.bean.ArticleList;
import com.lzq.po.utilBean.PageBean;

public interface ArticleListService {
    //首页文章数据的分页查询
    PageBean<ArticleList> articleList(int currentPage, int pageSize, String findStr, String findType);
}
