import 'package:flutter/material.dart';
import 'package:myimdemo/im/network/socket_data.dart';
import 'package:myimdemo/im/pb/msg.pb.dart';
import 'package:provider/provider.dart';

class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
//  List<FriendEntity> friendsList = <FriendEntity>[];

  @override
  void initState() {
    super.initState();
    Head hbhead = Head.create();
    hbhead.msgContentType = 1;
    hbhead.msgId = 'msgID';
    hbhead.msgType = 104;
    hbhead.statusReport = 0;
    hbhead.toId = 'server';

    Msg hbmsg = Msg.create();
    hbmsg.body = 'getFriendList';
    hbmsg.head = hbhead;
    Future.microtask((){
        var socketDataProvider = Provider.of<SocketDataProvider>(context,listen: false);
        hbhead.fromId = socketDataProvider.loginUser;
        socketDataProvider.sendMsg(104, 0,hbmsg);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo1'),
      ),
      body: Selector<SocketDataProvider,List<FriendEntity>>(
        builder:(context,child,val){
          return ListView.builder(
              itemCount: child.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(child[index].userCode),
                  onTap: (){
                    Navigator.of(context).pushNamed('chat',arguments:child[index].userCode);
                  },
                );
              });
        },
        selector:(context,model) => model.friendsList
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
      FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () => Navigator.of(context).pushNamed('search'),//跳转添加页面
//        onPressed: (){
//
//        },//跳转添加页面
        child: Icon(Icons.add),
      ),
    );
  }
}