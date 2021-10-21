import 'package:familicious_app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordView extends StatefulWidget {
  ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();

  bool isloading = false;

  final emailRegEx = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final AuthController _authController = AuthController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FlutterLogo(
              size: 130,
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
            SizedBox(
              height: 40,
            ),
            isloading
                ? const Center(child: CircularProgressIndicator.adaptive())
                : TextButton(
                    onPressed: () async {
                      if (_emailController.text.isNotEmpty &&
                          emailRegEx.hasMatch(_emailController.text)) {
                        setState(() {
                          isloading = true;
                        });
                        bool isSent = await _authController
                            .sendResetLink(_emailController.text);
                        setState(() {
                          isloading = true;
                        });
                        if (isSent) {
                          Fluttertoast.showToast(
                              msg: "email sent, please verify",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.green,
                              textColor: Colors.white,
                              fontSize: 16.0);

                          Navigator.pop(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: _authController.message,
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0);
                          isloading = false;
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "invalid email",
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
                      "Reset Password",
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
    );
  }
}
