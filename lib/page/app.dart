import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanma_print/common/config/config.dart';
import 'package:wanma_print/common/utils/common_utils.dart';
import 'package:wanma_print/page/home_page.dart';
import 'package:wanma_print/widget/home_drawer.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../common/json/json_string.dart';

///主页

class App extends StatefulWidget {
  static final String sName = Config.HOME;

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  /// 提示退出
  _dialogExitApp(BuildContext context) async {
    var result = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              content: Text('确定要退出应用？'),
              actions: <Widget>[
                TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: Text('取消')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text('确定')),
              ],
            ));
    return result;
  }

  @override
  void initState() {
    super.initState();
//    UserInfoDbProvider provider = UserInfoDbProvider();
//    provider.queryUser('2005');
    //检查版本更新
    CommonUtils.checkVersion(context, false);
  }

  Widget build(BuildContext context) {
    final double Wwidth = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    final double Hheight = MediaQuery.of(context).size.height;
    // var data = json.decode(JsonString.homeData) as Map;
    // List dataList = data['result'];
    var backBox = Container(
      margin: EdgeInsets.only(top: 0),
      width: Wwidth,
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('images/home/pg1.png'),
        fit: BoxFit.fill,
      )),
      child: Column(children: [
        Container(
          margin: EdgeInsets.only(top: 80, left: 20),
          alignment: Alignment.bottomLeft,
          child: Text(
            '万 马 股 份',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
          ),
        ),
        Padding(padding: new EdgeInsets.all(5.0)),
        Container(
          margin: EdgeInsets.only(left: 20),
          alignment: Alignment.bottomLeft,
          child: Text(
            '正 人、正 事、正 品',
            style: TextStyle(fontSize: 20),
          ),
        )
      ]),
    );
    return WillPopScope(
        child: Scaffold(
          drawer: HomeDrawer(),
          appBar: AppBar(
            backgroundColor: Theme.of(context).primaryColor,
            title: Text(Config.APP_HOME),
            centerTitle: true,
          ),
          body:
              // Stack(
              //   children: [

              Container(
                  height: Hheight - 105,
                  width: Wwidth,
                  color: Color.fromARGB(255, 236, 243, 250),
                  child: Stack(children: [
                    backBox,
                    Positioned(
                        top: 170,
                        left: 10,
                        child: SingleChildScrollView(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: new BorderRadius.circular((5.0)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromARGB(255, 200, 202, 198),
                                    offset: Offset(0.5, 0.5),
                                    blurRadius: 1.0,
                                    spreadRadius: 1.0),
                              ],
                            ),
                            width: Wwidth - 20,
                            height: Hheight - 150,
                            child: HomePage(),
                          ),
                        ))
                  ])),

          // ],
          // )
        ),
        onWillPop: () async {
          bool result = await _dialogExitApp(context);
          return Future.value(result);
        });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
