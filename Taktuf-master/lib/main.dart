import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takatuf/auth/signin.dart';
import 'package:takatuf/auth/signup.dart';
import 'package:takatuf/onboardingscreen/intro_page1.dart';
import 'package:takatuf/onboardingscreen/onboardingscreen.dart';
import 'package:takatuf/screens/tab_bar.dart';
import 'package:takatuf/theme/colors.dart';
import 'package:takatuf/theme/fonts.dart';

import 'screens/notifications.dart';

SharedPreferences? prefs;

extension Validation on String {
  Check50() {
    return this.length > 50;
  }

  Check500() {
    return this.length > 500;
  }

  CheckEmpty() {
    return this.isEmpty;
  }
}

showuDialog(context, type, title, content, oktext, btnOkOnPress) {
  return AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.rightSlide,
      title: title,
      btnOkText: oktext ?? oktext,
      btnCancelText: 'cancle',
      btnCancelColor: const Color.fromARGB(255, 206, 206, 206),
      btnCancelOnPress: () {},
      btnOkColor: AppColors.DarkBlue,
      btnOkOnPress: btnOkOnPress ?? btnOkOnPress,
      titleTextStyle: AppFonts.DarkBLue_14,
      desc: content,
      descTextStyle: AppFonts.grey_12)
    ..show();
}

Widget notification(context) {
  return IconButton(
    onPressed: () {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) {
          return NotificationScreen();
        },
      ));
    },
    icon: Icon(
      Icons.notifications,
      color: AppColors.DarkBlue,
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: "AIzaSyBDdaYmrzCLj0pP0MOoHvJlCk_WKxHEkPw",
    appId: "1:406071565272:android:cd0a48e7ffb72f32f6f0ad",
    messagingSenderId: "406071565272",
    projectId: "takatuf-d55a2",
    storageBucket: "takatuf-d55a2.appspot.com",
  ));
  runApp(MyApp());
}

var categories;
List<String> categoryName = ['الكل'];

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    getCatgories();
    super.initState();
  }

  getCatgories() async {
    print('getting categories');
    categories = await FirebaseFirestore.instance.collection('category').get();
    for (int i = 0; i < categories.docs.length; i++) {
      categoryName.add(
        categories.docs[i]['name'],
      );
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale("ar"),
      ],
      locale: Locale("ar"),
      // home: Signup(),
      home:
          prefs!.getString('id') != null ? CustomBottomTabBar() : intro_page1(),
    );
  }
}
