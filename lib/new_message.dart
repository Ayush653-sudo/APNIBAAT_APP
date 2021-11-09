import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hoper/speech_api.dart';
import 'package:hoper/user_image.dart';
class NewMessage extends StatefulWidget {
 final String ff;
 NewMessage(this.ff);
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  
  bool isListening=false;
  final _controller=new TextEditingController();
  var _enteredMessage='',url,ref;
  File _userImageFile;
  String emmji='';
  
Future togglerecording(){SpeechApi.toggleRecording(
  onResult: (text)=>setState(()=>this._controller.text=text+' '),
  onListening: (isListening)=>
setState(()=>this.isListening=isListening

),);

}

   void _pickedImage(File image)async{
_userImageFile=image;
 ref= FirebaseStorage.instance.ref().child('user_image').child(Timestamp.now().toString()+'jpg');
    await ref.putFile(_userImageFile);//it will upload file 
     url=await ref.getDownloadURL();
_sendMessage();
}


  void _sendMessage() async{
    FocusScope.of(context).unfocus();
      final user=FirebaseAuth.instance.currentUser;
      final String kk=widget.ff;
      final userData= await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    FirebaseFirestore.instance.collection('chat/$kk/messages').add({
      'text':_enteredMessage.isEmpty?url:_enteredMessage,
      'createdAt': Timestamp.now(),
      'userId':user.uid,
      'username':userData['username'],
     
    });
    _controller.clear();
    url="";
    _enteredMessage="";

  }

  @override
  Widget build(BuildContext context) {
  
    return Container(
      margin:EdgeInsets.only(top: 8),
      padding:EdgeInsets.all(8),
      child:Row(
        children: <Widget>[
        AvatarGlow(
          animate: isListening,
          endRadius: 30,
          glowColor: Theme.of(context).primaryColor,
       child:  IconButton(color: Theme.of(context).primaryColor,
          icon:Icon(isListening?Icons.mic :Icons.mic_none),
          onPressed:togglerecording,
         ),
          ),
          
 IconButton(color: Theme.of(context).primaryColor,
          icon:Icon(Icons.camera),
          onPressed:(){
            
               Navigator.push(context,MaterialPageRoute(builder: (context)=>  UserImagePicker( _pickedImage,null,true)));
           
          }
 ),
          Expanded(
            child:TextField(
              controller: _controller,
             decoration: InputDecoration(labelText: 'Send a message..'),
             onChanged: (value){
           setState(() {
       _enteredMessage=value;
           });
             },
            ),
          ),
          IconButton(color: Theme.of(context).primaryColor,
          icon:Icon(Icons.send,),
          onPressed:_enteredMessage.isEmpty? null: _sendMessage,
          )
        ],
      ),
    );
  }
}