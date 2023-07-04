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

  void getPosts(String id) async {
    emit(PostLoading());
    List<PostModel> posts = [];
    try {
      CollectionReference recordingsRef = fireStore.collection('recordings');
      await recordingsRef.doc(id).collection('audio').get().then((value) {
        List<PostModel> postsTemp =
            value.docs.map((e) => PostModel.fromJson(e.data())).toList();
        posts = postsTemp;
      });
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostError(message: 'An error occurred while loading data'));
    }
  }
}
