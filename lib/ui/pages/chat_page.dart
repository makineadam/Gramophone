import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_media_app/app/configs/colors.dart';
import 'package:social_media_app/app/configs/theme.dart';
import 'package:social_media_app/app/resources/constant/named_routes.dart';
import 'package:social_media_app/ui/pages/navigation_page.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatPage extends StatelessWidget {
  final Map<String, dynamic>? userMap;
  final Map<String, dynamic>? chatRoom;

  ChatPage({this.chatRoom, this.userMap});

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser?.uid,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };

      _message.clear();

      DocumentReference chatRoomRef =
          _firestore.collection('chatroom').doc(chatRoom!['id']);
      await chatRoomRef.set(chatRoom!);
      await chatRoomRef.collection('chats').add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const NavigationPage(index: 2)),
          ),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 24,
            color: AppColors.blackColor,
          ),
        ),
        title: Text(
          userMap?['email'].split('@')[0],
          style: AppTheme.blackTextStyle.copyWith(
            fontSize: 18,
            fontWeight: AppTheme.bold,
          ),
        ),
      ),
      backgroundColor: AppColors.whiteColor,
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            Container(
              height: size.height / 1.25,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('chatroom')
                    .doc(chatRoom!['id'])
                    .collection('chats')
                    .orderBy('time', descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    return ListView.builder(
                        reverse: false,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          return messages(size, map);
                        });
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: Container(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 219, 219, 219),
                        border: Border.all(color: AppColors.whiteColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0, bottom: 2),
                        child: TextField(
                          controller: _message,
                          decoration: const InputDecoration(
                            hintText: "Type a message...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      color: AppColors.primaryColor2,
                      onPressed: onSendMessage,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget messages(Size size, Map<String, dynamic> map) {
    return Column(
      children: [
        /*DateChip(
          date: DateTime(2021, 5, 7),
          color: AppColors.primaryColor2.withOpacity(0.2),
        ),*/
        Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: BubbleNormal(
              color: AppColors.primaryColor2,
              isSender: map['sendby'] == _auth.currentUser!.uid ? true : false,
              text: map['message'],
              textStyle:
                  const TextStyle(color: AppColors.whiteColor, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }
}
