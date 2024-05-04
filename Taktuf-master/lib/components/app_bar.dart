import 'package:flutter/material.dart';
import 'package:takatuf/theme/colors.dart';
import 'package:takatuf/theme/fonts.dart';
 

Widget CustomAppBar() {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
                height: 50,
                width: 50,
                child: Image.asset('assets/images/profile.jpg')),
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
                  'takatuf_v0',
                  style: AppFonts.DarkBLue_16,
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.notifications,
            color: AppColors.DarkBlue,
          ),
        ),
      ],
    ),
  );
}
