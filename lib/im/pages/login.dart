import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myimdemo/im/network/socket_data.dart';
import 'package:myimdemo/im/pb/msg.pb.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginScreen>{

  TextEditingController? _nameController,_pwController;
  FocusNode? _nameFocus,_pwFocus;

  late var userName = '';
  late var userPassword = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _pwController = TextEditingController();
    _nameFocus = FocusNode();
    _pwFocus = FocusNode();
    var socketDataProvider = Provider.of<SocketDataProvider>(context,listen: false);
    socketDataProvider.init(context);
  }



  @override
  Widget build(BuildContext context){
    var socketDataProvider = Provider.of<SocketDataProvider>(context,listen: false);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            const SizedBox(height: 80.0,),
            Center(
              child: Text(
                'Login',style: TextStyle(fontSize: 32.0),
              ),
            ),
            const SizedBox(height: 80.0),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                child: TextField(
                  focusNode: _nameFocus,
                  controller: _nameController,
                  obscureText: false,
                  textInputAction: TextInputAction.next,//决定键盘右下角显示的内容，此处为选中下一个录入框
                  onSubmitted: (input){
                    print('input:${input}');
                    userName = input;
                    _nameFocus!.unfocus();
                    FocusScope.of(context).requestFocus(_pwFocus);
                  },
                  onChanged: (input){
                    userName = input;
                  },
                  decoration: InputDecoration(labelText: 'name'),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Material(
                borderRadius: BorderRadius.circular(10.0),
                child: TextField(
                  focusNode: _pwFocus,
                  controller: _pwController,
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (input){
                    print('input:${input}');
                    userPassword = input;
                    _pwFocus!.unfocus();
                  },
                  onChanged: (input){
                    userPassword = input;
                  },
                  decoration: InputDecoration(labelText: 'password'),
                ),
              ),
            ),
            const SizedBox(height: 40.0,),
            ButtonBar(
              children: <Widget>[
                RaisedButton(
                  onPressed: ()async{
                    //展示loading
                    EasyLoading.instance
                    ..dismissOnTap = false
                    ..loadingStyle = EasyLoadingStyle.dark
                    ..toastPosition = EasyLoadingToastPosition.center
                    ..animationStyle = EasyLoadingAnimationStyle.scale;
                    EasyLoading.show();
                    //发送登录请求
                    Head hbhead = Head.create();
                    hbhead.msgContentType = 1;
                    hbhead.msgId = 'msgID';
                    hbhead.msgType = 100;
                    hbhead.statusReport = 23232;
                    hbhead.fromId = userName;
                    hbhead.toId = 'server';
                    print('user_code:${userName}');
                    print('user_password:${userPassword}');
                    Msg hbmsg = Msg.create();
                    hbmsg.body = '{"user_code":"${userName}","user_password":"${userPassword}"}';
                    hbmsg.head = hbhead;
                    socketDataProvider.sendMsg(100,0,hbmsg);
                  },
                  child: Text('Sign in/Sign up'),color: Colors.white,)
              ],
            )
          ],
        ),
      ),
    );
  }

}