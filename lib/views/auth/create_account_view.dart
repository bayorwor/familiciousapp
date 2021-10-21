import 'dart:io';

import 'package:familicious_app/controllers/auth_controller.dart';
import 'package:familicious_app/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicons/unicons.dart';

class CreateAccountView extends StatefulWidget {
  CreateAccountView({Key? key}) : super(key: key);

  @override
  State<CreateAccountView> createState() => _CreateAccountViewState();
}

class _CreateAccountViewState extends State<CreateAccountView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final emailRegEx = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  final AuthController _authController = AuthController();

  bool isloading = false;

  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFile;

  Future selectImage({ImageSource imageSource = ImageSource.camera}) async {
    XFile? selectedFile = await _imagePicker.pickImage(source: imageSource);
    // File imageFile = File(selectedFile!.path);

    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: selectedFile!.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: const AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    setState(() {
      _imageFile = croppedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(90),
                  child: _imageFile == null
                      ? Image.asset(
                          "assets/user.jpeg",
                          height: 130,
                          width: 130,
                          fit: BoxFit.contain,
                        )
                      : Image.file(
                          _imageFile!,
                          height: 130,
                          width: 130,
                          fit: BoxFit.contain,
                        ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SizedBox(
                          height: 200,
                          child: Column(
                            children: [
                              TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    selectImage(
                                        imageSource: ImageSource.camera);
                                  },
                                  icon: const Icon(UniconsLine.camera),
                                  label: const Text("Select from camera")),
                              TextButton.icon(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    selectImage(
                                        imageSource: ImageSource.gallery);
                                  },
                                  icon: const Icon(UniconsLine.picture),
                                  label: const Text("Select from gallery")),
                            ],
                          ),
                        );
                      });
                },
                icon: const Icon(
                  UniconsLine.camera,
                  color: Colors.grey,
                ),
                label: const Text("Select profile picture",
                    style: TextStyle(
                      color: Colors.grey,
                    )),
              ),
              const SizedBox(
                height: 35,
              ),
              TextFormField(
                style: Theme.of(context).textTheme.caption,
                controller: _nameController,
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(label: Text("Full Name")),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Full Name is required!";
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(label: Text("Email")),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Email is required!";
                  }
                  if (!emailRegEx.hasMatch(value)) {
                    return "email is invalid";
                  }
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _passwordController,
                keyboardType: TextInputType.visiblePassword,
                decoration: const InputDecoration(label: Text("Password")),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "password is required!";
                  }
                  if (value.length < 8) {
                    return "password is weak!";
                  }
                },
              ),
              const SizedBox(
                height: 25,
              ),
              isloading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            // isloading = _authController.isLoading;
                            isloading = true;
                          });
                          //all is sets
                          String name = _nameController.text;
                          String email = _emailController.text;
                          String password = _passwordController.text;
                          bool isCreated = await _authController.createNewUser(
                              name: name,
                              email: email,
                              password: password,
                              imageFile: _imageFile!);
                          setState(() {
                            isloading = false;
                          });
                          if (isCreated) {
                            Fluttertoast.showToast(
                                msg: "Welcome, $name",
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const HomeView()),
                                (route) => false);
                          } else {
                            isloading = false;
                            Fluttertoast.showToast(
                                msg: _authController.message,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        } else {
                          //validation failed
                          Fluttertoast.showToast(
                              msg: "please check input fields",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .background),
                      child: Text(
                        "Create Account",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .primary),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
