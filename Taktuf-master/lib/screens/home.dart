import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:takatuf/main.dart';
import 'package:takatuf/screens/show_map.dart';
import 'package:takatuf/screens/show_product.dart';

import '../theme/colors.dart';
import '../theme/fonts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getCatgories();
    getProducts();
    super.initState();
  }

  var categories;
  List<String> categoryName = ['الكل'];
  int selected = 0;

  getCatgories() async {
    print('getting categories');
    categories = await FirebaseFirestore.instance.collection('category').get();
    for (int i = 0; i < categories.docs.length; i++) {
      categoryName.add(
        categories.docs[i]['name'],
      );
    }
    print(categoryName.length);

    if (!mounted) return;
    setState(() {});
  }

  var products;
  getProducts() async {
    products = selected == 0
        ? await FirebaseFirestore.instance.collection('product').snapshots()
        : await FirebaseFirestore.instance
            .collection('product')
            .where('categoryID', isEqualTo: selected.toString())
            .snapshots();

    print(products);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
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
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/logo1.jpg'),
                                    fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Text(
                                'تكاتف',
                                style: AppFonts.DarkBLue_16,
                              ),
                              Text(
                                'takatuf',
                                style: AppFonts.DarkBLue_16,
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
            )),
        body: categoryName.length == 1
            ? Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: AppColors.DarkBlue,
                  ),
                ),
              )
            : SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    margin: EdgeInsets.only(top: 20, bottom: 30),
                    child: Column(
                      children: [
                        categoryName.length == 1
                            ? Text('')
                            : Container(
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                height: 30,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categoryName.length,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        selected = index;
                                        getProducts();
                                        setState(() {});
                                        print(selected);
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                              bottom: BorderSide(
                                                  color: index == selected
                                                      ? AppColors.DarkBlue
                                                      : Colors.transparent,
                                                  width: 3),
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(categoryName[index],
                                              style: AppFonts.DarkBLue_14)),
                                    );
                                  },
                                ),
                              ),
                        SizedBox(
                          height: 20,
                        ),
                        StreamBuilder(
                          stream: products,
                          builder: (context, AsyncSnapshot snapshot) {
                            return snapshot.hasData
                                ? ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data.docs.length,
                                    itemBuilder: (context, index) {
                                      return Stack(
                                        children: [
                                          InkWell(
                                              onTap: () {
                                                if ((prefs!
                                                        .getStringList("fav")
                                                        ?.contains(snapshot
                                                            .data
                                                            .docs[index]
                                                            .reference
                                                            .id) ??
                                                    false)) {
                                                    var list = prefs!
                                                          .getStringList('fav') ??
                                                      [];
                                                  list.remove(
                                                      '${snapshot.data.docs[index].reference.id}');
                                                  prefs!
                                                      .setStringList("fav", list);
                                                } else {
                                                  var list = prefs!
                                                          .getStringList('fav') ??
                                                      [];
                                                  list.add(
                                                      '${snapshot.data.docs[index].reference.id}');
                                                  prefs!
                                                      .setStringList("fav", list);
                                                 
                                                }
                                            
                                                setState(() {});
                                              },
                                              child: Icon(
                                                (prefs!
                                                            .getStringList("fav")
                                                            ?.contains(snapshot
                                                                .data
                                                                .docs[index]
                                                                .reference
                                                                .id) ??
                                                        false)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                size: 25,
                                                color: AppColors.DarkBlue,
                                              ),
                                            ),
                                          
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 9, vertical: 8),
                                            margin: EdgeInsets.only(
                                                top: 10, left: 7, right: 7),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: Border.all(
                                                  color: Color.fromARGB(
                                                      255, 197, 196, 196)),
                                            ),
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) {
                                                          return ShowProduct(
                                                            data: snapshot.data
                                                                .docs[index]
                                                                .data(),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Expanded(
                                                    flex: 1,
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.all(10),
                                                      height: 100,
                                                      width: 100,
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                '${snapshot.data.docs[index]['imageurl']}'),
                                                            fit: BoxFit.cover),
                                                        color: const Color
                                                            .fromARGB(
                                                            255, 197, 196, 196),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            '${snapshot.data.docs[index].data()['title']}',
                                                            style: AppFonts
                                                                .DarkBLue_14,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                        SizedBox(
                                                          height: 7,
                                                        ),
                                                        Text(
                                                          '${snapshot.data.docs[index].data()['content']}',
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          style: AppFonts
                                                              .light_grey_12,
                                                        ),
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  top: 20),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Icon(
                                                                    Icons
                                                                        .timer_outlined,
                                                                    color: AppColors
                                                                        .DarkBlue,
                                                                    size: 20,
                                                                  ),
                                                                  Text(
                                                                    '${snapshot.data.docs[index].data()['date']}',
                                                                    style: AppFonts
                                                                        .DarkBLue_10,
                                                                  ),
                                                                ],
                                                              ),
                                                              InkWell(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .push(
                                                                          MaterialPageRoute(
                                                                    builder:
                                                                        (context) {
                                                                      return ShowMap(
                                                                          lat: double.parse(
                                                                              '${snapshot.data.docs[index]['lat']}'),
                                                                          long:
                                                                              double.parse('${snapshot.data.docs[index]['long']}'));
                                                                    },
                                                                  ));
                                                                },
                                                                child: Row(
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .location_on,
                                                                      color: AppColors
                                                                          .DarkBlue,
                                                                      size: 20,
                                                                    ),
                                                                    Text(
                                                                      'الموقع',
                                                                      style: AppFonts
                                                                          .DarkBLue_10,
                                                                    ),
                                                                  ],
                                                                ),
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
                                    },
                                  )
                                : Center(
                                    child: Text(
                                      '',
                                      style: AppFonts.DarkBLue_12,
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
