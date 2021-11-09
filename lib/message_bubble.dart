import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

class MessageBubble extends StatefulWidget {
  MessageBubble(this.message,this.username, this.userID,this.isMe,{this.key});
  final String message;
  final String username;
 final userID;
  final bool isMe;
  final Key key ;

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
var userImage;

bool istrue=true,isLoading=false;


void tt()async{
  if(!istrue){
    return ;
  }
   setState(() {
      isLoading=true;
   });
  
 final user=FirebaseAuth.instance.currentUser;
  final userData= await FirebaseFirestore.instance.collection('users').doc(widget.userID).get();
userImage=userData['image_url'];
istrue=false;
 setState(() {
      isLoading=false;
   });
}





  @override
  Widget build(BuildContext context) {
    tt();
    bool valid=Uri.parse(widget.message).isAbsolute;
   print('ayysh$userImage');
    return GestureDetector(
      child: Row(
        mainAxisAlignment: widget.isMe?MainAxisAlignment.end:MainAxisAlignment.start,
        children: <Widget>[
          
          CircleAvatar(backgroundImage:isLoading?AssetImage('assets/images/product-placeholder.png'):NetworkImage(userImage),maxRadius: 25,),
        Container(
          decoration:!valid? BoxDecoration(
          color: widget.isMe?Colors.purple[300] :Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(12),
          ):BoxDecoration( border:Border.all(),),
         // width: message.length*1.0,
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
          margin:EdgeInsets.symmetric(vertical: 4,horizontal: 4),
           child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
             children: <Widget>[
              Text(widget.isMe?'Me':widget.username,style: TextStyle(fontWeight:FontWeight.bold),textAlign: TextAlign.start,),
          valid?Image.network(widget.message,fit:BoxFit.cover,height: 220,):    
          
           Text(widget.message,style: TextStyle(color: Theme.of(context).accentTextTheme.headline1.color),),
             ],
           ),
          
        ),
        ],
      ),
      onLongPress:()async{
        await FlutterClipboard.copy(widget.message);
        Scaffold.of(context).showSnackBar(SnackBar(content:Text('Copied to Clipboard'),),);
      }
    );
  }
}