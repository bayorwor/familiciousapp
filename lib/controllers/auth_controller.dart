import 'dart:io';

import 'package:familicious_app/services/file_upload.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static final FirebaseFirestore _firbaseFirestore = FirebaseFirestore.instance;
  final FileUploadService _fileUploadService = FileUploadService();

  CollectionReference userCollection = _firbaseFirestore.collection("users");
  String _message = "";

  bool _isLoading = false;

  String get message => _message;
  bool get isLoading => _isLoading;

  setMessage(String message) {
    _message = message;
    notifyListeners();
  }

  setIsLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> createNewUser(
      {required String name,
      required String email,
      required String password,
      required File imageFile}) async {
    setIsLoading(true);
    bool isCreated = false;
    _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) async {
      String? photoUrl = await _fileUploadService.uploadFile(
          file: imageFile, userUid: userCredential.user!.uid);
      if (photoUrl != null) {
        userCollection.doc(userCredential.user!.uid).set({
          "name": name,
          "email": email,
          "picture": photoUrl,
          "createdAt": FieldValue.serverTimestamp(),
          "user_id": userCredential.user!.uid
        });
        isCreated = true;
      } else {
        setMessage("Image failed to upload");
        setIsLoading(false);
        isCreated = false;
      }
    }).catchError((onError) {
      setMessage("$onError");
      setIsLoading(false);

      isCreated = false;
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      setMessage("weak or no connection");
      isCreated = false;
      setIsLoading(false);
    });
    return isCreated;
  }

  Future<bool> loginUser(
      {required String email, required String password}) async {
    bool isSuccessful = false;
    await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      if (userCredential.user != null) {
        isSuccessful = true;
      } else {
        isSuccessful = false;
        setMessage("login failed");
      }
    }).catchError((onError) {
      isSuccessful = false;
      setMessage('$onError');
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      setMessage("weak or no internet connection");
      isSuccessful = false;
    });

    return isSuccessful;
  }

  Future<bool> sendResetLink(String email) async {
    bool isSent = false;
    await _firebaseAuth.sendPasswordResetEmail(email: email).then((_) {
      isSent = true;
    }).catchError((onError) {
      isSent = false;
      setMessage('$onError');
    }).timeout(const Duration(seconds: 60), onTimeout: () {
      setMessage("weak or no internet connection");
      isSent = false;
    });
    return isSent;
  }
}
