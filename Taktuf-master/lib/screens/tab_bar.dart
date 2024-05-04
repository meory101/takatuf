import 'package:flutter/material.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:takatuf/screens/add_product.dart';
import 'package:takatuf/screens/home.dart';
import 'package:takatuf/screens/profile.dart';
import 'package:takatuf/screens/rooms.dart';
import 'package:takatuf/screens/settings.dart';
import 'package:takatuf/theme/colors.dart';
import 'package:takatuf/theme/fonts.dart';
 
class CustomBottomTabBar extends StatefulWidget {
  int? index;
  CustomBottomTabBar({this.index});
  @override
  State<CustomBottomTabBar> createState() => _CustomBottomTabBarState();
}

class _CustomBottomTabBarState extends State<CustomBottomTabBar> {
  late int _selectedIndex = 2;
  @override
  void initState() {
    if (widget.index != null) {
      print('done');
      _selectedIndex = widget.index!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: AppColors.DarkBlue,
        items: [
          CurvedNavigationBarItem(
            labelStyle: AppFonts.DarkBLue_12,
            child: Icon(
              Icons.home_outlined,
              color: AppColors.DarkBlue,
            ),
            label: 'الرئيسية',
          ),
          CurvedNavigationBarItem(
            labelStyle: AppFonts.DarkBLue_12,
            child: Icon(
              Icons.mail_outline_outlined,
              color: AppColors.DarkBlue,
            ),
            label: 'المحادثة',
          ),
          CurvedNavigationBarItem(
            labelStyle: AppFonts.DarkBLue_12,
            child: Icon(
              Icons.add_circle,
              color: AppColors.DarkBlue,
            ),
            label: 'اضافة',
          ),
          CurvedNavigationBarItem(
            labelStyle: AppFonts.DarkBLue_12,
            child: Icon(
              Icons.person,
              color: AppColors.DarkBlue,
            ),
            label: 'البروفايل',
          ),
          CurvedNavigationBarItem(
            labelStyle: AppFonts.DarkBLue_12,
            child: Icon(
              Icons.menu,
              color: AppColors.DarkBlue,
            ),
            label: 'خيارات',
          ),
        ],
        onTap: (index) {
          _selectedIndex = index;
          setState(() {});
        },
      ),
      body: _selectedIndex == 0
          ? const Home()
          : _selectedIndex == 1
              ?  Rooms(
               
              )
              : _selectedIndex == 2
                  ? const AddProduct()
                  : _selectedIndex == 3
                      ? const Profile()
                      : Settings(),
    );
  }
}
