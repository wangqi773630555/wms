abstract class JsonString {
  static final String loginResponse = '''
  {
  "msg": "验证通过.",
  "code": 200,
  "data": {
    "userInfo": {
      "avatarId": 1646038290446002,
      "user_name": "肖学卫",
      "dept_name": "浙江万马高分子材料集团有限公司",
      "position_title": "设备管理员",
      "id": 1645682184579005,
      "title": "wm_13336022213",
      "org_name": "浙江万马高分子材料集团有限公司"
    },
    "_U_": "wm_13336022213",
    "_UA_": "149E786C859E3B50A43BCABAA3C570542D2933B347CCBB7558B97B1B129AE62E39CA5DED39D0FF626E39970BFD1FD2DD34C4D82BD69D65AC29CD9973E88CF8B3"
  },
  "time": 84,
  "token": "8bd00d0dd9d7420492f1fcfd1c4b24fe"
}
  ''';

  static final String homeData = '''
  {
    "result": [
        {
            "title": "收货单管理",
            "functionName": "materialReceipt",
            "id": 1,
            "icon": "Icons.qr_code"
        },
        {
            "title": "扫码收货",
            "functionName": "materialDetail",
            "id": 1,
            "icon": "Icons.qr_code"
        },
        {
            "title": "自助打印",
            "functionName": "materialPrint",
            "id": 1,
            "icon": "Icons.qr_code"
        }
       
    ],
    "msg": "成功",
    "code": 0
}
  ''';
}
