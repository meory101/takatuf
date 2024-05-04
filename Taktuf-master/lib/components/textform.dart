// import 'package:flutter/material.dart';
  
// class Textform extends StatelessWidget {
//   const   Textform(
//       {super.key,
//       required this.controller,
//       required this.text,
//       required this.textInputType,
//       required this.obscure,
//       this.val,
//       this.pre_icon,
//       this.suf_icon,

//       required this.color,
//       required this.height,
//       required this.width,
//       this.style});
//   final TextEditingController controller;
//   final String text;
//   final TextInputType textInputType;
//   final bool obscure;
//   final String? Function(String?)? val;
//   final Color color;
//   final Icon? pre_icon;
//   final IconButton? suf_icon;
//   final double height;
//   final double width;
//   final TextStyle? style;


//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       width: width,
//       padding: EdgeInsets.only(left: 15),
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(6),
//           boxShadow: [
//             BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 7)
//           ]),
//       child: TextFormField(
        
//           obscuringCharacter: '*',
//           style: style,
//            controller: controller,
//           keyboardType: textInputType,
//           obscureText: obscure,
//           decoration: InputDecoration(
//             prefixIcon: pre_icon,
//             suffixIcon:suf_icon ,
//              hintText: text,
//             border: InputBorder.none,
//           )),
//     );
//   }
// }
