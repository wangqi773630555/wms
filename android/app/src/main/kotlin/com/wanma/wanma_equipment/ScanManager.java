package com.wanma.wanma_equipment;

import android.app.Service;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.os.RemoteException;
import android.view.KeyEvent;


import com.olc.scan.IScanServer;



/**
 * @Author: chao.cao
 * @Date: 2020/9/2 15:13
 * @Description:
 */
public class ScanManager {

    private static final String TAG = "ScanManager" ;

    private IScanServer mService;

    private Context mContext ;

    private static ScanManager Instance;

    public static ScanManager getInstance(Context context) {
        if (Instance == null) {
            Instance = new ScanManager(context);
        }
        return Instance;
    }

    public ScanManager(Context context) {
        this.mContext = context;

        Intent i = new Intent("com.olc.scan.ScanServer");
        i.setPackage("com.olc.scan");
        context.bindService(i,conn, Service.BIND_AUTO_CREATE);
    }

    ServiceConnection conn = new ServiceConnection() {
        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            mService= IScanServer.Stub.asInterface(service);
            initScanner();
        }

        @Override
        public void onServiceDisconnected(ComponentName name) {
        }
    };

    public boolean initScanner(){
        if(mService != null){
            try {
                mService.initScanner();
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
        return false ;
    }

    public boolean scanProcess(KeyEvent event){
        if(mService != null){
            try {
                mService.scanProcess(event);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
        return false ;
    }



    public void setScanSwitchLeft(boolean flag){
        if(mService!=null){
            try {
                mService.setScanSwitchLeft(flag);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }


    public void setScanSwitchMiddle(boolean flag){
        if(mService!=null){
            try {
                mService.setScanSwitchMiddle(flag);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }


    public void setScanSwitchRight(boolean flag){
        if(mService!=null){
            try {
                mService.setScanSwitchRight(flag);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }


    public void setScanOperatingMode(int state){
        if(mService!=null){
            try {
                mService.setScanOperatingMode(state);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }


    public void setScanSound(boolean flag){
        if(mService!=null){
            try {
                mService.setScanSound(flag);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }


    public void setScanVibrate(boolean flag){
        if(mService!=null){
            try {
                mService.setScanVibrate(flag);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }


    public void setBarcodeReceiveModel(int state){
        if(mService!=null){
            try {
                mService.setBarcodeReceiveModel(state);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }



    public void setScanDelay(float delay){
        if(mService!=null){
            try {
                mService.setScanDelay(delay);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }


    public void setBarcodeSeparator(int state){
        if(mService!=null){
            try {
                mService.setBarcodeSeparator(state);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }


    public void setBarcodePrefixState(boolean flag){
        if(mService!=null){
            try {
                mService.setBarcodePrefixState(flag);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }

    public void setBarcodePrefix(String prefix){
        if(mService!=null){
            try {
                mService.setBarcodePrefix(prefix);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }


    public void setBarcodeSuffixState(boolean flag){
        if(mService!=null){
            try {
                mService.setBarcodeSuffixState(flag);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }


    public void setBarcodeSuffix(String suffix){
        if(mService!=null){
            try {
                mService.setBarcodeSuffix(suffix);
            } catch (RemoteException e) {
                e.printStackTrace();
            }
        }
    }









}
