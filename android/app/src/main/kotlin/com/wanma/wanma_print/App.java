package com.wanma.wanma_print;

import android.app.Application;
import android.util.Log;
import androidx.multidex.MultiDexApplication; // ���������

/**
 * @Class: App
 * @Description:
 * @author: CJN
 * @Date: 2020/12/21
 */
public class App extends MultiDexApplication {

   //public static ScanManager mScanManage;

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d("--GetInstance--","----->>create 1");
        //mScanManage = ScanManager.getInstance(getApplicationContext());
        Log.d("--GetInstance--","----->>create 2");
    }
}