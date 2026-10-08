package com.wanma.wanma_print

import Printer.PrintHelper
import android.annotation.SuppressLint
import android.app.Dialog
import android.app.Instrumentation
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Color
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.os.Handler
import android.util.Log
import android.view.View
import android.view.WindowManager
import android.widget.ProgressBar
import android.widget.TextView
import android.widget.Toast
import com.allenliu.versionchecklib.callback.OnCancelListener
import com.allenliu.versionchecklib.v2.AllenVersionChecker
import com.allenliu.versionchecklib.v2.builder.DownloadBuilder
import com.allenliu.versionchecklib.v2.builder.UIData
import com.allenliu.versionchecklib.v2.callback.CustomDownloadFailedListener
import com.allenliu.versionchecklib.v2.callback.CustomDownloadingDialogListener
import com.allenliu.versionchecklib.v2.callback.CustomVersionDialogListener
import com.google.zxing.BarcodeFormat
import com.google.zxing.EncodeHintType
import com.google.zxing.MultiFormatWriter
import com.google.zxing.WriterException
import com.wanma.wanma_print.dialog.UpdataVersionDialog
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*

class MainActivity: FlutterActivity() {

    var i: Int = 0;
    val CHANNEL: String = "hyflapp"
    val mKeyTextSize = 18
    val mValueTextSize = 16
    val mOffsetX = 210
    var methodChannel_toFlutter: MethodChannel? = null

    lateinit var printHelper: PrintHelper
    lateinit var methodChannel: MethodChannel
    lateinit var builder: DownloadBuilder

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        methodChannel.setMethodCallHandler { call, result ->
            if(call.method.equals("print")){
                var printContent:List<String>
                var ids:List<String>
                try {
                    printContent= call.arguments.toString().split(";")
                    initPrinter()
                    var  count:Int = printContent.get(4).toDouble().toInt()
                    if(count==0){
                        Toast.makeText(context, "请设置打印张数", Toast.LENGTH_SHORT).show()
                    }
                   // var  showCount:Int = printContent.get(3).toDouble().toInt()
                    //Toast.makeText(context, count.toString()+"", Toast.LENGTH_SHORT).show()
                    ids = printContent.get(6).split(",")

                    for (i in 0 until count) {
                        print(printContent.get(0),printContent.get(1),printContent.get(2),printContent.get(3),printContent.get(5),ids.get(i))
                    }
                    //print(printContent.get(0),printContent.get(1),printContent.get(2),printContent.get(3))
                }catch (e:Exception){
                    Toast.makeText(context, "打印参数异常", Toast.LENGTH_SHORT).show()
                }

            }
            if(call.method.equals("walk")){
                initPrinter()
                printHelper.GoToNextPage()
            }

            if(call.method.equals("update")){
                var updateContent:List<String>
                try {
                    updateContent= call.arguments.toString().split(";")
                    var  count:Int = updateContent.get(0).toDouble().toInt()
                    var  url:String = updateContent.get(1)
                    if(count>getVersionCode()){
                        sendRequest(System.currentTimeMillis().toString(),url,"有新的版本请更新！");
                    }
                }catch (e:Exception){
                    Toast.makeText(context, "版本号异常", Toast.LENGTH_SHORT).show()
                }

            }

            if (call.method.equals("version")) {
                var newCode:String= call.arguments.toString()
                try {
                    if(newCode.toDouble().toInt()>getVersionCode()){
                       result.success("1")
                    }else{
                        result.success("0")
                    }
                }catch (e:Exception){
                    Toast.makeText(context, "版本号异常"+newCode, Toast.LENGTH_SHORT).show()
                }
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //applyKitKatTranslucency();
        methodChannel_toFlutter =
            getFlutterEngine()?.getDartExecutor()?.getBinaryMessenger()?.let {
                MethodChannel(it,"toFlutterChannelName"
                )
            };
        scanSetting()
    }


    fun scanSetting(){
      /*  Handler().postDelayed({
            App.mScanManage.setScanSwitchLeft(true)
            App.mScanManage.setScanSwitchRight(true)
            App.mScanManage.setBarcodeReceiveModel(2)
        }, 5000)*/

    }

    override fun onResume() {
        val intentFilter = IntentFilter()
        intentFilter.addAction("com.barcode.sendBroadcast")
        registerReceiver(myBroastcast, intentFilter)
        super.onResume()
    }

    override fun onPause() {
        unregisterReceiver(myBroastcast);
        super.onPause()
    }


    private val myBroastcast: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val str = intent.getStringExtra("BARCODE")
            if (str != null) {
                /*val inputConnection: InputConnection = BaseInputConnection(EditText(
                    applicationContext), false)
                inputConnection.commitText(str, 0);*/
                invokeFlutterMethod_toAllFlutter(str)
            }
        }
    }


    fun initPrinter() {
        printHelper = PrintHelper()
        printHelper.Open(activity.application)
        printHelper.SetGrayLevel(6.toByte())
    }

    fun print(name:String, no:String, lot:String, count:String,singleCount:String,id:String) {

        // TODO Auto-generated method stub
        printHelper.printBlankLine(1)
        printHelper.PrintStringEx(name, mKeyTextSize, false, true,PrintHelper.PrintType.Centering)
        printHelper.printBlankLine(1)

        printHelper.PrintLineInit(mKeyTextSize)
        printHelper.PrintLineStringByType("  标签号", mKeyTextSize, PrintHelper.PrintType.Left, true)
        printHelper.PrintLineString(id, mValueTextSize, mOffsetX, false) //160
        printHelper.PrintLineEnd()

        printHelper.PrintLineInit(mKeyTextSize)
        printHelper.PrintLineStringByType("  物料号", mKeyTextSize, PrintHelper.PrintType.Left, true)
        printHelper.PrintLineString(no, mValueTextSize, mOffsetX, false) //160
        printHelper.PrintLineEnd()
        printHelper.PrintLineInit(mKeyTextSize)
        printHelper.PrintLineStringByType("  物料批次", mKeyTextSize, PrintHelper.PrintType.Left, true)
        printHelper.PrintLineString(lot, mValueTextSize, mOffsetX, false) //160
        printHelper.PrintLineEnd()
        printHelper.PrintLineInit(mKeyTextSize)
        printHelper.PrintLineStringByType("  数量", mKeyTextSize, PrintHelper.PrintType.Left, true)
        printHelper.PrintLineString(count, mValueTextSize, mOffsetX, false) //160
        printHelper.PrintLineEnd()
        printHelper.PrintLineInit(mKeyTextSize)
        printHelper.PrintLineStringByType("  单张物料", mKeyTextSize, PrintHelper.PrintType.Left, true)
        printHelper.PrintLineString(singleCount, mValueTextSize, mOffsetX, false) //160
        printHelper.PrintLineEnd()

        //Toast.makeText(context, count+","+singleCount, Toast.LENGTH_SHORT).show()

        var bm: Bitmap? = null
        try {
            //var content:String = no+";"+lot+";"+count+";"+singleCount
            bm = Create2DCode(id);
        } catch (e: WriterException) {
            e.printStackTrace()
        }
        if (bm != null) {
            printHelper.PrintBitmapAtHorizontalCenter(bm)
        }
        // printHelper.printBlankLine(80)
        printHelper.GoToNextPage()


    }

    @Throws(WriterException::class)
    fun Create2DCode(str: String?): Bitmap? {
        val hints = Hashtable<EncodeHintType, String?>()
        hints[EncodeHintType.CHARACTER_SET] = "UTF-8"
        val matrix = MultiFormatWriter().encode(str, BarcodeFormat.QR_CODE, 125, 125, hints)
        val width = matrix.width
        val height = matrix.height
        val pixels = IntArray(width * height)
        for (y in 0 until height) {
            for (x in 0 until width) {
                if (matrix[x, y]) {
                    pixels[y * width + x] = -0x1000000
                }
            }
        }
        val bitmap = Bitmap.createBitmap(width, height,
            Bitmap.Config.ARGB_8888)
        bitmap.setPixels(pixels, 0, width, 0, 0, width, height)
        return bitmap
    }

    fun invokeFlutterMethod_toAllFlutter(str:String) {
        if (methodChannel_toFlutter != null) {
            methodChannel_toFlutter!!.invokeMethod("flutterMethod",
                str,
                object : MethodChannel.Result {
                    override fun success(o: Any?) {
                        Log.e("MainActivity", "invokeFlutterMethod_toAllFlutter success")
                    }

                    override fun error(s: String, s1: String?, o: Any?) {
                        Log.e("MainActivity", "invokeFlutterMethod_toAllFlutter error")
                    }

                    override fun notImplemented() {
                        Log.e("MainActivity", "invokeFlutterMethod_toAllFlutter notImplemented")
                    }
                })
        }else{
            Toast.makeText(context, "null", Toast.LENGTH_SHORT).show()
        }
    }

    @SuppressLint("LongLogTag")
    private fun typeIn(KeyCode: Int) {
        try {
            val inst = Instrumentation()
            inst.sendKeyDownUpSync(KeyCode)
        } catch (e: java.lang.Exception) {
            Log.e("Exception when sendKeyDownUpSync", e.toString())
        }
    }



    //版本更新
    /**
     * 发送请求获取更新信息
     */
    private fun sendRequest(name: String, url: String, content: String) {
        builder = AllenVersionChecker.getInstance().downloadOnly(crateUIData(url, content))
        //更新提示框样式
        builder.setCustomVersionDialogListener(createCustomDialogOne())
        builder.setOnCancelListener(OnCancelListener {

        })
        //进度条样式
        builder.setCustomDownloadingDialogListener(createCustomDownloadingDialog())
        //下载失败样式
        builder.setCustomDownloadFailedListener(createCustomDownloadFailedDialog())
        //自定义下载路径
        builder.setDownloadAPKPath(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
            .toString() + "/WANMA/Version/")
        builder.setApkName(name)
        builder.executeMission(this)
    }

    /**
     * 自定义更新弹窗页面
     * 务必用库传回来的context 实例化你的dialog
     * 自定义的dialog UI参数展示，使用versionBundle
     *
     * @return
     */
    private fun createCustomDialogOne(): CustomVersionDialogListener? {
        return CustomVersionDialogListener { context: Context?, versionBundle: UIData ->
            val baseDialog =
                UpdataVersionDialog(context, R.style.BaseDialog, R.layout.custom_dialog_one_layout)
            val textView: TextView = baseDialog.findViewById(R.id.tv_msg)
            textView.text = versionBundle.content
            baseDialog
        }
    }


    /**
     * 自定义下载失败
     * 务必用库传回来的context 实例化你的dialog
     *
     * @return
     */
    private fun createCustomDownloadFailedDialog(): CustomDownloadFailedListener? {
        return CustomDownloadFailedListener { context: Context?, versionBundle: UIData? ->
            val baseDialog =
                UpdataVersionDialog(context,
                    R.style.BaseDialog,
                    R.layout.custom_download_failed_dialog)
            baseDialog
        }
    }


    /**
     * 自定义下载中对话框，下载中会连续回调此方法 updateUI
     * 务必用库传回来的context 实例化你的dialog
     *
     * @return
     */
    private fun createCustomDownloadingDialog(): CustomDownloadingDialogListener? {
        return object : CustomDownloadingDialogListener {
            override fun getCustomDownloadingDialog(
                context: Context,
                progress: Int,
                versionBundle: UIData,
            ): Dialog {
                return UpdataVersionDialog(context,
                    R.style.BaseDialog,
                    R.layout.custom_download_layout)
            }

            override fun updateUI(dialog: Dialog, progress: Int, versionBundle: UIData) {
                val tvProgress = dialog.findViewById<TextView>(R.id.tv_progress)
                val progressBar = dialog.findViewById<ProgressBar>(R.id.pb)
                progressBar.progress = progress
                tvProgress.text = getString(R.string.versionchecklib_progress, progress)
            }
        }
    }


    /**
     * @return
     * @important 使用请求版本功能，可以在这里设置downloadUrl
     * 这里可以构造UI需要显示的数据
     * UIData 内部是一个Bundle
     */
    private fun crateUIData(url: String, content: String): UIData? {
        val uiData = UIData.create()
        uiData.title = "版本更新"
        uiData.downloadUrl = url
        uiData.content = content
        return uiData
    }

    /**
     * 获得版本code
     * @return
     */
    @SuppressLint("WrongConstant")
    fun getVersionCode(): Int {
        // TODO Auto-generated method stub
        val pi: PackageInfo
        try {
            pi = getPackageManager()
                .getPackageInfo(getPackageName(),
                    PackageManager.COMPONENT_ENABLED_STATE_DEFAULT)
            return pi.versionCode
        } catch (e: PackageManager.NameNotFoundException) {
            // TODO Auto-generated catch block
            e.printStackTrace()
        }
        return 1
    }

    override fun onDestroy() {
        super.onDestroy()
        AllenVersionChecker.getInstance().cancelAllMission(this)
    }

    fun setStateColor(dark: Boolean) {
        val decor: View = getWindow().getDecorView()
        if (!dark) {
            decor.setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
        } else {
            decor.setSystemUiVisibility(View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN or View.SYSTEM_UI_FLAG_LAYOUT_STABLE)
        }
    }

}
