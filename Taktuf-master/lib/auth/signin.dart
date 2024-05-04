import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takatuf/auth/code_ver.dart';
import 'package:takatuf/auth/signup.dart';
import 'package:takatuf/components/rec_button.dart';
import 'package:takatuf/components/social.dart';
import 'package:takatuf/main.dart';
import 'package:takatuf/theme/fonts.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final TextEditingController phonecontroller = TextEditingController();
  Country selectedcountry = Country(
      phoneCode: "963",
      countryCode: "syria",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "saudi",
      example: "saudi",
      displayName: "saudi",
      displayNameNoCountryCode: "sa",
      e164Key: "");
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> fkey = GlobalKey();

    phonecontroller.selection = TextSelection.fromPosition(
        TextPosition(offset: phonecontroller.text.length));
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Form(
            key: fkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  width: 250,
                  height: 250,
                  child: Center(
                      child:
                          Image(image: AssetImage("assets/images/logo1.jpg"))),
                ),
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Container(
                        width: 150,
                        height: 100,
                        alignment: Alignment.center,
                        child: Text(" تسجيل الدخول  ",
                            style: AppFonts.DarkBLue_20)),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (value.length != 9) {
                          return 'enter valid number';
                        }
                      } else {
                        return 'required';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      phonecontroller.text = value;
                    },
                    keyboardType: TextInputType.number,
                    controller: phonecontroller,
                    decoration: InputDecoration(
                      hintText: " ...رقم الجوال",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      // suffixIcon: phonecontroller.text.length > 9
                      //     ? Container(
                      //         height: 30,
                      //         width: 30,
                      //         decoration: BoxDecoration(
                      //           shape: BoxShape.circle,
                      //           color: Colors.green,
                      //         ),
                      //         child: Icon(
                      //           Icons.done,
                      //           color: Colors.white,
                      //           size: 20,
                      //         ),
                      //       )
                      //     : null,
                      suffixIcon: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                                context: context,
                                countryListTheme: const CountryListThemeData(
                                    bottomSheetHeight: 500),
                                onSelect: (value) {
                                  setState(() {
                                    selectedcountry = value;
                                  });
                                });
                          },
                          child: Text(
                            "${selectedcountry.flagEmoji}+ ${selectedcountry.phoneCode}",
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                  "_______________________او_______________________",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 50,
                ),
                const SocialLogin(),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "هل لا تملك  حساب؟",
                      style: AppFonts.grey_14,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return Signup();
                          },
                        ));
                      },
                      child: Text(" انشاء حساب", style: AppFonts.DarkBLue_16),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                RecButton(
                    fun: () async {
                      if (fkey.currentState!.validate()) {
                        int code = Random().nextInt(10000);
                        prefs!.setString('code', "$code");
                        print(prefs!.getString('code'));
                        var user = await FirebaseFirestore.instance
                            .collection('users')
                            .where("phone", isEqualTo: phonecontroller.text)
                            .get();
                        print(user.docs.length);
                        if (user.docs.length > 0) {
                          print('ffffffffffff');
                          prefs!.setString('id', user.docs[0].reference.id);
                          prefs!.setString('name', user.docs[0].data()['name']);
                          prefs!
                              .setString('phone', user.docs[0].data()['phone']);

                          Get.snackbar('', '',
                              duration: const Duration(seconds: 4),
                              // backgroundColor: const Csolor.fromARGB(255, 195, 195, 195),
                              titleText: const Text(
                                'Verification code',
                              ),
                              messageText: Text(
                                '$code',
                              ),
                              snackPosition: SnackPosition.TOP);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return Code_num(
                                    number: phonecontroller.text,
                                    code: selectedcountry.phoneCode);
                              },
                            ),
                          );
                        } else {
                          print('else');
                          Get.snackbar('', '',
                              duration: const Duration(seconds: 2),
                              // backgroundColor: const Csolor.fromARGB(255, 195, 195, 195),
                              titleText: const Text(
                                'please sign up ',
                              ));
                        }
                      }
                    },
                    label: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "دخول",
                          style: TextStyle(color: Colors.white, fontSize: 30),
                        ),
                      ],
                    ),
                    width: 250,
                    height: 50,
                    color: Colors.blueGrey),
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
