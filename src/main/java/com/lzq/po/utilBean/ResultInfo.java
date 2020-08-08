package com.lzq.po.utilBean;

import java.io.Serializable;

/**
 * 数据响应类
 * 成功与否的标识以及响应信息
 */

public class ResultInfo implements Serializable {
    private boolean flag;
    private String Msg;

    public ResultInfo() {
    }

    public ResultInfo(boolean flag) {
        this.flag = flag;
    }

    public ResultInfo(boolean flag, String Msg) {
        this.flag = flag;
        this.Msg = Msg;
    }

    public boolean isFlag() {
        return flag;
    }

    public void setFlag(boolean flag) {
        this.flag = flag;
    }

    public String getMsg() {
        return Msg;
    }

    public void setMsg(String Msg) {
        this.Msg = Msg;
    }
}
