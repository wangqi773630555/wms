import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wanma_print/common/config/config.dart';
import 'package:wanma_print/common/dao/user_dao.dart';
import 'package:wanma_print/common/local/local_storage.dart';
import 'package:wanma_print/common/redux/wm_state.dart';
import 'package:wanma_print/common/utils/common_utils.dart';
import 'package:wanma_print/common/utils/navigator_utils.dart';

class LoginPage extends StatefulWidget {
  static final String sName = Config.LOGIN;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _userName = '';
  var _password = '';
  var appType = '';

  final TextEditingController userController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  _LoginPageState() : super();

  @override
  void initState() {
    super.initState();
    initParams();
  }

  initParams() async {
    _userName = await LocalStorage.get(Config.USER_NAME_KEY) ?? '';
    _password = await LocalStorage.get(Config.PW_KEY) ?? '';

    // _userName = '13336022213';
    // _password = 'xxw123456';

    userController.value = TextEditingValue(text: _userName);
    pwController.value = TextEditingValue(text: _password);
  }

  @override
  Widget build(BuildContext context) {
    FocusNode userNameFocusNode = FocusNode();
    FocusNode passwordFocusNode = FocusNode();
    final double w_width = MediaQuery.of(context).size.width;
    // ignore: non_constant_identifier_names
    final double h_height = MediaQuery.of(context).size.height;
    return StoreBuilder<WMState>(
      builder: (context, store) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Scaffold(
            body: Container(
//              color: Theme.of(context).primaryColor,
                height: h_height,
                width: w_width,
                padding: EdgeInsets.only(left: 50, right: 50, top: 50),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/login_background.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SafeArea(
                    child: SingleChildScrollView(
                  child: Container(
                    // padding: EdgeInsets.only(top: 150),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '欢 迎 使 用',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 46, 46, 46)),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Padding(padding: new EdgeInsets.all(5.0)),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '天 屹 数 据 缆 数 字 工 厂',
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                                color: Color.fromARGB(255, 46, 46, 46)),
                          ),
                        ),
                        Center(
                          child: Container(
                            child: Column(
                              children: [
                                Padding(padding: EdgeInsets.all(10.0)),
                                TextField(
                                  focusNode: userNameFocusNode,
                                  decoration: InputDecoration(
                                    hintText: '请输入用户名',
                                    // icon: Icon(Icons.account_circle),
                                  ),
                                  onChanged: (String value) {
                                    _userName = value;
                                  },
                                  controller: userController,
                                ),
                                Padding(padding: new EdgeInsets.all(5.0)),
                                TextField(
                                  focusNode: passwordFocusNode,
                                  decoration: InputDecoration(
                                    hintText: '请输入密码',
                                    // icon: Icon(Icons.lock),
                                  ),
                                  obscureText: true,
                                  onChanged: (String value) {
                                    _password = value;
                                  },
                                  controller: pwController,
                                ),
                                Padding(padding: new EdgeInsets.all(20.0)),
                                MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  padding: EdgeInsets.only(
                                      left: 20.0,
                                      top: 10.0,
                                      right: 20.0,
                                      bottom: 10.0),
                                  textColor: Colors.white,
                                  color: Theme.of(context).primaryColor,
                                  child: Flex(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    direction: Axis.horizontal,
                                    children: <Widget>[
                                      Text(
                                        '登录',
                                        style: TextStyle(fontSize: 20.0),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    userNameFocusNode.unfocus();
                                    passwordFocusNode.unfocus();
                                    CommonUtils.showLoadingDialog(context);
                                    // Future.delayed(const Duration(seconds: 1), () {
                                    //   NavigatorUtils.goHome(context);
                                    //   return true;
                                    // });
                                    if (_userName == null ||
                                        _userName.length == 0) {
                                      Fluttertoast.showToast(msg: '请输入用户名');
                                      return;
                                    }
                                    if (_password == null ||
                                        _password.length == 0) {
                                      Fluttertoast.showToast(msg: '请输入密码');
                                      return;
                                    }

                                    UserDao.login(_userName, _password, appType,
                                            store)
                                        .then((res) {
                                      Navigator.pop(context);
                                      if (res != null && res.result) {
                                        Future.delayed(
                                            const Duration(milliseconds: 500),
                                            () async {
                                          var data = res.data['data'];
                                          String ua = data['Authorization'];
                                          print('--------$ua');
                                          LocalStorage.save(Config.UA, ua);
                                          LocalStorage.save(
                                              Config.LOGIN_TITLE, '');
                                          LocalStorage.save(Config.USER_ID, '');

                                          UserDao.getSk().then((res) {
                                            if (res != null && res.result) {
                                              String data = res.data['data'];
                                              LocalStorage.save(
                                                  Config.SET_KEY, data);
                                             /* Fluttertoast.showToast(
                                                  msg: 'SK值设置成功');*/
                                              NavigatorUtils.goHome(context);
                                            }
                                          });
                                          return true;
                                        });
                                      }
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ))),
          ),
        );
      },
    );
  }
}
