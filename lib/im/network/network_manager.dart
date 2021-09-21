import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';
import 'package:myimdemo/im/pb/msg.pb.dart';
import 'package:myimdemo/im/utils/tool.dart';
import 'package:protobuf/protobuf.dart';
import 'package:provider/provider.dart';

import 'socket_data.dart';

class NetworkManager{
  bool netWorkStatus = true;     // 网络状态
  late Timer heartbeatCountDown;  //成功收到心跳后重置
  late int heartbeatCountDownTimes;//心跳倒计时
  int reconnectTimes = 0;        // 已重连次数
  int reconnectTimesLimit = 5;        // 重连最大次数
  int reconnectWaitSecond = 5;
  final String host;/** 服务器ip */
  final int port;/** 服务器端口 */
  var _socket;
  final Connectivity _connectivity = Connectivity();
  String _connectionStatus = 'Unknown';
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  NetworkManager(this.host,this.port);
  var global_context;// 存储传入进来的context，provide的方法在调用时需要传

  /**
   * 初始化链接服务器
   */
  void init(context) async{
    try {
      print("init-------------------------------");
      global_context = context;
      await connect(0);
      print('after await connect(0)');
      _connectivitySubscription = _connectivity
          .onConnectivityChanged
          .listen((ConnectivityResult result) {
        _connectionStatus = result.toString();
        print("_connectivity.listen-------------------------------");
        print('--------------------当前网络：$_connectionStatus------------------------');
        if (result != ConnectivityResult.mobile && result != ConnectivityResult.wifi) {
          print('没有网络，停止定时器');
          netWorkStatus = false;
          if(heartbeatCountDown != null){
            heartbeatCountDown.cancel();
          }
          connect(5);
        }else{
          netWorkStatus = true;
          reconnectTimes = 0;
        }
      });
    } on SocketException catch (e) {
      print("init链接socket出现异常，e=${e.toString()}");
    }catch (e){
      print('init打印Exception:${e.toString()}');
    }
  }

  Future connect(int second)async{
    print("connect-------------------------------");
    print('sleep: '+second.toString());
//    await sleep(Duration(seconds:second));
    sleep(Duration(seconds:second));
    print('wake up after: '+second.toString());
    try {
      heartbeatCountDownTimes = 15;
      if(_socket != null){
        _socket = null;
      }
      print('reconnectTimes:$reconnectTimes');
      await Socket.connect(host, port, timeout: Duration(seconds: 5)).then((Socket socket){
        print('连接成功');
        _socket = socket;
        _socket.listen(decodeHandle,
            onError: errorHandler,
            onDone: doneHandler,//处理关闭事件
            cancelOnError: false);
        heartbeatSocket();//确保connect结束后调用
      });
      netWorkStatus = true;
      reconnectTimes = 0;
    }on SocketException catch (e) {
      netWorkStatus = false;
      if(heartbeatCountDown != null){
        heartbeatCountDown.cancel();
      }

      print('打印SocketException:${e.toString()}');
      if(reconnectTimes <= reconnectTimesLimit){
        print('重连');
        connect(reconnectWaitSecond);
        reconnectTimes++;
      }else{
        _socket.close();
      }
    }catch (e){
      print('打印Exception:${e.toString()}');
    }


  }

  /**
   * 发消息，指定消息号，pb对象能够为不传(例如发心跳包的时候)
   */
//  void sendMsg (int msgType, int delayPeriod,[GeneratedMessage? pb]) async{
  void sendMsg (int msgType, int delayPeriod,Msg? pb) async{
    //序列化pb对象
    pb!.head.msgId = ToolUtils.getRandomString(8);
    Uint8List pbBody = Uint8List(10);
    if(pb != null) {
      pbBody = pb.writeToBuffer();
    }
    var msg = pbBody.buffer.asUint8List();
    //给服务器发消息
    try {
      if(msgType == 101){
        await Future.delayed(Duration(seconds: delayPeriod),()=>_socket.add(msg));
      }else if(msgType == 100){
        _socket.add(msg);
      }else if(pb != null && msgType == 102){
        var socketDataProvider = Provider.of<SocketDataProvider>(global_context,listen:false);
        Map sendMsgList = socketDataProvider.sendMsgList;
        sendMsgList.putIfAbsent(pb.head.msgId, ()=>pb);
        print('sendMsgList.putIfAbsent:${pb}');
        _socket.add(msg);
      }else if(pb != null && msgType == 104){
        _socket.add(msg);
      }

      print("给服务端发送消息，消息号=$msgType");
    } catch (e) {
      print("send捕获异常：msgCode=${msgType}，e=${e.toString()}");
      if(heartbeatCountDown != null){
        heartbeatCountDown.cancel();
      }
    }
  }

  /**
   * 解析返回消息
   */
  void decodeHandle(newData){
    print("decodeHandle-------------------------------");
    Msg msg = Msg.fromBuffer(newData);
    var head = msg.head;
    print(msg);
    int receiveType = msg.head.msgType;
    var socketDataProvider = Provider.of<SocketDataProvider>(global_context,listen: false);
    //收到心跳后，重置心跳倒计时
    if(101 == receiveType){
//      print('收到心跳:${msg}');
//      print('重置heartbeatCountDownTimes');
      heartbeatCountDownTimes = 15;
    }else if(100 == receiveType){//登录成功，跳转ImScreen
      print('收到登录响应:${msg}');
      var loginResult = msg.body;
      Map<String, dynamic> userCode = jsonDecode(head.extend);
      if(loginResult == 'LOGIN TOKEN'){
        var userCoder = userCode['user_code'];
        socketDataProvider.loginUser = userCode['user_code'];
        print('socketDataProvider.loginUser = ${userCode}');
        //TODO 登录成功，1.删除等待框 2.跳转页面
        Navigator.of(global_context).pushNamed('friends');
      }
    }else if(102 == receiveType){
      print('收到客户端消息:${msg}');
      socketDataProvider.insertMsgList(false, 102, msg.body);
    }else if(103 == receiveType){
      print('收到服务端确认消息:${msg}');
      var msgId = msg.head.msgId;
      String content = msg.body;
      if('SUCCESS' == content){
        socketDataProvider.sendMsgList.remove(msgId);
      }else{
        print('发送消息失败');
      }
    }else if(104 == receiveType){
      print('收到联系人列表:${msg}');
      Map<String, dynamic> friendsListMap = jsonDecode(msg.body);
      List<Map> list = friendsListMap['list'].cast<Map>();
      List<FriendEntity> friendsList = [];
      list.forEach((item) {
        friendsList.insert(0, FriendEntity(item['user_code'],item['user_name'],item['online'])) ;
      });
      socketDataProvider.setFriendsList(friendsList);//更新联系人
    }
  }

  void errorHandler(error, StackTrace trace) async{
//    heartbeatCountDownTimes = 15;
    print("errorHandler-------------------------------");
    netWorkStatus = false;
    if(heartbeatCountDown != null){
      heartbeatCountDown.cancel();
    }
    print("捕获socket异常信息：error=$error，trace=${trace.toString()}");
    print('--------------------当前网络：$_connectionStatus------------------------');
    print('尝试重连');
//    await connect(reconnectWaitSecond);
    connect(reconnectWaitSecond);
  }

  void doneHandler(){
    print("doneHandler");
  }

  // 心跳机，每15秒给后台发送一次，用来保持连接
  void heartbeatSocket(){
    print("heartbeatSocket-------------------------------");
    const periodDuration = Duration(seconds:1);
    var callback = (time) async {
      // 如果socket状态是断开的，就停止定时器
      if(!netWorkStatus){
        print('heartbeatCountDown.cancel()');
        if(heartbeatCountDown != null){
          heartbeatCountDown.cancel();
        }
        //执行重连机制
        connect(reconnectWaitSecond);
      }
      print('heartbeatCountDownTimes:'+heartbeatCountDownTimes.toString());
      if(heartbeatCountDownTimes<1){
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
        sendMsg(101,0,hbmsg);
      }else{
        heartbeatCountDownTimes--;
      }
    };

    heartbeatCountDown = Timer.periodic(periodDuration, callback);
  }
}