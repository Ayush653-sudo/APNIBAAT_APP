import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoper/auth_screen.dart';
import 'package:hoper/messages.dart';
import 'package:hoper/new_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
class ChatScreen extends StatefulWidget {

final String uuu;
ChatScreen(this.uuu);
 
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

 @override
 void initState(){
   final fbm=FirebaseMessaging.instance;
   fbm.requestPermission();
   FirebaseMessaging.onMessage.listen((message) {
     print(message);
     return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) { 
      print(message);
      return;
    });
    fbm.subscribeToTopic('chat');
   super.initState();
 }

 
  @override
  Widget build(BuildContext context) {
    final user=FirebaseAuth.instance.currentUser;
   print(widget.uuu);
  String ff; 
final int t=widget.uuu.compareTo(user.uid);
if(t==1){
  ff=widget.uuu+user.uid;
}
else if(t==-1){
  ff=user.uid+widget.uuu;
}
    return 
     Scaffold(
        appBar: AppBar(title: Text('ApniBaat')
          
      
        ),
    body: Stack(
         children: <Widget>[
      Container(
          
 child: FractionallySizedBox(
                  heightFactor: 1.0,
                  widthFactor: 1.0,
                  //for full screen set heightFactor: 1.0,widthFactor: 1.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image:  AssetImage('assets/images/wp4410721.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
           


    
    Container(
      child:Column(
      children:<Widget>[     //wp4410721.jpg
        Expanded(
       child: Messages(ff),
       ),
       NewMessage(ff),
      ],
      ),
    ),    
         ]
    ), 
       
      
          
      
    );
    
  }
}