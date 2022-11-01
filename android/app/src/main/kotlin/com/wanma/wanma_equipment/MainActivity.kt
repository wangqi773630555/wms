package com.wanma.wanma_equipment

import Printer.PrintHelper
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.graphics.Bitmap
import android.os.Bundle
import android.os.Handler
import android.os.PersistableBundle
import android.util.Log
import android.widget.Toast
import com.google.zxing.BarcodeFormat
import com.google.zxing.EncodeHintType
import com.google.zxing.MultiFormatWriter
import com.google.zxing.WriterException
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*

class MainActivity: FlutterActivity() {

    var i: Int = 0;
    val CHANNEL: String = "hyflapp"
    val mKeyTextSize = 24
    val mValueTextSize = 22
    val mOffsetX = 210
    var methodChannel_toFlutter: MethodChannel? = null

    lateinit var printHelper: PrintHelper
    lateinit var methodChannel: MethodChannel
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        methodChannel =
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        methodChannel.setMethodCallHandler { call, result ->
            if(call.method.equals("print")){
                var printContent:List<String>
                try {
                    printContent= call.arguments.toString().split(";")
                    initPrinter()
                    var  count:Int = printContent.get(4).toDouble().toInt()
                    if(count==0){
                        Toast.makeText(context, "请设置打印张数", Toast.LENGTH_SHORT).show()
                    }
                   // var  showCount:Int = printContent.get(3).toDouble().toInt()
                    //Toast.makeText(context, count.toString()+"", Toast.LENGTH_SHORT).show()
                    for (i in 0 until count) {
                        print(printContent.get(0),printContent.get(1),printContent.get(2),printContent.get(3),printContent.get(5))
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

        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        methodChannel_toFlutter =
            getFlutterEngine()?.getDartExecutor()?.getBinaryMessenger()?.let {
                MethodChannel(it,"toFlutterChannelName"
                )
            };
        scanSetting()

    }


    fun scanSetting(){
        Handler().postDelayed({
            App.mScanManage.setScanSwitchLeft(true)
            App.mScanManage.setScanSwitchRight(true)
            App.mScanManage.setBarcodeReceiveModel(2)
        }, 5000)

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

    override fun onDestroy() {
        super.onDestroy()
    }

    private val myBroastcast: BroadcastReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val str = intent.getStringExtra("BARCODE")
            if (str != null) {
                invokeFlutterMethod_toAllFlutter(str)
            }
        }
    }


    fun initPrinter() {
        printHelper = PrintHelper()
        printHelper.Open(activity.application)
        printHelper.SetGrayLevel(6.toByte())
    }

    fun print(name:String, no:String, lot:String, count:String,singleCount:String) {

        // TODO Auto-generated method stub
        printHelper.printBlankLine(5)
        printHelper.PrintStringEx(name, mKeyTextSize, false, true,PrintHelper.PrintType.Centering)
        printHelper.printBlankLine(15)
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
            var content:String = no+";"+lot+";"+count+";"+singleCount
            bm = Create2DCode(content);
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
        val matrix = MultiFormatWriter().encode(str, BarcodeFormat.QR_CODE, 150, 150, hints)
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
}
