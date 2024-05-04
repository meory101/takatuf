// import 'package:flutter/material.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import 'package:takatuf/onboardingscreen/intro_page1.dart';
// import 'package:takatuf/onboardingscreen/intro_page2.dart';
// import 'package:takatuf/onboardingscreen/intro_page3.dart';
 
// class Page1 extends StatefulWidget {
//   const Page1({super.key});

//   @override
//   State<Page1> createState() => _Page1State();
// }

// class _Page1State extends State<Page1> {
//   PageController _controller = PageController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Stack(
//       children: [
//         //pageview
//         PageView(
//           controller: _controller,
//           children: [
//             intro_page1(),
//             intro_page2(),
//             intro_page3(),
//           ],
//         ),
//         Container(
//             alignment: Alignment(0, 0.65),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 // RecButton(
//                 //     label: Text("البدء"),
//                 //     width: 20,
//                 //     height: 30,
//                 //     color: Colors.black),
//                 SmoothPageIndicator(controller: _controller, count: 3),
//               ],
//             ))
//       ],
//     ));
//   }
// }
