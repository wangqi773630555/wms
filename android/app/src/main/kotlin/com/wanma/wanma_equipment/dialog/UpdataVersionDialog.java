package com.wanma.wanma_equipment.dialog;

import android.app.Dialog;
import android.content.Context;

/**
 * 版本更新
 * author: MrWang on 2022/11/2
 * email:773630555@qq.com
 * date: on 2022/11/2 14:52
 */

public class UpdataVersionDialog extends Dialog {
    private int res;

    public UpdataVersionDialog(Context context, int theme, int res) {
        super(context, theme);
        // TODO 自动生成的构造函数存根
        setContentView(res);
        this.res = res;
        setCanceledOnTouchOutside(false);
    }

}