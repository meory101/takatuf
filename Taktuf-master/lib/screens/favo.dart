import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:takatuf/components/rec_button.dart';
import 'package:takatuf/main.dart';
import 'package:takatuf/theme/colors.dart';
import 'package:takatuf/theme/fonts.dart';

class Favo extends StatefulWidget {
  const Favo({super.key});

  @override
  State<Favo> createState() => _FavoState();
}

class _FavoState extends State<Favo> {
 String? userid = prefs!.getString('id');
  Stream<QuerySnapshot<Object?>>? Favo;

  getFavo() async {
    var list = prefs!.getStringList('fav') ?? [];

    List<Stream<DocumentSnapshot>> documentStreams = [];

    for (var documentId in list) {
      Stream<DocumentSnapshot> documentStream = FirebaseFirestore.instance
          .collection('product')
          .doc(documentId)
          .snapshots();
      documentStreams.add(documentStream);
    }

    Favo = Rx.merge(documentStreams);

    print('fffffffffffffffff');
    print(Favo);
    setState(() {});
  }
  @override
  void initState() {
    getFavo();
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
            "المفضلة",
            style: TextStyle(
                fontSize: 40, color: Colors.white, fontFamily: 'font'),
          ),
        ),
      ),
     body: SafeArea(
  child: StreamBuilder<QuerySnapshot>(
    stream: Favo,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: Text('Error: ${snapshot.error}'),
        );
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(
            color: AppColors.DarkBlue,
          ),
        );
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return Center(
          child: Text('No data available'),
        );
      }

      return ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (context, index) {
          var document = snapshot.data!.docs[index];
          return Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                margin: EdgeInsets.only(top: 10, left: 7, right: 7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Color.fromARGB(255, 197, 196, 196)),
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
                            image: NetworkImage(document['imageurl']),
                            fit: BoxFit.cover,
                          ),
                          color: const Color.fromARGB(255, 197, 196, 196),
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              document['title'],
                              style: AppFonts.DarkBLue_14,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 7),
                            Text(
                              document['content'],
                              style: AppFonts.light_grey_12,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    },
  ),
));
  }}