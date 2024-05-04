import 'package:flutter/material.dart';
 import 'package:takatuf/theme/colors.dart';
 class Textform extends StatelessWidget {
  const Textform(
      {super.key,
      this.controller,
      this.minlines,
      required this.text,
      required this.textInputType,
      required this.obscure,
      this.val,
      this.pre_icon,
      this.suf_icon,
      this.height,
      required this.width,
      this.readonly,
      this.style});
  final TextEditingController? controller;
  final String text;
  final TextInputType textInputType;
  final bool obscure;
  final String? Function(String?)? val;
  final Widget? pre_icon;
  final IconButton? suf_icon;
  final double? height;
  final double width;
  final bool? readonly;
  final int? minlines;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height ?? height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.black12),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: TextFormField(
            keyboardType: textInputType,
            validator: val??val,
            style: style ?? style,
            maxLines: minlines,
            controller: controller,
            textAlign: TextAlign.center,
            readOnly: readonly != null ? readonly! : false,
            cursorColor: AppColors.DarkBlue,
            // obscureText: obscure,
            decoration: InputDecoration(
              
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.Red),
              ),
              prefixIcon: pre_icon,
              suffixIcon: suf_icon,
              hintStyle: style,
              hintText: text,
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
