import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/data/post_model.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<String> _getJson() {
    return rootBundle.loadString('assets/json/data_post.json');
  }

  void getPosts() async {
    emit(PostLoading());
    List<PostModel> posts = [];
    try {
      CollectionReference recordingsRef = fireStore.collection('recordings');
      await recordingsRef
          .doc(auth.currentUser!.uid)
          .collection('audio')
          .get()
          .then((value) {
        List<PostModel> postsTemp =
            value.docs.map((e) => PostModel.fromJson(e.data())).toList();
        posts = postsTemp;
      });
      //List<dynamic> jsonResult = json.decode(await _getJson());
      //jsonResult.map((e) => PostModel.fromJson(e)).toList();
      //TODO
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostError(message: 'An error occurred while loading data'));
    }
  }
}
