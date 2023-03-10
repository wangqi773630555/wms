import 'package:flutter/material.dart';

class FragmentTagPage extends StatefulWidget {
  FragmentTagPage() : super();

  _FragmentTagPageState createState() => _FragmentTagPageState();
}

class _FragmentTagPageState extends State<FragmentTagPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: new BoxDecoration(
        //color: Color.fromARGB(255, 226, 236, 252),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.all(15)),
          Text(
            '正在建设中...',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
