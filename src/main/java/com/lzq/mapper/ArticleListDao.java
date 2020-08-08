package com.lzq.mapper;


import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lzq.bean.ArticleList;
import com.lzq.po.Article;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface ArticleListDao extends BaseMapper<ArticleList> {

    /**
     * 多表分页模糊擦查询
     * @param page
     * @param article
     * @return
     */
    IPage<ArticleList> selectPageByOther(Page<ArticleList> page, @Param("article") Article article);
}
