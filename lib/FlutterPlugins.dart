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

  static Future<void> update(String result) async{
    await channel.invokeMethod('update',result);
  }

  static Future<String> getVersion(String result) async{
    return await channel.invokeMethod('version',result);
  }




}