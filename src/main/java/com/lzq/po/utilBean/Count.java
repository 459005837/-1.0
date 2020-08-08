package com.lzq.po.utilBean;

/**
 * 查询总记录数反射类
 * 因为自己写的baseDao不支持返回某个值的sql语句，所以只能创建一个单独的类来获得总记录数
 */

public class Count {
    private Long count;

    public Long getCount() {
        return count;
    }

    public void setCount(Long count) {
        this.count = count;
    }
}
