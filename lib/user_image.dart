import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
 String ff;
 bool isim;
 UserImagePicker(this.imagePickFn,this.ff,this.isim);
 final void Function(File pickedImage) imagePickFn;

 
  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {

 

File _pickedImage;
 void _pickImage()async{
  
 final picker=ImagePicker();
 final pickedImage=await picker.getImage(source:ImageSource.camera,imageQuality: 50,maxWidth: 150,);
 final pickedImageFile=File(pickedImage.path);
 if(!widget.isim){
 setState(() {
   _pickedImage=pickedImageFile;
 });}
 widget.imagePickFn(pickedImageFile);
 }
 
void jj(){
    if(widget.isim)
    {
 _pickImage();
 Navigator.of(context).pop();
    }
    return;
   
}

  @override
  Widget build(BuildContext context) {
    print('xx');
   jj();

 return Column(
      
      children:<Widget>[

    CircleAvatar(radius:40,
     backgroundImage:_pickedImage!=null? FileImage(_pickedImage): widget.ff==null?null:NetworkImage(widget.ff),
     ),

        // ignore: deprecated_member_use
        FlatButton.icon(textColor:Theme.of(context).primaryColor,
         onPressed: _pickImage,
         icon:widget.ff==null?Icon(Icons.image):Icon(Icons.edit),
         label:widget.ff!=null? Text('Edit Image'):Text('Add Image'),
      
        ),
      ],
         );
  }
}