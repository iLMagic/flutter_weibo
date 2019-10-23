// import 'dart:html';
// import 'dart:html';
// import 'dart:ffi';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weibo/common/emotions.dart';
import 'package:flutter_weibo/entity/emotion_entity.dart';
import 'dart:async';
// import 'dart:convert';
// import 'package:dio/dio.dart';
import 'package:flutter_weibo/entity/home_entity.dart';
import 'package:flutter_weibo/entity/status_entity.dart';
import 'package:flutter_weibo/request/request_client.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cached_network_image/cached_network_image.dart';

// import 'package:flutter_weibo/entity/home_entity.dart';
// import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeEntity _model;
  // int _currentPage = 1;
  // int _pageSize = 20;
  // int maxId = 0;

  ResponseStatus _status = ResponseStatus.loading;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    // _refreshController.initialRefresh = true;

    // 获取数据
    _getData(0).then((onVaule) {
      print(onVaule);
      setState(() {
        _model = onVaule;
        if (_model.statuses.isEmpty) {
          _status = ResponseStatus.emptyData;
        } else {
          _status = ResponseStatus.success;
        }
      });
    }).catchError((onError) {
      print(onError);
      setState(() {
        _status = ResponseStatus.error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('关注'),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoadMoreData,
        header: WaterDropHeader(),
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus mode) {
            Widget body;
            if (mode == LoadStatus.idle) {
              body = Text("pull up load");
            } else if (mode == LoadStatus.loading) {
              body = CupertinoActivityIndicator();
            } else if (mode == LoadStatus.failed) {
              body = Text("Load Failed!Click retry!");
            } else if (mode == LoadStatus.canLoading) {
              body = Text("release to load more");
            } else {
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child: body),
            );
          },
        ),
        child: _status != ResponseStatus.success
            ? ResponseStatusPage(_status, '请求发生未知错误')
            : // : Container(
            //     color: Colors.transparent,
            ListView.separated(
                itemCount: _model.statuses.length,
                itemBuilder: (BuildContext context, int index) {
                  return StatusCell(_model.statuses[index]);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Color(0xffeeeeee),
                    padding: EdgeInsets.only(top: 10),
                  );
                },
              ),
        // ),
      ),
    );
  }

  void _onRefresh() async {
    print('onRefresh');
    HomeEntity entity = await _getData(0);
    setState(() {
      _model = entity;
    });
    _refreshController.refreshCompleted();
  }

  void _onLoadMoreData() async {
    print('loadMoreData');
    int maxId = _model.statuses.last.id;
    HomeEntity entity = await _getData(maxId);
    setState(() {
      _model.statuses.addAll(entity.statuses);
    });
    _refreshController.loadComplete();
  }

  // 获取数据
  Future<HomeEntity> _getData(int maxId) async {
    Response resp = await RequestClient.shareInstance().get(
      '2/statuses/home_timeline.json',
      params: {
        'max_id': maxId,
      },
      // config: RequestConfig(debugConsole: false),
    );
    HomeEntity entity = HomeEntity.fromJson(resp.data);
    return entity;
  }
}

class StatusCell extends StatelessWidget {
  final StatusEntity _model;
  final int _maxColumn = 3;
  final double _margin = 12;

  StatusCell(this._model);

  @override
  Widget build(BuildContext context) {
    // 获取当前屏幕的宽度

    double picPadding = 5;
    double screenSize = MediaQuery.of(context).size.width;
    double picItemWH =
        (screenSize - _margin * 2 - picPadding * (_maxColumn - 1)) / _maxColumn;
    // double wqe = 11;

    double t = _model.pic_urls.length / 3;
    int rows = t.toInt() + ((_model.pic_urls.length % _maxColumn) == 0 ? 0 : 1);
    //  + (_model.pic_urls.length % _maxColumn) == 0
    //         ? 0
    //         : 1;
    // int rows =
    // (_model.pic_urls.length / 3).toInt();
    //  + (_model.pic_urls.length % _maxColumn) == 0
    // ? 0
    // : 1;
    double girdHeight =
        rows * picItemWH + _margin * 2 + (rows - 1) * picPadding;

    if (_model.pic_urls.length > 8) {
      print('');
    }

    // List<Widget> photoWidgets = _model.pic_urls.map((Map map) {
    //   String thumb = map['thumbnail_pic'];
    //   String bmiddle = thumb.replaceAll('thumbnail', 'bmiddle');
    //   return Image.network(
    //     bmiddle,
    //     fit: BoxFit.cover,
    //   );
    // }).toList();

    // print(_model.user.profile_image_url);
    return Container(
      child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 12)),
          Container(
            height: 47,
            // color: Colors.purple,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 12),
                ),
                Container(
                  width: 47,
                  child: CachedNetworkImage(
                    imageUrl: _model.user.profile_image_url,
                    imageBuilder:
                        (BuildContext context, ImageProvider imageProvider) {
                      // return CustomCircleAvatar(imageProvider);
                      return Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // color: Colors.red,
                            border: Border.all(color: Colors.red),
                            image: DecorationImage(
                              image: imageProvider,
                            )),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          Container(
            padding: EdgeInsets.only(left: 12, right: 12),
            child: StatusRichText(_model.text),
          ),
          Padding(padding: EdgeInsets.only(top: 10)),
          // 图片
          Offstage(
            offstage: _model.pic_urls.isEmpty,
            child: Container(
              // color: Colors.yellowAccent,
              height: girdHeight,
              padding: EdgeInsets.all(_margin),
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: _model.pic_urls.length,
                itemBuilder: (BuildContext context, int index) {
                  String thumb = _model.pic_urls[index]['thumbnail_pic'];
                  String bmiddle = thumb.replaceAll('thumbnail', 'bmiddle');
                  return Image.network(
                    bmiddle,
                    fit: BoxFit.cover,
                  );
                },
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _maxColumn,
                  crossAxisSpacing: picPadding,
                  mainAxisSpacing: picPadding,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

/// 富文本展示Widget
class StatusRichText extends StatelessWidget {
  final String text;
  // final List items = List();

  StatusRichText(this.text);

  @override
  Widget build(BuildContext context) {
    // 解析text
    List items = List();
    String temp = '';
    for (var i = 0; i < text.length; i++) {
      String ele = text[i];
      if (ele == '[') {
        if (temp.isNotEmpty) {
          items.add(temp);
          temp = '';
        }
        temp += ele;
      } else if (ele == ']') {
        if (temp.isNotEmpty) {
          temp += ele;
          // item.add(temp);
          EmotionEntity emotion;
          List<EmotionEntity> ems = Emotions.shareInstance().emotions;
          for (var i = 0; i < ems.length; i++) {
            EmotionEntity ele = ems[i];
            if (ele.phrase == temp) {
              emotion = ele;
              break;
            }
          }
          if (emotion == null) {
            // temp += ele;
          } else {
            items.add(emotion);
            temp = '';
          }
        } else {
          temp = ele;
        }
      } else {
        temp += ele;
      }
    }
    if (temp.isNotEmpty) {
      items.add(temp);
    }

    List<InlineSpan> spans = List();
    items.forEach((e) {
      if (e is String) {
        spans.add(TextSpan(
          text: e,
          style: TextStyle(
            fontSize: 17,
            color: Color(0xFF333333),
          ),
        ));
      } else if (e is EmotionEntity) {
        spans.add(WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          style: TextStyle(
            fontSize: 17,
          ),
          child: Image.network(
            e.url,
            width: 20,
            height: 18,
          ),
        ));
      } else {}
    });

    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }
}

/// 定义响应状态
enum ResponseStatus {
  loading,
  emptyData,
  error,
  success,
}

class ResponseStatusPage extends StatelessWidget {
  final String message;
  final ResponseStatus status;

  /// init
  ResponseStatusPage(this.status, this.message);

  @override
  Widget build(BuildContext context) {
    List<Widget> ws;

    if (this.status == ResponseStatus.loading) {
      ws = [
        CircularProgressIndicator(),
        Padding(
          padding: EdgeInsets.only(top: 15),
        ),
        Text('正在加载...'),
      ];
    } else if (this.status == ResponseStatus.error) {
      ws = [
        Text(
          message,
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF333333),
          ),
        ),
      ];
    } else if (this.status == ResponseStatus.emptyData) {
      ws = [
        Text(
          '数据为空',
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFF333333),
          ),
        ),
      ];
    } else {
      throw ErrorDescription('参数错误');
    }

    return Center(
      child: Container(
        // color: Colors.red,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: ws,
        ),
      ),
    );
  }
}

// class CirclePicturer extends CustomPaint {
//   void clip() {}
// }

class CustomCircleAvatar extends StatefulWidget {
  final ImageProvider imageProvider;

  CustomCircleAvatar(this.imageProvider);

  @override
  _CustomCircleAvatarState createState() => _CustomCircleAvatarState();
}

class _CustomCircleAvatarState extends State<CustomCircleAvatar> {
  ui.Image _uiimage;

  @override
  Widget build(BuildContext context) {
    // 图片转换
    _loadImge(widget.imageProvider).then((ui.Image uiimage) {
      if (mounted) {
        setState(() {
          _uiimage = uiimage;
        });
      }
    });

    return CustomPaint(
      size: Size(47, 47),
      painter: CircleAvatarPainter(_uiimage),
    );
  }

  /// 图片转换Imageprovider -> ui.image
  Future<ui.Image> _loadImge(ImageProvider imageProvider) async {
    ImageStream imageStream = imageProvider.resolve(ImageConfiguration());
    Completer<ui.Image> completer = Completer<ui.Image>();
    void imageListener(ImageInfo info, bool synchronousCall) {
      ui.Image image = info.image;
      completer.complete(image);
      imageStream.removeListener(ImageStreamListener(imageListener));
    }

    imageStream.addListener(ImageStreamListener(imageListener));
    return completer.future;
  }
}

class CircleAvatarPainter extends CustomPainter {
  final ui.Image image;
  CircleAvatarPainter(this.image);
  @override
  void paint(Canvas canvas, Size size) {
    // 先画图片
    if (image != null) {
      Paint imageP = Paint();
      // canvas.drawImage(image, Offset(0, 0), imageP);
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, size.width, size.height),
        Rect.fromLTWH(0, 0, size.width, size.height),
        imageP,
      );
    }

    // 画圆环
    Paint circleP = Paint()
      ..color = Colors.red
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(
        Offset(size.width * 0.5, size.width * 0.5), size.width * 0.5, circleP);

    // 剪切
    // Path()
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
