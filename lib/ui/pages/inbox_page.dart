import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_media_app/app/configs/colors.dart';
import 'package:social_media_app/data/message_model.dart';
import 'package:social_media_app/ui/pages/chat_page.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  Map<String, dynamic>? userMap;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  String latestMessage = '';

  @override
  void initState() {
    super.initState();
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1-$user2";
    } else {
      return "$user2-$user1";
    }
  }

  void findLastMessage(String roomId) async {
    String lastMessage = '';
    await fireStore
        .collection('chatroom')
        .doc(roomId)
        .collection('chats')
        .orderBy('time', descending: true)
        .limit(1)
        .get()
        .then((value) {
      lastMessage = value.docs[0].data()['message'];
    });
    setState(() {
      latestMessage = lastMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 70,
          ),
          const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              'Inbox',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              child: StreamBuilder<QuerySnapshot>(
                stream: fireStore.collection('chatroom').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.data != null) {
                    final allData = snapshot.data!.docs.toList();
                    return ListView.builder(
                        reverse: false,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          findLastMessage(map['id']);
                          return InboxChat(
                              message: Message(
                                  image: _auth.currentUser!.email! ==
                                          map['id'].split('-')[0]
                                      ? 'assets/images/ali.jpeg'
                                      : 'assets/images/berk.png',
                                  sender: _auth.currentUser!.email! ==
                                          map['id'].split('-')[0]
                                      ? map['id'].split('-')[1].split('@')[0]
                                      : map['id'].split('-')[0].split('@')[0],
                                  text: latestMessage,
                                  time: '12:00'),
                              roomID: map['id'],
                              mail: _auth.currentUser!.email! ==
                                      map['id'].split('-')[0]
                                  ? map['id'].split('-')[1].split('@')[0]
                                  : map['id'].split('-')[0].split('@')[0]);
                        });
                  } else {
                    return Container();
                  }
                },
              ), /*ListView.builder(
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final Message message = messages[index];
                  return InboxChat(message: message);
                },
              ),*/
            ),
          ),
        ],
      ),
    );
  }
}

class InboxChat extends StatelessWidget {
  String roomID;
  String mail;

  InboxChat({
    Key? key,
    required this.message,
    required this.roomID,
    required this.mail,
  }) : super(key: key);

  final Message message;

  Map<String, dynamic>? chatRoom(String id) {
    return {
      "id": id,
    };
  }

  Map<String, dynamic>? userMap(String mail) {
    return {
      "email": mail,
    };
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ChatPage(
                  chatRoom: chatRoom(roomID),
                  userMap: userMap(mail),
                )));
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.greyColor.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: CircleAvatar(
                  radius: 35, backgroundImage: AssetImage(message.image)),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.65,
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        message.sender,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(message.time,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: Colors.black54,
                          ))
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      message.text,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.black54,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
