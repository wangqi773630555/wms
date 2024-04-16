import 'package:flutter/material.dart';
import '../../../common/config/config.dart';
import '../../../common/dao/data_dao.dart';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/common/local/local_storage.dart';

import '../../common/dao/user_dao.dart';

class ScanSignIn extends StatelessWidget {
  static const String sName = Config.SCANSIGNIN;

  const ScanSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ScanSignInBody());
  }
}

class ScanSignInBody extends StatefulWidget {
  const ScanSignInBody({Key? key}) : super(key: key);

  @override
  _ScanSignInBodyState createState() => _ScanSignInBodyState();
}

class _ScanSignInBodyState extends State<ScanSignInBody> {
  ScanResult? scanResult;
  bool isScan = true;
  var _userName;
  var text = '';
  bool success = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      await _scan();
    });
    initParams();
  }
  initParams() async {
    _userName = await LocalStorage.get(Config.USER_NAME_KEY) ?? '';
  }

  signin(content) {
    UserDao.signin(content+','+_userName).then((res) {
      if (res != null && res.result) {
        setState(() {
          text = '签到成功';
          success = true;
          isScan = false;
        });
      }else{
        setState(() {
          text = res.data;
          success = false;
          isScan = false;
        });

       // print(res.data);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('扫码签到'),
            actions: <Widget>[
              IconButton(
                // action button
                icon: Icon(Icons.center_focus_strong_rounded),
                onPressed: (){
                   _scan();
                },
              ),
            ]

        ),
        body: isScan
            ? Center(child: Container(
          child: Text('请 扫 码 签 到',style: TextStyle(fontWeight:FontWeight.bold,fontSize: 25),),
        ))
            : Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(padding: EdgeInsets.only(top: 100)),
              Icon(success?Icons.check_circle:Icons.error,color:success?Colors.green:Colors.red,size: 100,),
              Padding(padding: EdgeInsets.only(top: 20)),
              Text(text,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
            ],

          ),
        ));
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': '取消',
            'flash_on': '打开闪光灯',
            'flash_off': '关闭闪光灯',
          },
        ),
      );
      setState(() => {
            scanResult = result,
            if (scanResult?.rawContent != '')
              {
                signin(scanResult!.rawContent)
              }
            else
              {
                //Fluttertoast.showToast(msg: '二维码扫描失败'),
                Navigator.pop(context)
              }
          });
    } on PlatformException catch (e) {
      //Fluttertoast.showToast(msg: '二维码扫描失败');
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
