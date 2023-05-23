import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'picker_model.dart';

late List<PickerModel> provices;

class PickerSecondLevel extends StatefulWidget {
  final Function onSelect;
  final int initProviceIndex;
  final int initCityIndex;

  PickerSecondLevel(this.onSelect, this.initProviceIndex, this.initCityIndex,provicesData){
    provices = provicesData;
  }


  @override
  _PickerSecondLevelState createState() => _PickerSecondLevelState();
}

class _PickerSecondLevelState extends State<PickerSecondLevel> {
  List<PickerModel> citys = [];

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

  /// 选择变化时候的值
  late Map tempAreaInfo;

  @override
  void initState() {
    super.initState();
    selectedProvice = widget.initProviceIndex ?? 0;
    selectedCity = widget.initCityIndex ?? 0;
    citys = provices[selectedProvice].children;
    proviceCotroller = new FixedExtentScrollController(
        initialItem: widget.initProviceIndex ?? 0);
    cityController =
        new FixedExtentScrollController(initialItem: widget.initCityIndex ?? 0);
    tempAreaInfo = {
      'proviceId': provices[selectedProvice].sync_id,
      'cityId': citys[selectedCity].sync_id,
      'address': provices[selectedProvice].title +'>'+ citys[selectedCity].title,
      'proviceIndex': selectedProvice,
      'cityIndex': selectedCity,
    };
  }

  ///给父组件传递结果
  void passParams() {
    setState(() {
      tempAreaInfo = {
        'proviceId': provices[selectedProvice].sync_id,
        'cityId': citys[selectedCity].sync_id,
        'address': provices[selectedProvice].title +'>'+ citys[selectedCity].title,
        'proviceIndex': selectedProvice,
        'cityIndex': selectedCity,
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
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('取消'),
                ),
                GestureDetector(
                  onTap: () {
                    widget.onSelect(tempAreaInfo);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '确认',
                    style: TextStyle(color: Colors.red),
                  ),
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
                    onSelectedItemChanged: (position) {
                      setState(() {
                        selectedProvice = position;
                        citys = provices[selectedProvice].children;
                        selectedCity = 0;
                      });
                      cityController.jumpToItem(0);
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
                    onSelectedItemChanged: (position) {
                      setState(() {
                        selectedCity = position;
                        selectedCounty = 0;
                      });
                      passParams();
                    },
                    children: createEachItem(citys),
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
