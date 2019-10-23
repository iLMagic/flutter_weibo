/**
 * 打开模拟器
 * xcrun instruments -w "iPhone 8 Plus (13.0)" 
 */

import 'package:flutter/material.dart';
// import 'request/request_client.dart';
import 'login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/home_page.dart';
import 'common/emotions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isShowLogin = false;

  @override
  void initState() {
    super.initState();
    // 系统默认表情初始化
    Emotions.shareInstance();
    // 打印测试
    // DHJsonPrint.printTest();
  }

  @override
  Widget build(BuildContext context) {
    showLogin();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          Offstage(
            offstage: isShowLogin,
            child: IconButton(
              icon: Icon(Icons.next_week),
              onPressed: () {
                // 跳转网页
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Login();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: RaisedButton(
          child: Text('首页'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (BuildContext context) {
                return HomePage();
              }),
            );
          },
        ),
      ),
    );
  }

  Future showLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var string = prefs.getString('token');
    print('token=$string');
    if (string == null) {
      isShowLogin = true;
    } else {
      isShowLogin = false;
    }
  }
}
