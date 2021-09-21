import 'package:flutter/material.dart';
import 'package:myimdemo/im/pb/msg.pb.dart';
import 'package:myimdemo/im/network/socket_data.dart';
import 'package:provider/provider.dart';

class SearchFriends extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends>{
  @override
  void initState(){
    super.initState();
    //TODO 获取所有用户，添加用户后重新刷新用户列表
    Future.microtask((){
      Head hbhead = Head.create();
      hbhead.msgContentType = 1;
      hbhead.msgId = 'msgID';
      hbhead.msgType = 106;
      hbhead.statusReport = 0;
      hbhead.toId = 'server';

      Msg hbmsg = Msg.create();
      hbmsg.body = 'getAllFriendList';
      hbmsg.head = hbhead;
      var socketDataProvider = Provider.of<SocketDataProvider>(context,listen: false);
      hbhead.fromId = socketDataProvider.loginUser;
      socketDataProvider.sendMsg(106, 0,hbmsg);
    });
  }


  @override
  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('SearchBar'),
//        actions: <Widget>[
//          IconButton(
//              icon: Icon(Icons.search),
//              onPressed: ()=>{
//                showSearch(context: context, delegate: SearchFriendsDelegate())
//              }
//          )
//        ],
//      ),
//    );
    return Scaffold(
      appBar:
      AppBar(
        title: Text('SearchBar'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: ()=>{
                showSearch(context: context, delegate: SearchFriendsDelegate())
              }
          )
        ],
      ),
    );
  }
}

class SearchFriendsDelegate extends SearchDelegate{
  @override
  List<Widget> buildActions(BuildContext context) {//选中后右测图标
    return [
      IconButton(icon: Icon(Icons.clear), onPressed: ()=> query="")//query：搜索框中的内容
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {//左侧图标
    Head hbhead = Head.create();
    hbhead.msgContentType = 1;
    hbhead.msgId = 'msgID';
    hbhead.msgType = 104;
    hbhead.statusReport = 0;
    hbhead.toId = 'server';

    Msg hbmsg = Msg.create();
    hbmsg.body = 'getFriendList';
    hbmsg.head = hbhead;
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, progress: transitionAnimation,
      ),
      onPressed: (){
        var socketDataProvider = Provider.of<SocketDataProvider>(context,listen: false);
        hbhead.fromId = socketDataProvider.loginUser;
        socketDataProvider.sendMsg(104, 0,hbmsg);
        close(context,null);
      },//关闭搜索页面
    );
  }

  @override
  Widget buildResults(BuildContext context) {//执行搜索
    return Center(
      child: Container(
        width: 100.0,
        height: 100.0,
        child: Card(
          color: Colors.redAccent,
          child: Center(
            child: Text(query),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {//搜索框录入后展示建议
    var socketDataProvider = Provider.of<SocketDataProvider>(context);
    List<FriendEntity> suggestionList = query.isEmpty
        ? []
        : socketDataProvider.allFriendsList.where((input) =>
        input.userCode.startsWith(query)).toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context,index) => ListTile(
          onTap: (){
            var friendUserCode = suggestionList[index].userCode;
//            showResults(context);
            //TODO 发送添加请求
            Head hbhead = Head.create();
            hbhead.msgContentType = 1;
            hbhead.msgId = 'msgID';
            hbhead.msgType = 105;
            hbhead.statusReport = 23232;
            hbhead.fromId = socketDataProvider.loginUser;
            hbhead.toId = '${friendUserCode}';
            print('user_code:${socketDataProvider.loginUser}添加${friendUserCode}');
            Msg hbmsg = Msg.create();
            hbmsg.body = '${friendUserCode}';
            hbmsg.head = hbhead;
            socketDataProvider.sendMsg(105,0,hbmsg);
          },
          title: RichText(
              text: TextSpan(
                  text: suggestionList[index].userCode.substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                        text: suggestionList[index].userCode.substring(query.length),
                        style: TextStyle(color: Colors.grey))
                  ]
              )
          ),
        )
    );
  }

}