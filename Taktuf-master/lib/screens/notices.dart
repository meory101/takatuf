import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:takatuf/components/rec_button.dart';
import 'package:takatuf/main.dart';
import 'package:takatuf/screens/edit_notices.dart';
import 'package:takatuf/theme/colors.dart';
import 'package:takatuf/theme/fonts.dart';
 

class Notices extends StatefulWidget {
  const Notices({super.key});

  @override
  State<Notices> createState() => _NoticesState();
}

class _NoticesState extends State<Notices> {
  String? userid = prefs!.getString('id');
  var notices;
  getNotices() async {
    notices = await FirebaseFirestore.instance
        .collection('product')
        .where('userID', isEqualTo: userid)
        .snapshots();

    setState(() {});
  }

  @override
  void initState() {
    getNotices();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Container(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_circle_right_outlined,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: AppColors.DarkBlue,
        toolbarHeight: 150,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(130),
            bottomRight: Radius.circular(130),
          ),
        ),
        title: Container(
          alignment:
              Alignment.lerp(Alignment.topCenter, Alignment.topRight, 0.33),
          child: Text(
            "اعلاناتي",
            style: TextStyle(
                fontSize: 40, color: Colors.white, fontFamily: 'font'),
          ),
        ),
      ),
      body: SafeArea(
          child: StreamBuilder<Object>(
              stream: notices,
              builder: (context, AsyncSnapshot snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 9, vertical: 8),
                                margin:
                                    EdgeInsets.only(top: 10, left: 7, right: 7),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      color:
                                          Color.fromARGB(255, 197, 196, 196)),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        height: 100,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                '${snapshot.data.docs[index].data()['imageurl']}',
                                              ),
                                              fit: BoxFit.cover),
                                          color: const Color.fromARGB(
                                              255, 197, 196, 196),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${snapshot.data.docs[index].data()['title']}',
                                              style: AppFonts.DarkBLue_14,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                              '${snapshot.data.docs[index].data()['content']}',
                                              style: AppFonts.light_grey_12,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: 20, top: 20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Row(
                                                    children: [
                                                      RecButton(
                                                          fun: () async {
                                                            await Navigator.of(
                                                                    context)
                                                                .pushReplacement(
                                                              MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                                  return Edit_notices(
                                                                    data: snapshot
                                                                            .data
                                                                            .docs[
                                                                        index],
                                                                  );
                                                                },
                                                              ),
                                                            );
                                                          },
                                                          label: Text(
                                                            'تعديل',
                                                            style: AppFonts
                                                                .white_14,
                                                          ),
                                                          width: 60,
                                                          height: 30,
                                                          color: AppColors
                                                              .LightBlue),
                                                      Text(
                                                        '',
                                                        style: AppFonts
                                                            .DarkBLue_10,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      RecButton(
                                                          fun: () {
                                                            showuDialog(
                                                                context,
                                                                DialogType
                                                                    .warning,
                                                                'Delete Message',
                                                                'Are you sure you want to delete this post?',
                                                                'ok', () async {
                                                              await FirebaseFirestore
                                                                  .instance
                                                                  .collection(
                                                                      'product')
                                                                  .doc(
                                                                      '${snapshot.data.docs[index].reference.id}')
                                                                  .delete();
                                                            });
                                                          },
                                                          label: Text(
                                                            "حذف",
                                                            style:
                                                                AppFonts.Red_14,
                                                          ),
                                                          width: 60,
                                                          height: 30,
                                                          color: const Color
                                                              .fromARGB(255,
                                                              255, 174, 174)),
                                                      Text(
                                                        '',
                                                        style: AppFonts
                                                            .DarkBLue_10,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        })
                    : snapshot.connectionState == ConnectionState.waiting
                        ? Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.DarkBlue,
                              ),
                            ),
                          )
                        : Center(
                            child: Text(''),
                          );
              })),
    );
  }
}
