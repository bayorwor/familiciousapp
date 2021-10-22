import 'dart:io';

import 'package:familicious_app/controllers/post_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:unicons/unicons.dart';

class CreatePostView extends StatefulWidget {
  const CreatePostView({Key? key}) : super(key: key);

  @override
  State<CreatePostView> createState() => _CreatePostViewState();
}

class _CreatePostViewState extends State<CreatePostView> {
  final PostController _postController = PostController();

  final TextEditingController _postTxtController = TextEditingController();

  final ImagePicker _imagePicker = ImagePicker();

  bool isLoading = false;

  File? _imagePostFile;

  selectImage(ImageSource imageSource) async {
    XFile? selectedFile = await _imagePicker.pickImage(source: imageSource);
    setState(() {
      _imagePostFile = File(selectedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create a post",
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        actions: [
          isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : TextButton(
                  onPressed: () async {
                    if (_imagePostFile != null) {
                      setState(() {
                        isLoading = true;
                      });
                      bool isSubmitted = await _postController.createPost(
                          postImage: _imagePostFile!,
                          description: _postTxtController.text);
                      setState(() {
                        isLoading = true;
                      });
                      if (isSubmitted) {
                        Fluttertoast.showToast(
                            msg: _postController.message,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pop(context);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "no image selected",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: const Text("Post"))
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Please select an image"),
          const SizedBox(
            height: 20,
          ),
          InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              selectImage(ImageSource.camera);
                            },
                            icon: const Icon(UniconsLine.camera),
                            label: const Text("Select from camera"),
                          ),
                          const Divider(),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              selectImage(ImageSource.gallery);
                            },
                            icon: const Icon(UniconsLine.picture),
                            label: const Text("Select from gallery"),
                          ),
                        ],
                      );
                    });
              },
              child: _imagePostFile == null
                  ? Image.asset(
                      "assets/placeholder.jpeg",
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      _imagePostFile!,
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                    )),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: _postTxtController,
            minLines: 3,
            maxLines: 10,
            decoration: InputDecoration(
                hintText: "post description here",
                hintStyle: const TextStyle(color: Colors.grey),
                label: Text(
                  "Description",
                  style: Theme.of(context).textTheme.bodyText1,
                )),
          ),
        ],
      ),
    );
  }
}
