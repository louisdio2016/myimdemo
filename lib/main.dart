import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import 'im/pages/friends_list.dart';
import 'im/pages/im_demo.dart';
import 'im/network/socket_data.dart';
import 'im/pages/login.dart';
import 'im/pages/search_friend.dart';

void main() async{
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SocketDataProvider("10.0.2.2", 8050)),
        ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          'home': (context) => LoginScreen(),
          'chat': (context) => ImScreen(),
          'friends': (context) => FriendsList(),
          'search': (context) => SearchFriends(),
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
        builder: EasyLoading.init()//第三方组件，展示弹框
      ),
    );
  }
}


