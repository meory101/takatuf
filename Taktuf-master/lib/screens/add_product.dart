import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:takatuf/components/rec_button.dart';
import 'package:takatuf/components/textform2.dart';
import 'package:takatuf/main.dart';
import 'package:takatuf/screens/categories.dart';
import 'package:takatuf/screens/map.dart';
import 'package:takatuf/screens/notices.dart';
import 'package:takatuf/theme/colors.dart';
import 'package:takatuf/theme/fonts.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String? categoryID;
  String? lat;
  String? long;
  File? file;
  var image;
  TextEditingController title = TextEditingController();
  TextEditingController controller = TextEditingController();

  TextEditingController content = TextEditingController();
  TextEditingController number = TextEditingController();
  GlobalKey<FormState> fkey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    addProduct() async {
      print(fkey.currentState!.validate());
      if (fkey.currentState!.validate() &&
          file != null &&
          categoryID != null &&
          lat != null) {
        showAdaptiveDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                title: Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(color: AppColors.DarkBlue),
                  ),
                ),
              );
            });
        var ref =
            FirebaseStorage.instance.ref('images').child(basename(image.path));
        await ref.putFile(file!).then((p0) async {
          var imageUrl = await ref.getDownloadURL();
          await FirebaseFirestore.instance.collection('product').add({
            "categoryID": categoryID,
            "title": title.text,
            "content": content.text,
            "date": "${Jiffy.now().MMMEd}",
            "imageurl": "${imageUrl}",
            "lat": lat,
            "long": long,
            "number": number.text,
            "userID": prefs!.getString('id')
          });
        }).then((value) {
          Navigator.of(context).pop();
          String? o;
          lat = o;
          categoryID = o;
          setState(() {});
          controller.clear();

          title.clear();
          content.clear();
          number.clear();
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return Notices();
            },
          ));
        });
      } else {
        showuDialog(context, DialogType.error, 'Validation error',
            'All fields are required', 'ok', () {});
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Container(
          padding: EdgeInsets.all(80),
          child: Text(
            'اضافة اعلان',
            style: AppFonts.DarkBLue_14,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 30, left: 8, right: 8),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: fkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'القسم',
                    style: AppFonts.DarkBLue_14,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Textform(
                        style: AppFonts.grey_12,
                        controller: controller,
                        text: '',
                        textInputType: TextInputType.text,
                        obscure: false,
                        // height: 40,
                        width: MediaQuery.of(context).size.width / 1.4,
                        readonly: true,
                      ),
                      IconButton(
                        onPressed: () async {
                          var data = await Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) {
                              return Catgories();
                            },
                          ));
                          if (data != null) {
                            categoryID = data.split('/')[0];
                            controller.text = data.split('/')[1];
                          }
                        },
                        icon: Container(
                          padding: EdgeInsets.only(
                            right: 10,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: AppColors.DarkBlue,
                            size: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'الموقع',
                    style: AppFonts.DarkBLue_14,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Textform(
                        text: lat != null ? 'تم اختيار الموقع' : '',
                        textInputType: TextInputType.text,
                        obscure: false,
                        width: MediaQuery.of(context).size.width / 1.4,
                        readonly: true,
                      ),
                      IconButton(
                        onPressed: () async {
                          var latlong = await Navigator.of(context)
                              .push(MaterialPageRoute(
                            builder: (context) {
                              return AppMap();
                            },
                          ));
                          if (latlong != null) {
                            lat = latlong.split('/')[0];
                            long = latlong.split('/')[1];
                            setState(() {});
                          }
                        },
                        icon: Icon(
                          Icons.location_on_outlined,
                          color: AppColors.DarkBlue,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'عنوان الاعلان',
                    style: AppFonts.DarkBLue_14,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Textform(
                    val: (p0) {
                      if (p0 != null && p0.isNotEmpty) {
                        if (p0.Check50()) {
                          return "max 50";
                        }
                      } else {
                        return 'rquired';
                      }
                    },
                    controller: title,
                    text: '',
                    textInputType: TextInputType.text,
                    obscure: false,
                    style: AppFonts.grey_12,
                    width: double.infinity,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'وصف الاعلان',
                    style: AppFonts.DarkBLue_14,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Textform(
                    val: (p0) {
                      if (p0 != null && p0.isNotEmpty) {
                        if (p0.Check500()) {
                          return "max 500";
                        }
                      } else {
                        return 'rquired';
                      }
                    },
                    controller: content,
                    style: AppFonts.grey_12,
                    text: '',
                    textInputType: TextInputType.text,
                    obscure: false,
                    minlines: 3,
                    width: double.infinity,
                    readonly: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'الصور',
                        style: AppFonts.DarkBLue_14,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 80,
                      child: IconButton(
                        onPressed: () async {
                          image = await ImagePicker.platform
                              .getImageFromSource(source: ImageSource.gallery);
                          if (image != null) {
                            file = File(image.path);
                          }
                        },
                        icon: Column(
                          children: [
                            Container(
                              child: Icon(
                                Icons.add_photo_alternate_outlined,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Center(
                                child: Text(
                              "اضافة صورة",
                              style: AppFonts.grey_12,
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'رقم الجوال',
                        style: AppFonts.DarkBLue_14,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '(اختياري)',
                        style: AppFonts.grey_12,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Textform(
                    controller: number,
                    style: AppFonts.grey_12,
                    text: '',
                    textInputType: TextInputType.number,
                    obscure: false,
                    width: double.infinity,
                    readonly: false,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: RecButton(
                        fun: () {
                          addProduct();
                        },
                        label: Text(
                          "اضافة",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'font',
                              fontSize: 17),
                        ),
                        width: 150,
                        height: 40,
                        color: AppColors.DarkBlue),
                  )
                ],
              ),
            ),
          ),
        )),
      ),
    );
  }
}
