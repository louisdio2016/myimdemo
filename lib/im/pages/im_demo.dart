import 'dart:async';
import 'package:flutter/material.dart';
import 'package:myimdemo/im/pb/msg.pb.dart';
import 'package:provider/provider.dart';
import '../network/socket_data.dart';

class ImScreen extends StatefulWidget {
  @override
  _ImScreenState createState() => _ImScreenState();


}

class _ImScreenState extends State<ImScreen> {
  StreamController? _messageController;
  TextEditingController? _textController;
  String _myName = "myboss";
  dynamic _toUser = '';

  @override
  void initState(){
    super.initState();
    _messageController = StreamController();
    _textController = TextEditingController();
//    Future.microtask(() {
//      var socketDataProvider = Provider.of<SocketDataProvider>(context,listen: false);
//      _myName = socketDataProvider.loginUser;
//    });
  }

  @override
  void dispose() {
    _textController!.dispose();
    _messageController!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    var socketDataProvider = Provider.of<SocketDataProvider>(context);
////    List<MessageEntity> msgList = socketDataProvider.msgList;
////    print('msgList.length:${msgList.length}');
//    NetworkManager networkManager = socketDataProvider.networkManager;
//    bool status = networkManager.netWorkStatus;
//    print('netWorkStatus:${status}');
    _toUser = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('IM Challenge'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
//            Consumer<SocketDataProvider>(
//              builder: (context,child,val){
//                return Flexible(
//                    child: ListView.builder(
//                        reverse: true,
////                    itemCount: _myMessages.length,
//                        itemCount: msgList.length,
//                        itemBuilder: (context, index) {
//                          //TODO 取Provider.msgList
////                      return _buildMessageWidget(_myMessages[index], context);
//                          return _buildMessageWidget(msgList[index], context);
//                        }));
//              }
//            ),
            Selector<SocketDataProvider,List<MessageEntity>>(
              builder:(context,child,val){
                return Flexible(
                    child: ListView.builder(
                        reverse: true,
//                    itemCount: _myMessages.length,
                        itemCount: child.length,
                        itemBuilder: (context, index) {
                          //TODO 取Provider.msgList
//                      return _buildMessageWidget(_myMessages[index], context);
                          return _buildMessageWidget(child[index], context);
                        }));
              },
              selector:(context,model) => model.msgList,
              shouldRebuild: (pre,cur)=>pre!=cur,
            ),
            Divider(
              height: 1.0,
            ),
            _buildInputWidget(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInputWidget(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
                child: TextField(
                  decoration:
                  InputDecoration.collapsed(hintText: "Send your message"),
                  controller: _textController,
                  onChanged: onMessageChanged,
                  onSubmitted: onMessageSubmit,
                )),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: StreamBuilder(
                initialData: "",
                stream: _messageController!.stream,
                builder: (context, snapshot) {
                  return IconButton(
                    icon: Icon(
                      Icons.send,
                      color: snapshot.data == ""
                          ? Colors.grey
                          : Theme.of(context).accentColor,
                    ),
                    onPressed: () => onMessageSubmit(_textController!.text),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

//  Widget _buildMessageWidget(String text, BuildContext context) {
  Widget _buildMessageWidget(MessageEntity msgEntity, BuildContext context) {
    var own = msgEntity.own;
    if(own){//本人消息
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        width: MediaQuery.of(context).size.width / 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width / 4,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(_myName, style: Theme.of(context).textTheme.subhead),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.blue.withOpacity(0.2)),
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        msgEntity.content,
                        overflow: TextOverflow.fade,
                        softWrap: true,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 16.0, left: 8.0),
              child: CircleAvatar(
                child: Text(_myName[0]),
              ),
            ),
          ],
        ),
      );
    }else{//对方消息
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        width: MediaQuery.of(context).size.width / 2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,//底对齐
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(right: 8.0, left: 16.0),
              child:CircleAvatar(
                child: Text(this._toUser[0]),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Align(
                      alignment: Alignment.topLeft,
                      child:Text(this._toUser, style: Theme.of(context).textTheme.subhead)
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            color: Colors.blue.withOpacity(0.2)),
                        margin: const EdgeInsets.only(top: 5.0),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            msgEntity.content,
                            overflow: TextOverflow.fade,
                            softWrap: true,
                          ),
                        ),
                      )
                  )
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  onMessageSubmit(String message) {
    var socketDataProvider = Provider.of<SocketDataProvider>(context,listen: false);
//    var socketDataProvider = Provider.of<SocketDataProvider>(context);
    _textController!.clear();
    if (message != "") {
      Head hbhead = Head.create();
      hbhead.msgContentType = 1;
      hbhead.msgId = 'msgID';
      hbhead.msgType = 102;
      hbhead.statusReport = 23232;
      hbhead.fromId = socketDataProvider.loginUser;
      hbhead.toId = this._toUser;

      Msg hbmsg = Msg.create();
      hbmsg.body = message;
      hbmsg.head = hbhead;
      socketDataProvider.sendMsg(102, 0,hbmsg);
      socketDataProvider.insertMsgList(true, 102, message);//Provider.msgList插入信息，触发notifyListener

    }
    onMessageChanged("");
  }

  onMessageChanged(String message) {
    print('onMessageChanged message:$message');
    _messageController!.sink.add(message);
  }
}

