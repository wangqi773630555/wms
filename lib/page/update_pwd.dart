import 'package:flutter/material.dart';
import 'package:wanma_print/common/config/config.dart';
import 'package:wanma_print/common/local/local_storage.dart';
import '../common/dao/data_dao.dart';
import '../common/utils/common_utils.dart';
import '../common/utils/navigator_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UpdatePwd extends StatefulWidget {
  // final userId;

  // UpdatePwd({Key? key, @required this.userId}) : super(key: key);
  @override
  _UpdatePwdState createState() => _UpdatePwdState();
}

class _UpdatePwdState extends State<UpdatePwd> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _iphoneController = TextEditingController();
  final TextEditingController _oldPwdController = TextEditingController();
  final TextEditingController _newPwdController = TextEditingController();
  final TextEditingController _sureNewPwdController = TextEditingController();

  var _userId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getInit();
  }

  getInit() async {
    //
    _userId = await LocalStorage.get(Config.USER_ID);
    var name = await LocalStorage.get(Config.USER_NAME_KEY);
    _nameController.text = name;
  }

  @override
  Widget build(BuildContext context) {
    print('+++${MediaQuery.of(context).size.width}}');
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '修改密码',
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - 20,
              padding:
                  EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 100),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/login_background.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                children: <Widget>[
                  _name(context, '请输入用户名', _nameController),
                  _iphone(context, '请输入手机号', _iphoneController),
                  Container(
                    height: 30,
                  ),
                  _oldPwd(context, _oldPwdController),
                  _newPwd(context, _newPwdController),
                  _sureNewPwd(context, _sureNewPwdController),
                  _changeBtn()
                ],
              ),
            ),
          ),
        ));
  }

  Widget _name(context, hintText, controller) {
    return _nameExtFieldSet(context, '用户名:', hintText, controller);
  }

  Widget _iphone(context, hintText, controller) {
    return _nameExtFieldSet(context, '手机号:', hintText, controller);
  }

  Widget _oldPwd(context, controller) {
    return _commonTextFieldSet('请输入旧密码', controller);
  }

  Widget _newPwd(context, controller) {
    return _commonTextFieldSet('请输入新密码', controller);
  }

  Widget _sureNewPwd(context, controller) {
    return _commonTextFieldSet('请确认新密码', controller);
  }

  Widget _commonTextFieldSet(context, TextEditingController editingController) {
    return Container(
      height: 50,
      margin: EdgeInsets.only(top: 10),
      child: TextField(
        decoration: InputDecoration(
          icon: Icon(Icons.lock),
          labelText: context,
          labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pink),
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        obscureText: true,
        controller: editingController,
        onChanged: (String values) {},
      ),
    );
  }

  Widget _nameExtFieldSet(
      context, name, inhintText, TextEditingController editingController) {
    return Container(
        padding: EdgeInsets.only(
          top: 10,
        ),
        // width: ,

        child: Row(
          children: [
            Text(
              name,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 105,
              // margin: EdgeInsets.all(0),
              padding: EdgeInsets.only(left: 20),
              child: TextField(
                decoration: InputDecoration(
                  labelText: inhintText,
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.pink),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                // obscureText: true,
                controller: editingController,
                onChanged: (String values) {},
              ),
            )
          ],
        ));
  }

  bool chinaPhoneNumber(String input) {
    if (input.isEmpty) return false;

    String regexPhoneNumber =
        "^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$";

    return RegExp(regexPhoneNumber).hasMatch(input);
  }

  Widget _changeBtn() {
    return InkWell(
      onTap: () {
        if (!chinaPhoneNumber(_iphoneController.value.text)) {
          alertMessage('手机号输入有误');

          return;
        }
        if (_userId != null) {
          if (_oldPwdController.text != '' &&
              _newPwdController.text != '' &&
              _sureNewPwdController.text != '' &&
              _nameController.text != '' &&
              _iphoneController.text != '') {
            DataDao.updatePwd(
                    _oldPwdController.text,
                    _newPwdController.text,
                    _sureNewPwdController.text,
                    _nameController.text,
                    _userId,
                    _iphoneController.text)
                .then((res) {
              Navigator.pop(context);
              if (res != null && res.result) {
                // Future.delayed(const Duration(seconds: 1), () {
                print('==============');
                NavigatorUtils.goLogin(context);
                return true;
                // });
              }
            });
          } else {
            alertMessage('所有项目必填');
          }
        } else {
          alertMessage('id为空');
        }
        // DataDao.updatePwd(_reportId).then((res) {
        //   if (res != null && res.result) {
        //     CommonUtils.showTipDialog(context, '确认提交成功！', cancel: false,
        //         callback: () {
        //       _getReportDetail();
        //     });
        //   }
        // });
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.only(top: 35),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          //
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          '确认修改',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  alertMessage(String msg) async {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black45,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
