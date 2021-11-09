import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hoper/chat_screen.dart';
// ignore: unused_import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoper/edit_profile.dart';
import 'package:hoper/persons.dart';

import 'auth_screen.dart';

void main() {
 WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp>_initialization=Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
    
    future:_initialization,
    // ignore: missing_return
    builder:(context,snapshot){
      if(snapshot.connectionState==ConnectionState.waiting){
        return  Center(child:CircularProgressIndicator(),);
}
      
return  MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor:Colors.pink,
          textTheme: ButtonTextTheme.primary,
          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
        )
      ),
      home: StreamBuilder(stream:FirebaseAuth.instance.authStateChanges(),builder: (ctx,userSnapshot){
if(userSnapshot.hasData){

  return Person();
}
return AuthScreen();
      }),
    );
      
    }
    
    
    
   
    );

  }
}

