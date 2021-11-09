import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hoper/user_image.dart';
import 'dart:io';
class EditProf extends StatefulWidget {
  

  @override
  _EditProfState createState() => _EditProfState();
}

class _EditProfState extends State<EditProf> {
final _formKey=GlobalKey<FormState>();
 var _isLoading=false;
 var ref,url;
 bool istrue=true;
 File _userImageFile;
 var username='';
 var ff="";
  var jj;
  var _initValues={
   'username':'',
      'userImage':'',
  };

void _trySubmit()async{
   FocusScope.of(context).unfocus();
   _formKey.currentState.save();
 final user=FirebaseAuth.instance.currentUser;
 if(_userImageFile!=null){
  ref= FirebaseStorage.instance.ref().child('user_image').child(user.uid+'jpg');
    await ref.putFile(_userImageFile);//it will upload file 
     url=await ref.getDownloadURL();
 }
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
'username':username,
'image_url':url!=null?url:ff,
    });

Navigator.of(context).pop();

}
  void _pickedImage(File image){
_userImageFile=image;
}
   void _endMessage() async{
    if(!istrue)
    {
      return;
    }
        
     setState(() {
      _isLoading=true;
   });

     
 final user=FirebaseAuth.instance.currentUser;

  final userData= await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  istrue=false;
   setState(() {
      _isLoading=false;
   });
     
  
    
   
  
 ff=userData['image_url'];
 jj=userData['username'];
   _initValues={
     'username':userData['username'],
      'userImage':userData['image_url'],
  };
   print('ttt$ff');
   }
   
  @override
   
  Widget build(BuildContext context) {
  _endMessage();
    return Container(
      color: Colors.white,
        width:300,
      child:Column(children:<Widget>[
    
     _isLoading? AppBar(title:Text('Hi !!'), automaticallyImplyLeading: false,
     ): AppBar(title:Text('Hi  $jj!!'),
      automaticallyImplyLeading: false,
     ),
    SizedBox(height: 60,),
      _isLoading?Center(child:CircularProgressIndicator()): Center(child:Card(margin: EdgeInsets.all(20),
  
child:SingleChildScrollView(
    
  child:Padding(
    padding:EdgeInsets.all(16),
  
    child:Form(
      key:_formKey,
      child:Column(mainAxisSize: MainAxisSize.min,children:<Widget>[
     UserImagePicker(_pickedImage, ff,false),   
TextFormField(
  initialValue: _initValues['username'],
  key: ValueKey('username'),
  decoration:InputDecoration(labelText: 'username',),
  onSaved: (value){
    username=value;
  },
),
     
      // ignore: deprecated_member_use
    RaisedButton(child: Text('Edit!!'),onPressed:_trySubmit),
     ],
      ),
    ),
  ),
),
    ),
    ),
      SizedBox(height: 60,),
 Text('edit your  profile here!!',style:TextStyle(fontSize:24,fontWeight: FontWeight.bold),),
      ],
      ),
  
    );
    

  }
}
