import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:social_media_app/app/configs/colors.dart';
import 'package:social_media_app/ui/pages/inbox_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  late Map<String,dynamic> userMap;
  bool isLoading = false;
  final TextEditingController _search = TextEditingController();

  void onSearch() async{

    FirebaseFirestore _firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await _firestore.collection('users').where("email", isEqualTo: _search.text).get().then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap);
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor2,
      body: isLoading? Center(
        child: Container(
          height: 50,
          width: 50,
          child: const CircularProgressIndicator(
          ),
        ),
      ):Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Container(
            height: 50,
            width: 500,
            child: TextField(
              controller: _search,
              decoration: InputDecoration(
                hintText: "Search User",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(onPressed: onSearch, child: Text("Search")),
          const SizedBox(
            height: 30,
          ),
          userMap != null ? ListTile(
            onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => InboxPage()));

            },
            leading: const Icon(Icons.account_box, color: Colors.white,),
            title: Text(userMap['email'],style: const TextStyle(
              color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold,
            ),),
            trailing: const Icon(Icons.chat, color: Colors.white),
          ): Container(),

        ],
      ),
    );
  }
}

