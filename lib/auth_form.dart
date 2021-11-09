import 'package:flutter/material.dart';
import 'package:hoper/user_image.dart';
import 'dart:io';
class AuthForm extends StatefulWidget {
 AuthForm(this.submitFn,this.isLoading);
final bool isLoading;
 final void Function(String email,String password,String userName,File image,bool isLogin,bool isforget,BuildContext ctx,)submitFn;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {

 final _formKey=GlobalKey<FormState>();
 var _isLogin=true;
 var _isforget=false;
 String _userEmail='';
 String _userName='';
 String _userPassword='';
 File _userImageFile;
void _pickedImage(File image){
_userImageFile=image;
}

 void _trySubmit(){
   FocusScope.of(context).unfocus();// this would move away focus from any input field
  final isValid= _formKey.currentState.validate();
  if(_userImageFile==null&&!_isLogin&&!_isforget){
  // ignore: deprecated_member_use
  Scaffold.of(context).showSnackBar(SnackBar(content: Text('Please pick an image'),
  backgroundColor: Theme.of(context).errorColor,
  ),);
  return;
  }
if(isValid){
  _formKey.currentState.save();
 widget.submitFn(_userEmail.trim(),
 _userPassword.trim(),
 _userName.trim(),
 _userImageFile,
 _isLogin,
 _isforget,
 context);//trim remove whitespace
} 
 }
 
  @override
  Widget build(BuildContext context) {
    return Center(child:Card(margin: EdgeInsets.all(20),
    color: Colors.white24,
child:SingleChildScrollView(
  
  child:Padding(
    padding:EdgeInsets.all(16),

child:    Form(
      key:_formKey,
      child:Column(mainAxisSize: MainAxisSize.min,children:<Widget>[
        if(!_isLogin&&!_isforget)
        UserImagePicker(_pickedImage,null,false),
      
TextFormField(
  key: ValueKey('email'),
  validator: (value){
    if(value.isEmpty||!value.contains('@')){
      return 'Please enter a valid email address';
    }
    return null;
  },
  keyboardType: TextInputType.emailAddress,
  decoration:InputDecoration(labelText: 'Email address',labelStyle: TextStyle(color: Colors.orange,fontSize: 20,fontWeight: FontWeight.bold)),
  onSaved: (value){
    _userEmail=value;
  },
),
if(!_isLogin&&!_isforget)
TextFormField(
  key: ValueKey('username'),
  decoration: InputDecoration(labelText:'Username',labelStyle: TextStyle(color: Colors.orange,fontSize: 20,fontWeight: FontWeight.bold)),
   onSaved: (value){
    _userName=value;
  },
),
if(!_isforget)
TextFormField(
  key: ValueKey('password'),
   validator: (value){
  if(value.isEmpty|| value.length<7){
    return 'Please enter a valid password ';
  }
  return null;
   },

   decoration: InputDecoration(labelText:'Password',labelStyle: TextStyle(color: Colors.orange,fontSize: 20,fontWeight: FontWeight.bold)),
   obscureText: true,
    onSaved: (value){
    _userPassword=value;
  },
),
SizedBox(height:12),
if(widget.isLoading)CircularProgressIndicator(),
if(!widget.isLoading)
// ignore: deprecated_member_use
RaisedButton(child: Text(_isLogin&&!_isforget?'login':_isforget?'send email':'SignUp'),onPressed:_trySubmit),
if(!widget.isLoading)
// ignore: deprecated_member_use
RaisedButton(
  
  child:Text(_isLogin?'create a new account':'I already have an account',style:TextStyle(fontWeight: FontWeight.bold)),onPressed: (){
    setState(() {
      _isLogin=!_isLogin;
      _isforget=false;
    });
  },),

// ignore: deprecated_member_use
if(!_isforget)
FlatButton(
  textColor: Colors.white,
  child:Text('Forget password?',style:TextStyle(fontWeight: FontWeight.bold)),onPressed: (){
    setState(() {
      _isforget=true;
      _isLogin=false;
    });
  },)


    ],),),
  ),
),
)); 
  }
}