import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:takatuf/main.dart';
import 'package:takatuf/screens/chat.dart';
import 'package:takatuf/theme/fonts.dart';

class Rooms extends StatefulWidget {
  var r1;
  var r2;
  Rooms({this.r1, this.r2});

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  String? userid = prefs!.getString('id');
  var rooms;

  getRooms() async {
    print(userid);
    rooms = await FirebaseFirestore.instance
        .collection('rooms')
        .where(
          Filter.or(
            Filter('userid1', isEqualTo: userid),
            Filter('userid2', isEqualTo: userid),
          ),
        )
        .snapshots();
    setState(() {});
  }

  @override
  void initState() {
    getRooms();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0,
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
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
              ],
            ),
          ],
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: notification(context))
        ],
      ),
      body: StreamBuilder(
        stream: rooms,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return Chat(
                                    roomid:
                                        snapshot.data.docs[index].reference.id,
                                    imageUrl: (snapshot.data.docs[index]
                                                .data()['userid1'] !=
                                            "${userid}"
                                        ? snapshot.data.docs[index]
                                            .data()['imageurl1']
                                        : snapshot.data.docs[index]
                                            .data()['imageurl2']),
                                    name: snapshot.data.docs[index]
                                                .data()['userid1'] !=
                                            "${userid}"
                                        ? snapshot.data.docs[index]
                                            .data()['username1']
                                        : snapshot.data.docs[index]
                                            .data()['username2'],
                                    id: snapshot.data.docs[index].data()['userid1'] !=
                                            "${userid}"
                                        ? snapshot.data.docs[index]
                                            .data()['userid1']
                                        : snapshot.data.docs[index]
                                            .data()['userid2']);
                              },
                            ),
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(bottom: 10),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.grey),
                            ),
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              snapshot.data.docs[index].data()['userid1'] !=
                                      "${userid}"
                                  ? Expanded(
                                      child: CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: snapshot
                                                    .data.docs[index]
                                                    .data()['imageurl1'] !=
                                                null
                                            ? NetworkImage(snapshot
                                                .data.docs[index]
                                                .data()['imageurl1'])
                                            : NetworkImage(
                                                "https://www.iconpacks.net/icons/5/free-no-profile-picture-icon-15257-thumb.png"),
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey,
                                      backgroundImage: snapshot.data.docs[index]
                                                  .data()['imageurl2'] !=
                                              null
                                          ? NetworkImage(snapshot
                                              .data.docs[index]
                                              .data()['imageurl2'])
                                          : NetworkImage(
                                              "https://www.iconpacks.net/icons/5/free-no-profile-picture-icon-15257-thumb.png"),
                                    ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  snapshot.data.docs[index].data()['userid1'] !=
                                          "${prefs!.getString('id')}"
                                      ? snapshot.data.docs[index]
                                          .data()['username1']
                                      : snapshot.data.docs[index]
                                          .data()['username2'],
                                  style: AppFonts.DarkBLue_14,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat,
                        color: const Color.fromARGB(255, 214, 212, 212),
                        size: 100,
                      ),
                      Text(
                        'لا يوجد محادثات',
                        style: AppFonts.grey_14,
                      )
                    ],
                  ),
                );
        },
      ),
    );
  }
}
