import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:get/get.dart';
import 'package:takatuf/main.dart';
import 'package:takatuf/screens/tab_bar.dart';
import 'package:takatuf/theme/fonts.dart';

class Code_num extends StatefulWidget {
  final String number;
  final String code;
  const Code_num({super.key, required this.number, required this.code});
  @override
  State<Code_num> createState() => _Code_numState();
}

TextEditingController enteredCode = TextEditingController();

class _Code_numState extends State<Code_num> {
  String? vid;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    enteredCode.clear();
    super.initState();
  }

  showDialog() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset("assets/images/logo1.jpg"),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Text(
                  "الخطوة 2 من 3",
                  style: AppFonts.grey_14,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 1),
                child: Text(
                  "التوثيق",
                  style: AppFonts.DarkBLue_20,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 1),
                child: Text(
                  "ادخل الرقم المرسل هنا",
                  style: AppFonts.grey_14,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Pinput(
              controller: enteredCode,
              length: 4,
              showCursor: true,
              autofocus: true,
              onCompleted: (value) async {
                String? code = prefs!.getString("code");
                if (code == value) {
                  Get.closeAllSnackbars();
                  enteredCode.clear();
                  print(enteredCode);
                  setState(() {});
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) {
                      return CustomBottomTabBar();
                    },
                  ));
                } else {
                  Get.closeAllSnackbars();
                  Get.snackbar('', '',
                      duration: const Duration(seconds: 2),
                      // backgroundColor: const Csolor.fromARGB(255, 195, 195, 195),
                      titleText: const Text(
                        'Please enter valide code',
                      ),
                      messageText: Text(
                        '',
                      ),
                      snackPosition: SnackPosition.TOP);
                  Navigator.of(context).pop();
                }
              },
              defaultPinTheme: PinTheme(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.blueGrey,
                  )),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  " لم يصلك الرمز ؟",
                  style: AppFonts.light_grey_12,
                ),
                Text("اعادة الارسال", style: AppFonts.grey_14),
              ],
            ),
          ],
        )),
      ),
    );
  }
}
