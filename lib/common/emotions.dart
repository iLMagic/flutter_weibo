import 'package:dio/dio.dart';
import 'package:flutter_weibo/entity/emotion_entity.dart';
import 'package:flutter_weibo/request/request_client.dart';
import 'package:sqflite/sqflite.dart';

/// 单例对象，管理emotions表情
/// 目前只先请求一次，后续不再更新
class Emotions {
  List<EmotionEntity> emotions;

  static Emotions _instance;

  /// 外部唯一初始化方法
  factory Emotions.shareInstance() {
    if (_instance == null) {
      _instance = Emotions._();
    }
    return _instance;
  }

  // 私有化构造函数
  Emotions._() {
    // _emotions = [''];
    getEmotionsData().then((onValue) {
      // print(onValue);
      emotions = onValue;
    }).catchError((onError) {
      print(onError);
    });
  }
  
  Future<List<EmotionEntity>> getEmotionsData() async {
    // 获取路径
    String dbPath = await getDatabasesPath();
    String path = dbPath + '/emotions.db';
    // 判断改地址是否已经存在
    // bool isExist = await databaseExists(path);
    print(path);
    // 加载db,创建emotions表
    Database db =
        await openDatabase(path, version:1, onCreate: (Database db, int version) async {
      await db.execute(
          'create table if not exists emotions (id integer primary key, phrase text, url text)');
    });
    List<Map> ems = await db.rawQuery('SELECT * FROM emotions');

    // print(ems);

    // 创建一个空数组
    List<EmotionEntity> models = List();

    if (ems.isNotEmpty) {
      // 转模型
      ems.forEach((map) {
        EmotionEntity entity = EmotionEntity.fromJson(map);
        models.add(entity);
      });
    } else {
      Response resp = await RequestClient.shareInstance().get(
        '2/emotions.json',
        config: RequestConfig(debugConsole: false),
      );
      List datas = resp.data;
      for (var i = 0; i < datas.length; i++) {
        dynamic map = datas[i];
        EmotionEntity entity = EmotionEntity.fromJson(map);
        models.add(entity);
        // 存储数据
        await db.execute('insert into emotions(id, phrase, url) values($i, \'${entity.phrase}\', \'${entity.url}\')');
        // return models;
      }
      
    }
    await db.close();
    return models;
  }
}
