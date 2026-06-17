import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanma_print/common/config/config.dart';
import 'package:wanma_print/common/dao/user_dao.dart';
import 'package:wanma_print/common/dao/data_dao.dart';
import 'package:wanma_print/common/db/base_db_manager.dart';
import 'package:wanma_print/common/local/local_storage.dart';
import 'package:wanma_print/common/utils/common_utils.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wanma_print/common/redux/wm_state.dart';
import 'package:wanma_print/common/style/wm_style.dart';
import 'package:wanma_print/common/utils/navigator_utils.dart';
import 'package:wanma_print/common/utils/screen_util.dart';

import '../FlutterPlugins.dart';

class HomeDrawer extends StatelessWidget {
  //关于
  showAboutDialog(BuildContext context, String versionName) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: Text('当前版本：$versionName'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('确定'),
          ),
        ],
      ),
    );
  }

  //主题切换
  showThemeDialog(BuildContext context, Store store) {
    List<String> listStr = [
      '默认主题',
      '主题一',
      '主题二',
      '主题三',
      '主题四',
      '主题五',
      '主题六',
    ];
    List<Color> listColor = CommonUtils.getThemeListColor();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Center(
            child: Container(
              width: 250.0,
              height: 400.0,
              padding: EdgeInsets.all(4.0),
              margin: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Color(WMColors.white),
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: ListView.builder(
                itemCount: listStr.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: listColor != null
                          ? listColor[index]
                          : Theme.of(context).primaryColor,
                      elevation: 20,
                      textStyle: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    child: Flex(
                      mainAxisAlignment: MainAxisAlignment.start,
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Text(
                          listStr[index],
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      CommonUtils.pushTheme(store, index);
                      LocalStorage.save(Config.THEME_COLOR, index.toString());
                    },
                  );
                },
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Material(
      child: StoreBuilder<WMState>(
        builder: (context, store) {
          return Drawer(
            //侧边栏按钮
            child: Container(
              color: Theme.of(context).primaryColor,
              child: SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  ),
                  child: Material(
                    color: Colors.white,
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: ScreenUtil().setHeight(380),
                          child: UserAccountsDrawerHeader(
                            accountName: Container(
                              child: Text(
                                store.state.userInfo!.userName ?? '',
                                style: WMConstant.lagerTextWhite,
                              ),
                            ),
                            accountEmail: Text(
                              '',
                              style: WMConstant.middleTextWhite,
                            ),
                            currentAccountPicture: GestureDetector(
                              onTap: () {
                                //跳转到我的页面
//                                NavigatorUtils.goMyPage(context);
                              },
                              child: CircleAvatar(
                                // backgroundImage: store.state.userInfo.image == null ? AssetImage('images/logo.png') : FileImage(File(store.state.userInfo.image)),
                                backgroundImage: AssetImage('images/logo.png'),
                              ),
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            '设置参数',
                            style: WMConstant.normalText,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            // (: '暂未开通');
                            NavigatorUtils.goParamSetting(context);
                          },
                        ),
                        ListTile(
                          title: Text(
                            '修改密码',
                            style: WMConstant.normalText,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            // Fluttertoast.showToast(msg: '暂未开通');
                            NavigatorUtils.goUpdatePwd(context);
                          },
                        ),
                        ListTile(
                          title: Text(
                            '切换主题',
                            style: WMConstant.normalText,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            showThemeDialog(context, store);
                          },
                        ),
                        ListTile(
                          title: Text(
                            '纸张矫正',
                            style: WMConstant.normalText,
                          ),
                          onTap: () {
                            FlutterPlugins.walk().then((value) => {});
                            Navigator.pop(context);
                            // Fluttertoast.showToast(msg: '暂未开通');
                            // NavigatorUtils.goParamSetting(context);
                          },
                        ),
                        ListTile(
                          title: Text(
                            '问题反馈',
                            style: WMConstant.normalText,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Fluttertoast.showToast(msg: '暂未开通');
                            // NavigatorUtils.goQuestionSubmission(context);
                          },
                        ),
                        ListTile(
                          title: Text(
                            '检测更新',
                            style: WMConstant.normalText,
                          ),
                          onTap: () {
                            Navigator.pop(context);
                            Fluttertoast.showToast(msg: '暂未开通');
                            // NavigatorUtils.goVersionUpdate(context);
                          },
                        ),
                        ListTile(
                          title: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.only(
                                    left: 20.0,
                                    top: 10.0,
                                    right: 20.0,
                                    bottom: 10.0),
                                backgroundColor: Colors.redAccent,

                                textStyle: TextStyle(
                                  color: Color(WMColors.textWhite),
                                  // backgroundColor: Colors.redAccent,
                                )),
                            child: Flex(
                              mainAxisAlignment: MainAxisAlignment.center,
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Text(
                                  '退出登录',
                                  style: TextStyle(fontSize: 20.0),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            onPressed: () {
                              // DataDao.getOutLogin().then((res) {
                              //   if (res != null && res.result) {
                              //     var data = res.data['data'];
                              //     if (data != null) {
                              //       UserDao.clearAll(store);
                              NavigatorUtils.exitToLogin(context);
                              //     }
                              //   }
                              // });

                              // BaseDbManager.close();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
