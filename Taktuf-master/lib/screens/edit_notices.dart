import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:takatuf/components/rec_button.dart';
import 'package:takatuf/components/textform2.dart';
import 'package:takatuf/main.dart';
import 'package:takatuf/screens/notices.dart';
import 'package:takatuf/theme/colors.dart';
import 'package:takatuf/theme/fonts.dart';
 

class Edit_notices extends StatefulWidget {
  var data;
  Edit_notices({required this.data});
  @override
  State<Edit_notices> createState() => _Edit_noticesState();
}

class _Edit_noticesState extends State<Edit_notices> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController title =
        TextEditingController(text: widget.data['title']);
    final TextEditingController content =
        TextEditingController(text: widget.data['content']);
    final TextEditingController number =
        TextEditingController(text: widget.data['number']);
    GlobalKey<FormState> fkey = GlobalKey();

    editProduct() async {
      if (fkey.currentState!.validate()) {
        await FirebaseFirestore.instance
            .collection('product')
            .doc(widget.data.reference.id)
            .set({
          "title": title.text,
          "content": content.text,
          "number": number.text,
        }, SetOptions(merge: true)).then((value) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return Notices();
            },
          ));
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_circle_right_outlined,
              color: AppColors.DarkBlue,
            )),
        title: Container(
          padding: EdgeInsets.all(80),
          child: Text(
            ' تعديل الاعلان',
            style: AppFonts.DarkBLue_16,
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
                    'عنوان الاعلان',
                    style: AppFonts.DarkBLue_16,
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
                    style: AppFonts.DarkBLue_16,
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
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        'رقم الجوال',
                        style: AppFonts.DarkBLue_16,
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
                          editProduct();
                        },
                        label: Text(
                          "تعديل",
                          style: TextStyle(color: Colors.white, fontSize: 20),
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
