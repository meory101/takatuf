import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takatuf/components/rec_button.dart';
import 'package:takatuf/onboardingscreen/intro_page2.dart';
import 'package:takatuf/theme/fonts.dart';

class intro_page1 extends StatefulWidget {
  const intro_page1({super.key});

  @override
  State<intro_page1> createState() => _intro_page1State();
}

class _intro_page1State extends State<intro_page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Container(
                child: Image(
                  image: AssetImage("assets/images/a.jpg"),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text("قيم انسانية", style: AppFonts.DarkBLue_20),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "مرحبا بك في تطبيق تكاتف حيث نسعى حميعا الى تعزيز القيم الانسانية وبناء مجتمع مترابط في عالمنا المتسارع ونؤمن باهمية التلاحم والتعاون",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontFamily: 'font'),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              ),
              RecButton(
                  fun: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) {
                        return intro_page2();
                      },
                    ));
                  },
                  label: Center(
                    child: Text(
                      "البدء",
                      style: TextStyle(
                          fontSize: 17,
                          fontFamily: 'font',
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  width: 250,
                  height: 50,
                  color: Colors.blueGrey)
            ],
          ),
        ),
      ),
    );
  }
}
