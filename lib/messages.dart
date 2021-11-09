import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoper/message_bubble.dart';

class Messages extends StatefulWidget {
 final String ff;
 Messages(this.ff);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {



  @override
  Widget build(BuildContext context) {
    print('aysu');
  final user=FirebaseAuth.instance.currentUser;

    return  StreamBuilder(
stream: FirebaseFirestore.instance.collection('chat/${widget.ff}/messages').orderBy('createdAt',descending: true).snapshots(),
builder: (ctx,chatSnapshot){
  if(chatSnapshot.connectionState==ConnectionState.waiting){
    return Center(child: CircularProgressIndicator(),);
  }
  final chatDocs=chatSnapshot.data.docs;
  print(chatDocs);
  return ListView.builder(
    reverse: true,
    itemCount: chatDocs.length,
    itemBuilder: (ctx,index)=>
     MessageBubble(chatDocs[index].data()['text'],
    chatDocs[index].data()['username'],
   chatDocs[index].data()['userId'],
    chatDocs[index].data()['userId']==user.uid,
    key: ValueKey(chatDocs[index].id),
    ),

    );
},
    );
  }
}