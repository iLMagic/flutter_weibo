import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter/material.dart';
import 'request/request_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    print('build');

    return WebviewScaffold(
      url:
          'https://api.weibo.com/oauth2/authorize?client_id=3154346189&redirect_uri=http://www.baidu.com',
      appBar: AppBar(
        title: Text("登录"),
      ),
      withZoom: true,
      hidden: true,
      withLocalStorage: true,
      // initialChild: Center(),
    );
  }

  @override
  void initState() {
    super.initState();
    print('initState');
    FlutterWebviewPlugin plugin = FlutterWebviewPlugin();
    plugin.onUrlChanged.listen((String url) {
      // print(url);
      // 解析code，缓存到本地
      // 遍历url 取出？后面的字符串
      int start = url.indexOf('?code=');
      if (start != -1) {
        if (flag) return;
        flag = true;
        String code = url.substring(start + 1 + 5);
        print(code);
        RequestClient.shareInstance().post(
          'oauth2/access_token',
          params: {
            'client_id': '3154346189',
            'client_secret': 'cd7c3c63cb8ff3b03c4a7c18e1604db6',
            'redirect_uri': 'http://www.baidu.com',
            'grant_type': 'authorization_code',
            'code': code,
          },
        ).then((onValue) {
          saveData(onValue.data['access_token']);
        });
      }
    });

    plugin.onHttpError.listen((WebViewHttpError e) {
      print('error:${e.code}, ${e.url}');
    });

    plugin.onStateChanged.listen(
      (WebViewStateChanged s) {
        print('onStateChanged:${s.type}, ${s.url}, ${s.navigationType}');
      },
      cancelOnError: true,
    );
  }

  // 缓存数据
  Future saveData(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('prefs:$prefs');
    await prefs.setString('token', token);
  }
  
  bool flag = false;
}
