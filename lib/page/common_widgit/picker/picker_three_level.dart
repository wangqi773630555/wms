import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'picker_model.dart';

late List<PickerModel> provices;

class PickerThreeLevel extends StatefulWidget {

  final Function onSelect;
  final int initProviceIndex;
  final int initCityIndex;
  final int initCountyIndex;

  PickerThreeLevel(this.onSelect,this.initProviceIndex,this.initCityIndex, this.initCountyIndex, provicesData){
    provices = provicesData;
  }

  @override
  _PickerThreeLevelState createState() => _PickerThreeLevelState();
}

class _PickerThreeLevelState extends State<PickerThreeLevel> {

 /* List<AreaModel> provices = [
    AreaModel.fromMap({
      "id": 130000,
      "name": "河北省",
      "childs": [
        {
          "id": 130100,
          "name": "石家庄市",
          "childs": [
            {
              "id": 130102,
              "name": "长安区",
              "childs": null
            },
            {
              "id": 130104,
              "name": "桥西区",
              "childs": null
            },
            {
              "id": 130105,
              "name": "新华区",
              "childs": null
            },
            {
              "id": 130107,
              "name": "井陉矿区",
              "childs": null
            },
            {
              "id": 130108,
              "name": "裕华区",
              "childs": null
            },
            {
              "id": 130109,
              "name": "藁城区",
              "childs": null
            },
            {
              "id": 130110,
              "name": "鹿泉区",
              "childs": null
            },
            {
              "id": 130111,
              "name": "栾城区",
              "childs": null
            },
            {
              "id": 130121,
              "name": "井陉县",
              "childs": null
            },
            {
              "id": 130123,
              "name": "正定县",
              "childs": null
            },
            {
              "id": 130125,
              "name": "行唐县",
              "childs": null
            },
            {
              "id": 130126,
              "name": "灵寿县",
              "childs": null
            },
            {
              "id": 130127,
              "name": "高邑县",
              "childs": null
            },
            {
              "id": 130128,
              "name": "深泽县",
              "childs": null
            },
            {
              "id": 130129,
              "name": "赞皇县",
              "childs": null
            },
            {
              "id": 130130,
              "name": "无极县",
              "childs": null
            },
            {
              "id": 130131,
              "name": "平山县",
              "childs": null
            },
            {
              "id": 130132,
              "name": "元氏县",
              "childs": null
            },
            {
              "id": 130133,
              "name": "赵县",
              "childs": null
            },
            {
              "id": 130181,
              "name": "辛集市",
              "childs": null
            },
            {
              "id": 130183,
              "name": "晋州市",
              "childs": null
            },
            {
              "id": 130184,
              "name": "新乐市",
              "childs": null
            }
          ]
        }
      ]
    }),
  ];*/
  List<PickerModel> citys = [];
  List<PickerModel> county = [];

  ///选中的省份的index
  int selectedProvice = 0;
  ///选中的市的index
  int selectedCity = 0;
  ///选中的区的index
  int selectedCounty = 0;


  ///定义省份控制器
  late FixedExtentScrollController proviceCotroller;
  ///定义市控制器
  late FixedExtentScrollController cityController;
  ///定义区控制器
  late FixedExtentScrollController countyController;

  /// 选择变化时候的值
  late Map tempAreaInfo;

  @override
  void initState() {
    super.initState();
    selectedProvice = widget.initProviceIndex ?? 0;
    selectedCity = widget.initCityIndex ?? 0;
    selectedCounty = widget.initCountyIndex ?? 0;
    citys = provices[selectedProvice].children;
    county = citys[selectedCity].children;
    proviceCotroller = new FixedExtentScrollController(initialItem: widget.initProviceIndex ?? 0);
    cityController = new FixedExtentScrollController(initialItem: widget.initCityIndex ?? 0);
    countyController = new FixedExtentScrollController(initialItem: widget.initCountyIndex ?? 0);
    tempAreaInfo = {
      'proviceId': provices[selectedProvice].sync_id,
      'cityId': citys[selectedCity].sync_id,
      'countyId': county.isEmpty?"":county[selectedCounty].sync_id,
      'lk': county.isEmpty?"":county[selectedCounty].lk,
      'address': provices[selectedProvice].title +'>'+ citys[selectedCity].title +">"+ (county.isEmpty?"":county[selectedCounty].title),
      'proviceIndex': selectedProvice,
      'cityIndex': selectedCity,
      'countyIndex': selectedCounty
    };
  }

  ///给父组件传递结果
  void passParams(){
    setState(() {
      tempAreaInfo = {
        'proviceId': provices[selectedProvice].sync_id,
        'cityId': citys[selectedCity].sync_id,
        'countyId': county.isEmpty?"":county[selectedCounty].sync_id,
        'lk': county.isEmpty?"":county[selectedCounty].lk,
        'address': provices[selectedProvice].title +'>'+ citys[selectedCity].title +">"+ (county.isEmpty?"":county[selectedCounty].title),
        'proviceIndex': selectedProvice,
        'cityIndex': selectedCity,
        'countyIndex': selectedCounty
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                  child: Text('取消'),
                ),
                GestureDetector(
                  onTap: (){
                    widget.onSelect(tempAreaInfo);
                    Navigator.of(context).pop();
                  },
                  child: Text('确认', style: TextStyle(color: Colors.red),),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    diameterRatio: 1.1,
                    scrollController: proviceCotroller,
                    itemExtent: 40.0,
                    onSelectedItemChanged: (position){
                      setState(() {
                        selectedProvice = position;
                        citys = provices[selectedProvice].children;
                        selectedCity = 0;
                        county = citys[selectedCity].children;
                      });
                      cityController.jumpToItem(0);
                      countyController.jumpToItem(0);
                      passParams();
                    },
                    children: createEachItem(provices),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    scrollController: cityController,
                    itemExtent: 40.0,
                    onSelectedItemChanged: (position){
                      setState(() {
                        selectedCity = position;
                        selectedCounty = 0;
                        county = citys[selectedCity].children;
                      });
                      countyController.jumpToItem(0);
                      passParams();
                    },
                    children: createEachItem(citys),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CupertinoPicker(
                    backgroundColor: Colors.white,
                    scrollController: countyController,
                    itemExtent: 40.0,
                    onSelectedItemChanged: (position){
                      selectedCounty = position;
                      passParams();
                    },
                    children: createEachItem(county),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

List<Widget> createEachItem(List<PickerModel> data) {
  List<Widget> target = [];

  for (PickerModel item in data) {
    target.add(Container(
      padding: EdgeInsets.only(top: 12.0, bottom: 10.0),
      child: Text(
        item.title ?? '',
        style: TextStyle(fontSize: 14.0),
      ),
    ));
  }

  return target;
}
