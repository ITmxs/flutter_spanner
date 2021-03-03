import 'package:flutter/material.dart';

class CommonRouter{
  //路由跳转
  static push(context,{widget,Map param}){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>widget,settings:RouteSettings(arguments: param) ));
  }
  static pushReplacement(context,{widget,Map param}){
    Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>widget,settings:RouteSettings(arguments: param) ));
  }
  static getParam(context){
    return ModalRoute.of(context).settings.arguments;
  }
}