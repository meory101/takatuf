import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:jiffy/jiffy.dart';
 
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:takatuf/components/textform2.dart';
import 'package:takatuf/main.dart';
import 'package:takatuf/theme/colors.dart';
import 'package:takatuf/theme/fonts.dart';

class Chat extends StatefulWidget {
  String roomid;
  String name;
  var imageUrl;
  String id;
  Chat(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.roomid,
      required this.id});
  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var messages;
  getMessages() async {
    messages = FirebaseFirestore.instance
        .collection('message')
        .where('roomid', isEqualTo: widget.roomid)
        //
        .snapshots();
    setState(() {});
  }

  @override
  void initState() {
    print(widget.imageUrl);
    getMessages();
    super.initState();
  }

  String currentUserID = "${prefs!.getString('id')}";
  TextEditingController message = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 70,
        // color: Colors.red,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () async {
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
                  await FirebaseFirestore.instance.collection('message').add({
                    'content': message.text,
                    'date': Jiffy.now().yMd,
                    'senderid': currentUserID,
                    'recieverid': widget.id,
                    'roomid': widget.roomid
                  }).then((value) {
                    Navigator.of(context).pop();
                    message.clear();
                    setState(() {});
                  });
                },
                child: CircleAvatar(
                  backgroundColor: AppColors.DarkBlue,
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 7,
            ),
            Expanded(
              flex: 4,
              child: Textform(
                controller: message,
                text: '',
                style: AppFonts.grey_14,
                textInputType: TextInputType.text,
                obscure: false,
                width: MediaQuery.of(context).size.width / 1.6,
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 70,
        title: Container(
          padding: const EdgeInsets.only(bottom: 4),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: AppColors.DarkBlue,
                    size: 17,
                  )),
              widget.imageUrl == null
                  ? CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage('assets/images/profile.png'),
                    )
                  : CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(widget.imageUrl),
                    ),
              const SizedBox(
                width: 5,
              ),
              Text(
                widget.name,
                style: AppFonts.DarkBLue_14,
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder(
        stream: messages,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? Container(
                  padding: EdgeInsets.only(bottom: 100),
                  child: ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Container(
                          width: double.infinity,
                          child: snapshot.data.docs[index].data()['senderid'] ==
                                  currentUserID
                              ? ChatBubble(
                                  clipper: ChatBubbleClipper2(
                                      type: BubbleType.sendBubble),
                                  alignment: Alignment.topRight,
                                  margin: EdgeInsets.only(top: 20),
                                  backGroundColor: AppColors.DarkBlue,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                    ),
                                    child: Text(
                                      snapshot.data.docs[index]
                                          .data()['content'],
                                      style: AppFonts.white_14,
                                    ),
                                  ),
                                )
                              : ChatBubble(
                                  clipper: ChatBubbleClipper1(
                                      type: BubbleType.receiverBubble),
                                  alignment: Alignment.topLeft,
                                  margin: EdgeInsets.only(top: 20),
                                  backGroundColor:
                                      const Color.fromARGB(255, 192, 191, 191),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.5,
                                    ),
                                    child: Text(
                                      snapshot.data.docs[index]
                                          .data()['content'],
                                      style: AppFonts.white_14,
                                    ),
                                  ),
                                ));
                    },
                  ),
                )
              : const Text('');
        },
      ),
    );
  }
}
