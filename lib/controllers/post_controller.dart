import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familicious_app/services/file_upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PostController with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firebaseFireStore =
      FirebaseFirestore.instance;
  final CollectionReference<Map<String, dynamic>> _postCollection =
      _firebaseFireStore.collection("posts");
  final CollectionReference<Map<String, dynamic>> _userCollection =
      _firebaseFireStore.collection("users");

  final FileUploadService _fileUploadService = FileUploadService();

  String _message = "";

  String get message => _message;

  setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  Future<bool> createPost(
      {String? description, required File postImage}) async {
    bool isSubmitted = false;
    String userUid = _firebaseAuth.currentUser!.uid;

    FieldValue timestamp = FieldValue.serverTimestamp();
    String? photoUrl = await _fileUploadService.uploadPostFile(file: postImage);

    if (photoUrl != null) {
      await _postCollection.doc().set({
        "description": description,
        "image_url": photoUrl,
        "createdAt": timestamp,
        "user_uid": userUid
      }).then((_) {
        isSubmitted = true;
        setMessage("Post successfully submitted");
      }).catchError((error) {
        isSubmitted = false;
        setMessage("$error");
      }).timeout(const Duration(seconds: 60), onTimeout: () {
        isSubmitted = false;
        setMessage("weak or no network");
      });
    } else {
      isSubmitted = false;
      setMessage("not image found");
    }
    return isSubmitted;
  }

  Stream<QuerySnapshot<Map<String, dynamic>?>> getAllPosts() {
    return _postCollection.orderBy("createdAt", descending: true).snapshots();
  }

  Future<Map<String, dynamic>?> getUsersInfo(String userUid) async {
    Map<String, dynamic>? userdata;
    await _userCollection
        .doc(userUid)
        .get()
        .then((DocumentSnapshot<Map<String, dynamic>> doc) {
      if (doc.exists) {
        userdata = doc.data();
      } else {
        userdata = null;
      }
    });
    return userdata;
  }
}
