import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:takatuf/components/rec_button.dart';
import 'package:takatuf/theme/colors.dart';
import 'package:takatuf/theme/fonts.dart';

class Catgories extends StatefulWidget {
  const Catgories({super.key});

  @override
  State<Catgories> createState() => _CatgoriesState();
}

class _CatgoriesState extends State<Catgories> {
  var categories;
  getCategories() async {
    categories =
        await FirebaseFirestore.instance.collection('category').snapshots();

    print(id);
    setState(() {});
  }

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  int selected = 0;
  String id = "1";
  String? name;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            "الاقسام",
            style: TextStyle(
                fontSize: 40, color: Colors.white, fontFamily: 'font'),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 2,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 40),
                child: StreamBuilder<Object>(
                  stream: categories,
                  builder: (context, AsyncSnapshot snapshot) {
                    return snapshot.hasData
                        ? GridView.builder(
                            itemCount: snapshot.data.docs.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 10,
                                    crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  selected = index;
                                  id = snapshot.data.docs[index].reference.id;

                                  name =
                                      snapshot.data.docs[index].data()['name'];
                                  setState(() {});
                                },
                                child: Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    '${snapshot.data.docs[index].data()['name']}',
                                    style: AppFonts.DarkBLue_14,
                                  ),
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            "assets/images/${index}.jpg")),
                                    borderRadius: BorderRadius.circular(20),
                                    color: selected == index
                                        ? Colors.grey
                                        : Color.fromARGB(255, 203, 203, 203),
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(
                            child: SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.DarkBlue,
                              ),
                            ),
                          );
                  },
                ),
              ),
              RecButton(
                  fun: () {
                    Navigator.of(context).pop('${id}' + '/' + '${name}');
                  },
                  label: Text(
                    'اختيار',
                    style: AppFonts.white_14,
                  ),
                  width: 200,
                  height: 50,
                  color: AppColors.DarkBlue)
            ],
          ),
        ),
      ),
    );
  }
}
