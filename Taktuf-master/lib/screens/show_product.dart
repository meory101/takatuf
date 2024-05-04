import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:takatuf/components/rec_button.dart';
import 'package:takatuf/main.dart';
import 'package:takatuf/screens/rooms.dart';
import 'package:takatuf/theme/colors.dart';
import 'package:takatuf/theme/fonts.dart';
 

class ShowProduct extends StatefulWidget {
  var data;
  ShowProduct({required this.data});
  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  String? currentUserID = prefs!.getString('id');
  var userdata1;
  var userdata2;
  CreateRoom() async {
    print('creating room');
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
    var r1 = await FirebaseFirestore.instance
        .collection('rooms')
        .where('userid2', isEqualTo: currentUserID)
        .where('userid1', isEqualTo: widget.data['userID'])
        .get();
    var r2 = await FirebaseFirestore.instance
        .collection('rooms')
        .where('userid1', isEqualTo: currentUserID)
        .where('userid2', isEqualTo: widget.data['userID'])
        .get();

    if (r1.docs.isEmpty && r2.docs.isEmpty) {
      print('empty');
      print('${widget.data}');
       userdata1 = await FirebaseFirestore.instance
          .collection('users')
          .doc('${widget.data['userID']}')
          .get();

       userdata2 = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserID)
          .get();
    

      print(userdata2);
      print(userdata1);
      return await FirebaseFirestore.instance.collection('rooms').add({
        'userid1': widget.data['userID'],
        'userid2': currentUserID,
        'username1': userdata1.data()!['name']??'',
        'username2': userdata2.data()!['name']??'',
        'imageurl1': userdata1.data()!['imageurl'],
        'imageurl2': userdata2.data()!['imageurl'],
      }).then((value) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
          builder: (context) {
            return Rooms(
              r1: r1,
              r2: r2,
            );
          },
        ), (route) => false);
      }).onError((error, stackTrace) {
        Navigator.of(context).pop();
        showuDialog(context, DialogType.error, 'Error', 'something went wrong',
            '', () {});
      });
    } else {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
        builder: (context) {
          return Rooms(
            r1: r1,
            r2: r2,
          );
        },
      ), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            RecButton(
                fun: CreateRoom,
                label: Text(
                  "مراسلة",
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'font', fontSize: 17),
                ),
                width: 120,
                height: 40,
                color: AppColors.DarkBlue),
            RecButton(
                fun: () {},
                label: Text(
                  "اتصال",
                  style: TextStyle(
                      color: Colors.white, fontFamily: 'font', fontSize: 17),
                ),
                width: 120,
                height: 40,
                color: AppColors.DarkBlue),
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Container(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.arrow_circle_right_outlined,
              color: AppColors.DarkBlue,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              alignment: Alignment.topCenter,
              height: 50,
              child: Icon(
                Icons.more_horiz,
                color: AppColors.DarkBlue,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    widget.data['imageurl'],
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Card(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 7),
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.DarkBlue,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            bottomRight: Radius.circular(15),
                          ),
                        ),
                        child: Text(
                          widget.data['title'],
                          style: AppFonts.white_14,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text(
                            widget.data['date'],
                            style: AppFonts.DarkBLue_10,
                          ),
                          Text(
                            '',
                            style: AppFonts.DarkBLue_10,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              widget.data['content'],
              style: AppFonts.grey_14,
            ),
          ],
        ),
      ),
    );
  }
}
