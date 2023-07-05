import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
      final followingRef = fireStore.collection('following');

      QuerySnapshot snapshot =
          await followingRef.doc(id).collection('userFollowing').get();
      List<String> senderIds = snapshot.docs.map((e) => e.id).toList();
      for (var senderId in senderIds) {
        await recordingsRef
            .doc(senderId)
            .collection('audio')
            .get()
            .then((value) {
          List<PostModel> postsTemp =
              value.docs.map((e) => PostModel.fromJson(e.data())).toList();
          posts.addAll(postsTemp);
        });
      }
      emit(PostLoaded(posts: posts));
    } catch (e) {
      emit(PostLoaded(posts: posts));
    }
  }

  void getMyPosts(String id) async {
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
