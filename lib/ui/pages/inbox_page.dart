import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_media_app/app/configs/colors.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {

  final Map<String, dynamic> userMap;
  final String chatRoomId;

  InboxPage({this.chatRoomId, this.userMap})

  final TextEditingController _message = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.primaryColor2,
      body: SingleChildScrollView(
        child: Column (
          children: [Container(
            height: size.height/1.25,
            width: size.width,
            child: StreamBuilder<QuerySnapshot>(
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.data != null) {
                  ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                      return Text(snapshot.data?.docs[index]['message']);
                      });
                }
                else{
                  return Container();
                }

              },
            )  ,
          ),
          ],
        ),
      ),
    );
  }
}
