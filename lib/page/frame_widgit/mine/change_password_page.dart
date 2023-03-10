import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../common/config/config.dart';
import '../../../common/dao/user_dao.dart';
import '../../../common/local/local_storage.dart';
import '../../../common/utils/barcolor_util.dart';
import 'package:fluttertoast/fluttertoast.dart';

var mYcontext;

/**
 * 修改密码
 */
class ChangePasswordPage extends StatefulWidget {
  static final String sName = Config.Change_password;

  ChangePasswordPage() : super();

  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController oldPwController = TextEditingController();
  final TextEditingController newPwController = TextEditingController();
  FocusNode oldPasswordFocusNode = FocusNode();
  FocusNode newPasswordFocusNode = FocusNode();

  var _oldPassword = '';
  var _newPassword = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(BarColor.light);
    initParams();
  }

  initParams() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    mYcontext = context;
    return Scaffold(
      body: getRootView(),
    );
  }

  Widget getRootView() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: new BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          _toolBar(),
          //标题下面滑动视图
          Expanded(
              child: MediaQuery.removePadding(
                  //由于直接使用listview会在顶部留下空白区域，所以使用MediaQuery.removePadding去除空白
                  context: mYcontext,
                  removeTop: true, //去除顶部的空白
                  child: ListView(
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(22, 50, 22, 0),
                        child: TextField(
                          focusNode: oldPasswordFocusNode,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: '请输入旧密码',
                            // icon: Icon(Icons.lock),
                          ),
                          onChanged: (String value) {
                            _oldPassword = value;
                          },
                          controller: oldPwController,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(22, 10, 22, 0),
                        child: TextField(
                          focusNode: newPasswordFocusNode,
                          style: TextStyle(fontSize: 16),
                          decoration: InputDecoration(
                            hintText: '请输入新密码',
                            // icon: Icon(Icons.lock),
                          ),
                          onChanged: (String value) {
                            _newPassword = value;
                          },
                          controller: newPwController,
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.fromLTRB(20, 40, 20, 0),
                        child:  MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4)),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(10),
                            color: Theme.of(context).primaryColor,
                            child: Flex(
                              mainAxisAlignment: MainAxisAlignment.center,
                              direction: Axis.horizontal,
                              children: <Widget>[
                                Text(
                                  '修改',
                                  style: TextStyle(fontSize: 18),
                                  maxLines: 1,
                                ),
                              ],
                            ),
                            onPressed: () {
                              oldPasswordFocusNode.unfocus();
                              newPasswordFocusNode.unfocus();
                              secretModify(_oldPassword,_newPassword);
                            }),
                      )

                    ],
                  )))
        ],
      ),
    );
  }

  Widget _toolBar() {
    return Container(
      //背景色，注意不能和decoration的color同时使用
      color: Colors.black,
      child: Column(
        children: [
          Padding(padding: EdgeInsets.fromLTRB(0, 22, 0, 0)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(mYcontext);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerLeft),
              ),
              Text(
                '修改密码',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Expanded(
                child: Text(''),
                flex: 1,
              ),
            ],
          )
        ],
      ),
    );
  }

  /**
   * 通用item
   */
  Widget initItem(String title, String content) {
    Widget item = Padding(
      padding: EdgeInsets.all(8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.all(5)),
          Expanded(
              flex: 2,
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              )),
          Expanded(
              flex: 3,
              child: Text(
                content,
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.normal),
              )),
        ],
      ),
    );
    return item;
  }

  /**
   * 修改密码
   */
  Widget initButton(String title) {
    Widget item = TextButton(
      style: ButtonStyle(
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize: MaterialStateProperty.all(Size(0, 0)),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.all(5)),
            Expanded(
                child: Text(
              title,
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            )),
            Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ],
        ),
      ),
      onPressed: () {
        //NavigatorUtils.goMainTabMore(mYcontext);
        Fluttertoast.showToast(msg: '暂未开通');
      },
    );
    return item;
  }


  //添加应用
  secretModify(oldSecret,newSecret) {
    UserDao.secretModify(oldSecret,newSecret).then((res) {
      if (res != null && res.result) {
        Fluttertoast.showToast(msg: '密码修改成功');
        Navigator.pop(context);
      }
    });
  }
}
