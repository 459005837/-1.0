package com.lzq.service.impl;



import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.lzq.bean.ArticleList;
import com.lzq.mapper.ArticleListDao;
import com.lzq.po.Article;
import com.lzq.po.utilBean.PageBean;
import com.lzq.service.ArticleListService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class ArticleListServiceImpl implements ArticleListService {

    @Autowired
    private ArticleListDao dao ;

    /**
     * 首页文章数据的展示
     */
    @Override
    public PageBean<ArticleList> articleList(int currentPage, int pageSize, String findStr, String findType) {
        //根据条件和当前页和每页数据显示
        Page<ArticleList> page = new Page<>(currentPage,pageSize);
        //设置条件
        Article article = new Article();
        article.setTypeId(Integer.parseInt(findType));
        article.setKeyWord("%"+findStr+"%");
        //得到分页对象
        IPage<ArticleList> aip = dao.selectPageByOther(page, article);

        //构造分页对象
        PageBean<ArticleList> pb = new PageBean<>();
        //设置参数
        pb.setCurrentPage(currentPage);
        pb.setRows(pageSize);
        pb.setTotalCount((int) aip.getTotal());
        if (aip.getRecords().size()==0){
            pb.setList(null);
        }else{
            pb.setList(aip.getRecords());
        }
        pb.setTotalPage((int) aip.getPages());
        return pb;
    }
}
