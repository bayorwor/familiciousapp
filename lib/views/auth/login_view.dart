import 'package:familicious_app/controllers/auth_controller.dart';
import 'package:familicious_app/views/auth/create_account_view.dart';
import 'package:familicious_app/views/auth/forgot_password_view.dart';
import 'package:familicious_app/views/home/home_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final emailRegEx = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final AuthController _authController = AuthController();

  bool isloading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              FlutterLogo(
                size: 130,
              ),
              TextFormField(
                style: TextStyle(
                    color: Theme.of(context).textTheme.caption!.color),
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
                style: TextStyle(
                    color: Theme.of(context).textTheme.caption!.color),
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
              SizedBox(
                height: 35,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordView())),
                    child: Text(
                      "Forgot password? Reset here!",
                      style: TextStyle(color: Colors.grey),
                    )),
              ),
              isloading
                  ? const Center(child: CircularProgressIndicator.adaptive())
                  : TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isloading = true;
                          });
                          bool isSucccessful = await _authController.loginUser(
                              email: _emailController.text,
                              password: _passwordController.text);
                          setState(() {
                            isloading = false;
                          });
                          if (isSucccessful) {
                            Fluttertoast.showToast(
                                msg: "Welcome to Familicious!",
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
                        "Login",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            color: Theme.of(context)
                                .buttonTheme
                                .colorScheme!
                                .primary),
                      ),
                    ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => CreateAccountView())),
                    child: Text(
                      "I am new here? create account",
                      style: TextStyle(color: Colors.grey),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
