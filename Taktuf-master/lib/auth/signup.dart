import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takatuf/auth/code_ver.dart';
import 'package:takatuf/auth/signin.dart';
import 'package:takatuf/components/rec_button.dart';
import 'package:takatuf/components/social.dart';
import 'package:takatuf/components/textform2.dart';
import 'package:takatuf/main.dart';
import 'package:takatuf/theme/fonts.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController phonecontroller = TextEditingController();
  final TextEditingController name = TextEditingController();

  final GlobalKey<FormState> fkey = GlobalKey();
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
    phonecontroller.selection = TextSelection.fromPosition(
        TextPosition(offset: phonecontroller.text.length));
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Form(
            key: fkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Center(
                  child: Text("تسجيل جديد", style: AppFonts.DarkBLue_20),
                ),
                SizedBox(
                  height: 50,
                  child: Padding(
                    padding: EdgeInsets.only(left: 200),
                    child: Container(
                        width: 90,
                        alignment: Alignment.centerRight,
                        child: Text("الخطوة 1 من 3", style: AppFonts.grey_14)),
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Padding(
                      padding: EdgeInsets.only(left: 200),
                      child:
                          Text("أدخل رقم جوالك", style: AppFonts.DarkBLue_16)),
                ),
                SizedBox(
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
                    },
                    onChanged: (value) {
                      setState(() {
                        phonecontroller.text = value;
                      });
                    },
                    keyboardType: TextInputType.number,
                    controller: phonecontroller,
                    decoration: InputDecoration(
                      alignLabelWithHint: EditableText.debugDeterministicCursor,
                      hintText: " رقم الجوال",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey)),
                      suffixIcon: Container(
                        padding: EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            showCountryPicker(
                                context: context,
                                countryListTheme: CountryListThemeData(
                                    bottomSheetHeight: 500),
                                onSelect: (value) {
                                  setState(() {
                                    selectedcountry = value;
                                  });
                                });
                          },
                          child: Text(
                            "${selectedcountry.flagEmoji}+ ${selectedcountry.phoneCode}",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        if (value.length <= 3) {
                          return 'enter valid name';
                        }
                      } else {
                        return 'required';
                      }
                    },
                    onChanged: (value) {
                      setState(() {
                        name.text = value;
                      });
                    },
                    keyboardType: TextInputType.name,
                    controller: name,
                    decoration: InputDecoration(
                      alignLabelWithHint: EditableText.debugDeterministicCursor,
                      hintText: "الاسم",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(10.0),
                //   child: TextFormField(
                //     validator: (value) {
                //       if (value != null && value.isNotEmpty) {
                //         if (value.length != 3) {
                //           return 'enter valid name ';
                //         }
                //       } else {
                //         return 'required';
                //       }
                //     },
                //     onChanged: (value) {
                //       setState(() {
                //         name.text = value;
                //       });
                //     },
                //     keyboardType: TextInputType.name,
                //     controller: name,
                //     decoration: InputDecoration(
                //       alignLabelWithHint: EditableText.debugDeterministicCursor,
                //       hintText: "الاسم ",
                //       enabledBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(10),
                //           borderSide: BorderSide(color: Colors.grey)),
                //       focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(10),
                //           borderSide: BorderSide(color: Colors.grey)),
                //       suffixIcon: Container(
                //         padding: EdgeInsets.all(8.0),
                //         child: InkWell(
                //           onTap: () {},
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 250,
                    ),
                    child: Text("سيصلك رمز تحقق", style: AppFonts.grey_14),
                  ),
                  height: 40,
                ),
                RecButton(
                    fun: () async {
                      if (fkey.currentState!.validate()) {
                        int code =1000 + Random().nextInt(9000);
                        prefs!.setString('code', "$code");
                        print(prefs!.getString('code'));
                        FirebaseFirestore.instance.collection('users').add({
                          "name": name.text,
                          "phone": phonecontroller.text,
                          "code": "$code"
                        }).then((value) async {
                          prefs!.setString('id', value.id);
                          var user = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(value.id)
                              .get();
                          prefs!.setString('name', user['name']);
                          prefs!.setString('phone', user['phone']);
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
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return Code_num(
                                  number: phonecontroller.text,
                                  code: selectedcountry.phoneCode);
                            },
                          ));
                        });
                      }
                    },
                    label: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 75),
                          child: Text(
                            "تحقق",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                        Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    width: 250,
                    height: 50,
                    color: Colors.blueGrey),
                SizedBox(
                  height: 100,
                ),
                Text(
                  "_______________________او_______________________",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 20,
                ),
                SocialLogin(),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "هل لديك حساب؟",
                      style: AppFonts.grey_14,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return Signin();
                          },
                        ));
                      },
                      child: Text(" تسجيل الدخول", style: AppFonts.DarkBLue_16),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
