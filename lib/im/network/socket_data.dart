import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myimdemo/im/pb/msg.pb.dart';
import 'package:myimdemo/im/utils/tool.dart';


class SocketDataProvider with ChangeNotifier {
  // 信息列表
  List<MessageEntity> _msgList = <MessageEntity>[];

  List<MessageEntity> get msgList => this._msgList;

  //联系人列表
  List<FriendEntity> _friendsList = <FriendEntity>[];

  List<FriendEntity> get friendsList => this._friendsList;

  Map<dynamic, Msg> _sendMsgList = Map(); //发送的消息，接收到服务端确认后清除

  Map<dynamic, Msg> get sendMsgList => this._sendMsgList;

  //联系人列表
  List<FriendEntity> _allFriendsList = <FriendEntity>[];

  List<FriendEntity> get allFriendsList => this._allFriendsList;

  var loginUser = '';

  //add begin
  bool netWorkStatus = true; // 网络状态
  late Timer heartbeatCountDown; //成功收到心跳后重置
  late int heartbeatCountDownTimes; //心跳倒计时
  int reconnectTimes = 0; // 已重连次数
  int reconnectTimesLimit = 5; // 重连最大次数
  int reconnectWaitSecond = 5;
  final String host;

  /** 服务器ip */
  final int port;

  /** 服务器端口 */
  var _socket;
  final Connectivity _connectivity = Connectivity();
  String _connectionStatus = 'Unknown';
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  SocketDataProvider(this.host, this.port);

  var global_context; // 存储传入进来的context，provide的方法在调用时需要传
  /**
   * 初始化链接服务器
   */
  void init(context) async {
    try {
      print("socketDataProvider.init-------------------------------");
      global_context = context;
      await connect(0);
//      print('after await connect(0)');
      _connectivitySubscription = _connectivity
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        _connectionStatus = result.toString();
        print(
            '--------------------当前网络：$_connectionStatus------------------------');
        if (result != ConnectivityResult.mobile &&
            result != ConnectivityResult.wifi) {
          print('没有网络，停止定时器');
          netWorkStatus = false;
          if (heartbeatCountDown != null) {
            heartbeatCountDown.cancel();
          }
          connect(5);
        } else {
          netWorkStatus = true;
          reconnectTimes = 0;
        }
      });
    } on SocketException catch (e) {
      print("socketDataProvider.init链接socket出现异常，e=${e.toString()}");
    } catch (e) {
      print('socketDataProvider.init打印Exception:${e.toString()}');
    }
  }

  Future connect(int second) async {
    print("socketDataProvider.connect-------------------------------");
//    print('sleep: '+second.toString());
    sleep(Duration(seconds: second));
//    print('wake up after: '+second.toString());
    try {
      heartbeatCountDownTimes = 15;
      if (_socket != null) {
        _socket = null;
      }
      print('reconnectTimes:$reconnectTimes');
      await Socket.connect(host, port, timeout: Duration(seconds: 5)).then((
          Socket socket) {
        print('连接成功');
        _socket = socket;
        _socket.listen(decodeHandle,
            onError: errorHandler,
            onDone: doneHandler, //处理关闭事件
            cancelOnError: false);
        heartbeatSocket(); //确保connect结束后调用
      });
      netWorkStatus = true;
      reconnectTimes = 0;
    } on SocketException catch (e) {
      netWorkStatus = false;
      if (heartbeatCountDown != null) {
        heartbeatCountDown.cancel();
      }
      print('打印SocketException:${e.toString()}');
      if (reconnectTimes <= reconnectTimesLimit) {
        print('重连');
        connect(reconnectWaitSecond);
        reconnectTimes++;
      } else {
        _socket.close();
      }
    } catch (e) {
      print('打印Exception:${e.toString()}');
    }
  }

  /**
   * 发消息，指定消息号，pb对象能够为不传(例如发心跳包的时候)
   */
  void sendMsg(int msgType, int delayPeriod, Msg? pb) async {
    //序列化pb对象
    pb!.head.msgId = ToolUtils.getRandomString(8);
    Uint8List pbBody = Uint8List(10);
    if (pb != null) {
      pbBody = pb.writeToBuffer();
    }
    var msg = pbBody.buffer.asUint8List();
    //给服务器发消息
    try {
      if (msgType == 101) {
        await Future.delayed(
            Duration(seconds: delayPeriod), () => _socket.add(msg));
      } else if (msgType == 100 || msgType == 104 || msgType == 106 || msgType == 105
                || msgType == 108) {
        _socket.add(msg);
      } else if (pb != null && msgType == 102) {
        sendMsgList.putIfAbsent(pb.head.msgId, () => pb);
        print('sendMsgList.putIfAbsent:${pb}');
        _socket.add(msg);
      }
      print("给服务端发送消息，消息号=$msgType");
    } catch (e) {
      print("send捕获异常：msgCode=${msgType}，e=${e.toString()}");
      if (heartbeatCountDown != null) {
        heartbeatCountDown.cancel();
      }
    }
  }

  /**
   * 解析返回消息
   */
  void decodeHandle(newData) {
    print("socketDataProvider.decodeHandle-------------------------------");
    Msg msg = Msg.fromBuffer(newData);
    var head = msg.head;
    print(msg);
    int receiveType = msg.head.msgType;
    //收到心跳后，重置心跳倒计时
    if (101 == receiveType) {
//      print('收到心跳:${msg}');
//      print('重置heartbeatCountDownTimes');
      heartbeatCountDownTimes = 15;
    } else if (100 == receiveType) { //登录成功，跳转ImScreen
      print('收到登录响应:${msg}');
      var loginResult = msg.body;
      Map<String, dynamic> userCode = jsonDecode(head.extend);
      if (loginResult == 'LOGIN TOKEN') {
        var userCoder = userCode['user_code'];
        loginUser = userCode['user_code'];
        print('socketDataProvider.loginUser = ${userCode}');
        //TODO 登录成功，1.删除等待框 2.跳转页面
        Navigator.of(global_context).pushNamed('friends');
      } else { //登录失败
        EasyLoading.instance
          ..dismissOnTap = true;
//            ..errorWidget = Text('登录失败');
        EasyLoading.showError('登录失败');
      }
    } else if (102 == receiveType) {
      print('收到客户端消息:${msg}');
      insertMsgList(false, 102, msg.body);
    } else if (103 == receiveType) {
      print('收到服务端确认消息:${msg}');
      var msgId = msg.head.msgId;
      String content = msg.body;
      if ('SUCCESS' == content) {
        sendMsgList.remove(msgId);
      } else {
        print('发送消息失败');
      }
    } else if (104 == receiveType) {
      print('收到联系人列表:${msg}');
      Map<String, dynamic> friendsListMap = jsonDecode(msg.body);
      List<Map> list = friendsListMap['list'].cast<Map>();
      List<FriendEntity> friendsList = [];
      list.forEach((item) {
        friendsList.insert(0,
            FriendEntity(item['user_code'], item['user_name'], item['online']));
      });
      setFriendsList(friendsList); //更新联系人
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
    } else if (105 == receiveType) {
      print('收到服务端确认消息:${msg}');
//      var msgId = msg.head.msgId;
      String content = msg.body;
      if ('SUCCESS' == content) {
        Head hbhead = Head.create();
        hbhead.msgContentType = 1;
        hbhead.msgId = 'msgID';
        hbhead.msgType = 104;
        hbhead.statusReport = 0;
        hbhead.toId = 'server';
        Msg hbmsg = Msg.create();
        hbmsg.body = 'getFriendList';
        hbmsg.head = hbhead;
        sendMsg(104, 0, hbmsg);
      } else {
        print('添加联系人失败');
      }
    } else if (106 == receiveType) {
      print('收到所有用户:${msg}');
      Map<String, dynamic> allFriendsListMap = jsonDecode(msg.body);
      List<Map> list = allFriendsListMap['list'].cast<Map>();
      List<FriendEntity> friendsList = [];
      list.forEach((item) {
        friendsList.insert(0,
            FriendEntity(item['user_code'], item['user_name'], item['online']));
      });
      setAllFriendsList(friendsList); //更新联系人
    } else if (107 == receiveType) { //收到添加好友请求
      print('收到来自${head.fromId}的添加好友请求');
      _showDialog(head.fromId);//展示收到好友申请弹窗
    }else if(108 == receiveType){
      Head hbhead = Head.create();
      hbhead.msgContentType = 1;
      hbhead.msgId = 'msgID';
      hbhead.msgType = 104;
      hbhead.statusReport = 0;
      hbhead.toId = 'server';

      Msg hbmsg = Msg.create();
      hbmsg.body = 'getFriendList';
      hbmsg.head = hbhead;
      hbhead.fromId = loginUser;
      sendMsg(104, 0,hbmsg);
    }
  }

  void _showDialog(String whoAddMe) {
    showDialog(
      context:this.global_context,
      builder:(BuildContext context) {
        return AlertDialog(
          title: new Text("好友申请"),
          content: new Text("收到来自${whoAddMe}的添加好友请求"),
          actions: <Widget>[
            new TextButton(
              child: new Text("同意"),
              onPressed: () {//发送通意好友申请
                Head hbhead = Head.create();
                hbhead.msgContentType = 1;
                hbhead.msgId = 'msgID';
                hbhead.msgType = 108;
                hbhead.statusReport = 23232;
                hbhead.fromId = loginUser;
                hbhead.toId = 'server';
                Msg hbmsg = Msg.create();
                hbmsg.body = '{"user_code":"${whoAddMe}","add_friend":"${loginUser}"}';
                hbmsg.head = hbhead;
                sendMsg(108,0,hbmsg);
                Navigator.of(context, rootNavigator: true).pop();
              },
            ),
            new TextButton(
              child: new Text("拒绝"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }



  void errorHandler(error, StackTrace trace) async {
    print("errorHandler-------------------------------");
    netWorkStatus = false;
    if (heartbeatCountDown != null) {
      heartbeatCountDown.cancel();
    }
    print("捕获socket异常信息：error=$error，trace=${trace.toString()}");
    print(
        '--------------------当前网络：$_connectionStatus------------------------');
    print('尝试重连');
    connect(reconnectWaitSecond);
  }

  void doneHandler() {
    print("doneHandler");
  }

  // 心跳机，每15秒给后台发送一次，用来保持连接
  void heartbeatSocket() {
    print("heartbeatSocket-------------------------------");
    const periodDuration = Duration(seconds: 1);
    var callback = (time) async {
      // 如果socket状态是断开的，就停止定时器
      if (!netWorkStatus) {
        print('heartbeatCountDown.cancel()');
        if (heartbeatCountDown != null) {
          heartbeatCountDown.cancel();
        }
        //执行重连机制
        connect(reconnectWaitSecond);
      }
      print('heartbeatCountDownTimes:' + heartbeatCountDownTimes.toString());
      if (heartbeatCountDownTimes < 1) {
        print('-----------------发送心跳------------------');
        Head hbhead = Head.create();
        hbhead.msgContentType = 1;
        hbhead.msgId = 'msgID';
        hbhead.msgType = 101;
        hbhead.statusReport = 23232;
        hbhead.fromId = 'A';
        hbhead.toId = 'server';

        Msg hbmsg = Msg.create();
        hbmsg.body = 'heartbeat';
        hbmsg.head = hbhead;
        sendMsg(101, 0, hbmsg);
      } else {
        heartbeatCountDownTimes--;
      }
    };

    heartbeatCountDown = Timer.periodic(periodDuration, callback);
  }

  //add end


  insertMsgList(bool own, int msgType, String content) {
    _msgList.insert(0, MessageEntity(own, msgType, content));
    _msgList = [..._msgList];
    notifyListeners();
  }

  insertFriendsList(String userCode, String userName, bool online) {
    _friendsList.insert(0, FriendEntity(userCode, userName, online));
    _friendsList = [..._friendsList];
    notifyListeners();
  }

  void setFriendsList(List<FriendEntity> list) {
    this._friendsList = list;
    notifyListeners();
  }

  void setAllFriendsList(List<FriendEntity> list) {
    this._allFriendsList = [...list];
    notifyListeners();
  }

  @override
  void dispose() {
    // 释放资源
    super.dispose();
    heartbeatCountDown.cancel();
    _socket.close();
  }
}

/// 信息实体
class MessageEntity {
  bool own;
  int msgType;
  String content;

  MessageEntity(this.own, this.msgType, this.content);
}

class FriendEntity {
  String userCode;
  String userName;
  bool online;

  FriendEntity(this.userCode, this.userName, this.online);
}
