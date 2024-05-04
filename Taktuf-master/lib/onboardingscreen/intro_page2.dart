import 'package:flutter/material.dart';
import 'package:takatuf/auth/signup.dart';
import 'package:takatuf/components/rec_button.dart';
import 'package:takatuf/onboardingscreen/intro_page3.dart';
 

class intro_page2 extends StatefulWidget {
  const intro_page2({super.key});

  @override
  State<intro_page2> createState() => _intro_page2State();
}

class _intro_page2State extends State<intro_page2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            Container(
              // child: Text("soso"),
              child: Image(image: AssetImage("assets/images/b.jpg")),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      "خيرك يحيي غيرك ",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'font',
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                        "ويبقى السؤال لماذا نتخلص من شيء له قيمة عند شخص اخر يوفر التطيسق حلولا اقتصادية وبيئية للاستفادة من ثروات مهدرة تخدم وطننا الغالي",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'font',
                            color: Colors.grey)),
                  ),
                  SizedBox(
                    height: 180,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment(0, 0.50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 20,
                  ),
                  RecButton(
                      fun: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) {
                            return intro_page3();
                          },
                        ));
                      },
                      label: Text(
                        "التالي",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'font',
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      width: 120,
                      height: 50,
                      color: Colors.blueGrey),
                  SizedBox(
                    width: 100,
                  ),
                  RecButton(
                      fun: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) {
                            return Signup();
                          },
                        ));
                      },
                      label: Text(
                        "تخطي",
                        style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'font',
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey),
                      ),
                      width: 120,
                      height: 50,
                      color: Colors.white),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
