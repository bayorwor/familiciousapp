import 'package:familicious_app/views/auth/create_account_view.dart';
import 'package:familicious_app/views/auth/login_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:familicious_app/views/home/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // light mode
      theme: ThemeData(
          iconTheme: const IconThemeData(color: Colors.black),
          scaffoldBackgroundColor: Colors.white,
          cardColor: Colors.white,
          bottomNavigationBarTheme:
              const BottomNavigationBarThemeData(backgroundColor: Colors.white),
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            elevation: 0,
            backgroundColor: Colors.white,
            titleTextStyle: TextStyle(
                color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          textTheme: const TextTheme(
            bodyText1: TextStyle(color: Colors.black),
            bodyText2: TextStyle(color: Colors.black),
          ),
          buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.dark(primary: Colors.white),
              textTheme: ButtonTextTheme.primary),
          inputDecorationTheme: const InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)),
              labelStyle: TextStyle(color: Colors.black))),
      //dark mode
      darkTheme: ThemeData(
          iconTheme: const IconThemeData(color: Colors.white),
          scaffoldBackgroundColor: Colors.black,
          cardColor: Colors.black26,
          bottomNavigationBarTheme:
              const BottomNavigationBarThemeData(backgroundColor: Colors.black),
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0,
            backgroundColor: Colors.black,
            titleTextStyle: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          textTheme: const TextTheme(
            bodyText1: TextStyle(color: Colors.white),
            bodyText2: TextStyle(color: Colors.white),
            caption: TextStyle(color: Colors.white),
          ),
          buttonTheme: const ButtonThemeData(
              colorScheme: ColorScheme.light(primary: Colors.black),
              textTheme: ButtonTextTheme.primary),
          inputDecorationTheme: const InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              labelStyle: TextStyle(color: Colors.white))),

      themeMode: ThemeMode.system,
      // home: const HomeView(),
      home: HomeView(),
    );
  }
}
