import 'package:flutter/material.dart';
import 'package:takatuf/theme/colors.dart';
import 'package:takatuf/theme/fonts.dart';
 
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
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
        title: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width / 1,
          child: Text(
            'الاشعارات',
            style: AppFonts.DarkBLue_16,
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              alignment: Alignment.topCenter,
              height: 100,
              child: Icon(
                Icons.notifications,
                color: AppColors.DarkBlue,
              ),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_active,
              color: const Color.fromARGB(255, 214, 212, 212),
              size: 100,
            ),
            Text(
              'لا يوجد تنبيهات',
              style: AppFonts.grey_14,
            )
          ],
        ),
      ),
    );
  }
}
