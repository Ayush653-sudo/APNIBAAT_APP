import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hoper/auth_screen.dart';
import 'package:hoper/chat_screen.dart';
import 'package:hoper/edit_profile.dart';
class Person extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(title:Text('Your Friends'),actions: [
        
        DropdownButton(icon:Icon(Icons.more_vert,color:Colors.blue),
        items: [
          DropdownMenuItem(
            child:Container(child: Row(
              children:<Widget>[
            Icon(Icons.exit_to_app,color:Colors.black,),
            SizedBox(width: 8,),
            Text('Logout',),
            
          ],),
          ),
          value:'Logout',
          ),
        ],
        onChanged: (itemIdentifier){
           print('aaaa');
       if(itemIdentifier=='Logout'){
         print('aaaa');
       FirebaseAuth.instance.signOut();
     //   Navigator.of(context).pushReplacement(AuthScreen());
       }
        },
  ),
      ],
        
      
      ),
  drawer:EditProf(),
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
                        image: AssetImage('assets/images/wp4410721.jpg'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
              ),


           
          //repeat: ImageRepeat.repeat,
      
    
  
 
    StreamBuilder(
    stream: FirebaseFirestore.instance.collection('users').snapshots(),
    builder: (ctx,userSnapshot){
      if(userSnapshot.connectionState==ConnectionState.waiting){
        return Center(child: CircularProgressIndicator(),);
      }
      final userDocs=userSnapshot.data.docs;
      
      print(userDocs);
       final user=FirebaseAuth.instance.currentUser;
       print(user.uid);
      
      return 
       ListView.builder(
            itemCount: userDocs.length,
          itemBuilder: (ctx,index)=>
         
           Container(
              width:double.infinity,
             child: user.uid==userDocs[index]['user_uid']?null: Card(
              
               color:Colors.white,
              margin:EdgeInsets.symmetric(
                horizontal:0,
                vertical:10,
              ),
              child:Padding(
                padding:EdgeInsets.all(8),
                
         child: ListTile(
                  
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userDocs[index].data()['image_url']),
                   radius: 40,
                    ),
                  
                  title:Text(userDocs[index].data()['username'],style:TextStyle(fontSize:18,fontWeight: FontWeight.bold),),
                
                  subtitle: Text(userDocs[index].data()['email']),
                  onTap:(){
                    print('yoho..');
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> ChatScreen(userDocs[index].data()['user_uid']),));
                  
                  },
                ),
              ),
              
          ),
           ),
            
        );
      
    }),
    ],
   ),
 
    );
  }
}