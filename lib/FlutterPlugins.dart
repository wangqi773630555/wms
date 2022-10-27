import 'package:flutter/services.dart';

class FlutterPlugins{

  static const MethodChannel channel = const MethodChannel("hyflapp");

  static Future<void> senData(String result) async{
    await channel.invokeMethod('sendData',result);
  }

  static Future<void> print(String result) async{
    await channel.invokeMethod('print',result);
  }

  static Future<void> walk() async{
    await channel.invokeMethod('walk');
  }


}