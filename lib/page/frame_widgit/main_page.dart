import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wanma_print/page/frame_widgit/main_page_fragment/fragment_home_page.dart';
import 'package:wanma_print/page/frame_widgit/main_page_fragment/fragment_my_page.dart';
import 'package:wanma_print/page/frame_widgit/main_page_fragment/fragment_tag_page.dart';

import '../../common/config/config.dart';
import '../../common/net/LogUtil.dart';
import '../../common/utils/barcolor_util.dart';
import '../../main.dart';


class MainPage extends StatefulWidget {
  static final String sName = Config.My_Home_Page_New;
  MainPage() : super();
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>  with RouteAware{
  int _currentIndex = 0;
  List _pageList = [FragmentHomePage(),FragmentTagPage(),FragmentMyPage()];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: _pageList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            this._currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
          BottomNavigationBarItem(icon: Icon(Icons.category), label: "选项"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: "我的")
        ],
        selectedItemColor: Colors.black,
        selectedFontSize: 12,
        //fixedColor: Colors.deepPurple,//选项中项的颜色
        unselectedItemColor:Colors.grey ,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute);
  }

  @override
  void didPopNext() {
    LogUtil.d('onResume');
    SystemChrome.setSystemUIOverlayStyle(BarColor.dark);
    super.didPopNext();
  }
}
