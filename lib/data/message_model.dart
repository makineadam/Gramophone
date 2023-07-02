import 'package:flutter/cupertino.dart';

class Message {
  final String sender;
  final String time;
  final String text;
  final String image;

  Message(
      {required this.sender,
      required this.time,
      required this.text,
      required this.image});
}

List<Message> messages = [
  Message(
    sender: 'berk',
    time: '5:30 PM',
    text: 'Hey there! How are you?',
    image: 'assets/images/berk.png',
  ),
  Message(
    sender: 'ali',
    time: '4:30 PM',
    text: 'We could surely handle this much easily if you were here.',
    image: 'assets/images/ali.jpeg',
  ),
];
