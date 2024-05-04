import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:takatuf/components/textform2.dart';
import 'package:takatuf/main.dart';
 
import '../theme/colors.dart';
import '../theme/fonts.dart';

//done 1 MAY 2024 nour
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController phonecontroller = TextEditingController();
  var profileImageUrl;
  getImage() async {
    print('${prefs!.getString('id')}');
    profileImageUrl = await FirebaseFirestore.instance
        .collection('users')
        .doc('${prefs!.getString('id')}')
        .get();
    print(profileImageUrl.data()['imageurl']);
    setState(() {});
  }

  @override
  void initState() {
    getImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<String> title = ['اسم المستخدم', 'الجوال', ''];
    List<String> data = [
      prefs!.getString('name').toString(),
      prefs!.getString('phone').toString(),
      'حذف الحساب'
    ];
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 50,
                      width: 60,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/images/logo1.jpg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Text(
                          'تكاتف',
                          style: AppFonts.DarkBLue_14,
                        ),
                        Text(
                          'takatuf',
                          style: AppFonts.DarkBLue_14,
                        ),
                      ],
                    ),
                  ],
                ),
                notification(context)
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border:
                              Border.all(color: AppColors.DarkBlue, width: 2),
                        ),
                        child: profileImageUrl == null ||
                                profileImageUrl.data()['imageurl'] == null
                            ? const CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage:
                                    AssetImage('assets/images/profile.png'),
                                radius: 70,
                              )
                            : CircleAvatar(
                                backgroundColor: Colors.grey,
                                backgroundImage: NetworkImage(
                                    profileImageUrl.data()['imageurl']),
                                radius: 70,
                              ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.DarkBlue,
                          child: IconButton(
                            onPressed: () async {
                              File file;
                              var image = await ImagePicker.platform
                                  .getImageFromSource(
                                      source: ImageSource.gallery);
                              if (image != null) {
                                showAdaptiveDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.transparent,
                                        title: Center(
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                                color: AppColors.DarkBlue),
                                          ),
                                        ),
                                      );
                                    });
                                if (profileImageUrl.data()['imageurl']!=null){
                                  await FirebaseStorage.instance
                                      .refFromURL(
                                          profileImageUrl.data()['imageurl'])
                                      .delete();
                                }
                                  file = File(image.path);
                               
                                var ref = FirebaseStorage.instance
                                    .ref('images')
                                    .child(basename(file.path));
                                await ref.putFile(file);
                                var imageurl = await ref.getDownloadURL();
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(prefs!.getString('id'))
                                    .set({
                                  'imageurl': imageurl,
                                }, SetOptions(merge: true)).then((value) async {
                                  Navigator.of(context).pop();
                                  getImage();
                                });
                              }
                            },
                            icon: const Icon(
                              Icons.edit,
                              size: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Text(
                                title[index],
                                style: AppFonts.DarkBLue_14,
                                textAlign: TextAlign.right,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Textform(
                              readonly: true,
                              text: data[index],
                              style: index == 2
                                  ? AppFonts.Red_14
                                  : AppFonts.DarkBLue_14,
                              textInputType: TextInputType.text,
                              obscure: index == 1 ? true : false,
                              height: 40,
                              width: double.infinity,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
