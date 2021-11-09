import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoper/auth_form.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth=FirebaseAuth.instance;
  var _isLoading=false;
  
  void _submitAuthForm(String email,
  String password,
  String username,
  File image,bool isLogin,bool isforget, 
  BuildContext ctx)async{
   UserCredential authResult;
   try{
     setState(() {
       _isLoading=true;
     });
    if(isLogin){
      authResult=await _auth.signInWithEmailAndPassword(email: email, password: password,);
    }
    else if(!isLogin&&!isforget){
      authResult=await _auth.createUserWithEmailAndPassword(email: email, password: password);
     final ref= FirebaseStorage.instance.ref().child('user_image').child(authResult.user.uid+'jpg');
    await ref.putFile(image);//it will upload file 
    final url=await ref.getDownloadURL();
  
    await FirebaseFirestore.instance.collection('users').doc(authResult.user.uid).set({
'username':username,
'email':email,
'image_url':url,
'user_uid':authResult.user.uid,
    });
    }

    else {
       // ignore: deprecated_member_use
       Scaffold.of(ctx).showSnackBar(
       SnackBar(duration: Duration(seconds: 50),content:Text('Verification sent to your email!!'),backgroundColor: Theme.of(ctx).errorColor,));
await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
     //  Navigator.of(context).pop(AuthScreen());
   setState(() {
    _isLoading=false;
 
 AuthScreen();  
   });
   
      // Navigator.push(context,MaterialPageRoute(builder: (context)=>AuthScreen()));
    }
   } catch(error){
     var message='An error occurred,please check our credentials!';
     if(error.message!=null){
message=error.message;
     }
     // ignore: deprecated_member_use
     Scaffold.of(ctx).showSnackBar(
       SnackBar( content:Text(message),backgroundColor: Theme.of(ctx).errorColor,));
       setState(() {
         _isLoading=false;
       });

   }
   
 
   
   
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
backgroundColor: Theme.of(context).primaryColor,
body: 

 Stack(
         children: <Widget>[



       
       Container(
          
 child: FractionallySizedBox(
                  heightFactor: 1.0,
                  widthFactor: 1.0,
                  //for full screen set heightFactor: 1.0,widthFactor: 1.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/cartoon-smartphone-man-mobile-chat_24877-17101.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),
 
                   
                  
 


AuthForm(_submitAuthForm,_isLoading), 
  
  
         ],
         
),
    );
  }
}