package com.wanma.wanma_equipment;

import android.app.Application;
import android.util.Log;

/**
 * @Class: App
 * @Description:
 * @author: CJN
 * @Date: 2020/12/21
 */
public class App extends Application {

    public static ScanManager mScanManage;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d("--GetInstance--","----->>create 1");
        mScanManage = ScanManager.getInstance(getApplicationContext());
        Log.d("--GetInstance--","----->>create 2");
    }
}
